import 'package:flow/model/data.dart';
import 'package:flow/model/weekexpenss.dart';
import 'package:flow/services/database_servieces.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class HomepageDbServices {
  static final HomepageDbServices instance = HomepageDbServices._constructor();
  HomepageDbServices._constructor();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await DatabaseService.instance.database;
    return _db!;
  }


Future<List<WeakExpenss>> fetchLastMonthData(String transactionType) async {
  final db = await database;

  final result = await db.rawQuery('''
    SELECT 
      strftime('%d', date) as day, 
      SUM(amount) as total 
    FROM data 
    WHERE transaction_type = ? 
      AND strftime('%Y-%m', date) = strftime('%Y-%m', 'now', '-1 month') 
    GROUP BY day
    ORDER BY day
  ''', [transactionType]);

  // Calculate total days in last month
  final now = DateTime.now();
  final DateTime lastMonth = DateTime(now.year, now.month - 1, 1);
  final daysInLastMonth = DateUtils.getDaysInMonth(lastMonth.year, lastMonth.month);

  // Pre-fill all days of last month
  final Map<String, double> map = {
    for (int i = 1; i <= daysInLastMonth; i++) i.toString().padLeft(2, '0'): 0.0
  };

  for (final row in result) {
    final day = row['day'].toString().padLeft(2, '0');
    final total = double.tryParse(row['total'].toString()) ?? 0.0;
    map[day] = total;
  }

  return map.entries
      .map((e) => WeakExpenss(e.key, e.value))
      .toList();
}


Future<List<WeakExpenss>> fetchMonthlyData(String transactionType) async {
  final db = await database;

  final result = await db.rawQuery('''
    SELECT 
      strftime('%d', date) as day, 
      SUM(amount) as total 
    FROM data 
    WHERE transaction_type = ? 
      AND strftime('%Y-%m', date) = strftime('%Y-%m', 'now') 
    GROUP BY day
    ORDER BY day
  ''', [transactionType]);

  final now = DateTime.now();
  final currentDay = now.day; // ← only go up to today's date

  // Pre-fill only days from 1 to today
  final Map<String, double> map = {
    for (int i = 1; i <= currentDay; i++) i.toString().padLeft(2, '0'): 0.0
  };

  for (final row in result) {
    final day = row['day'].toString().padLeft(2, '0');
    final total = double.tryParse(row['total'].toString()) ?? 0.0;
    map[day] = total;
  }

  return map.entries
      .map((e) => WeakExpenss(e.key, e.value))
      .toList();
}



Future<List<WeakExpenss>> fetchWeeklyData(String transactionType) async {
  final db = await database;

  final result = await db.rawQuery('''
    SELECT 
      strftime('%w', date) as weekday, 
      SUM(amount) as total 
    FROM data 
    WHERE transaction_type = ? 
      AND date >= date('now', '-6 days') 
    GROUP BY weekday
  ''', [transactionType]);

  const weekdayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final Map<String, double> map = { for (var name in weekdayNames) name: 0.0 };

  for (final row in result) {
    final index = int.tryParse(row['weekday'].toString()) ?? 0;
    final name = weekdayNames[index];
    final amount = double.tryParse(row['total'].toString()) ?? 0.0;
    map[name] = amount;
  }

  return map.entries.map((e) => WeakExpenss(e.key, e.value)).toList();
}


Future<DateTime?> getLatestDateTime() async {
  final db = await DatabaseService.instance.database;

  final result = await db.rawQuery('''
    SELECT date, time FROM data 
    WHERE date IS NOT NULL AND time IS NOT NULL 
    ORDER BY date DESC, time DESC 
    LIMIT 1
  ''');

  if (result.isNotEmpty &&
      result.first['date'] != null &&
      result.first['time'] != null) {
    final dateStr = result.first['date'] as String;
    final timeStr = result.first['time'] as String;
    return DateTime.parse('$dateStr $timeStr');
  }

  return null;
}


Future<Map<DateTime, int>> getTransactionCountPerDayFromDb() async {
  final db = await database;

  final result = await db.rawQuery('''
    SELECT date, COUNT(*) AS transaction_count
    FROM data
    GROUP BY date
  ''');    

  final transactionCount = <DateTime, int>{};

  for (var row in result) {
    final dateString = row['date'] as String;
    final parsed = DateTime.tryParse(dateString);
    if (parsed != null) {
      // Normalize to start of day
      final day = DateTime(parsed.year, parsed.month, parsed.day);
      transactionCount[day] = row['transaction_count'] as int;
    }
  }
  
  return transactionCount;
}


// 2) Get all transactions done today
Future<List<Data>> getTodayTransactions() async {
  final db = await database;
  final now = DateTime.now();
  
  // Format today's date as YYYY-MM-DD
  final today = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  
  final result = await db.query(
    'data',
    where: 'date = ?',
    whereArgs: [today],
    orderBy: 'time DESC, id DESC', // Order by time (newest first)
  );
  
  return result.map((e) => Data(
    date: e['date'] as String? ?? '',
    time: e['time'] as String? ?? '',
    message: e['message'] as String? ?? '',
    amount: (e['amount'] is num) ? (e['amount'] as num).toDouble() : null,
    balance: (e['balance'] is num) ? (e['balance'] as num).toDouble() : null,
    consumer: e['consumer'] as String? ?? '',
    category: e['category'] as String? ?? '',
    upiid: e['upiid'] as String? ?? '',
    transactionType: e['transaction_type'] as String? ?? '',
    bank: e['bank'] as String? ?? '',
    callname: e['callname'] as String? ?? '',
  )).toList();
}


// 1) Get 10 most recent transactions
Future<List<Data>> getRecentTransactions({int limit = 10}) async {
  final db = await database;
  
  final result = await db.query(
    'data',
    orderBy: 'date DESC, time DESC, id DESC', // Order by date, time, then ID for consistency
    limit: limit,
  );
  
  return result.map((e) => Data(
    date: e['date'] as String? ?? '',
    time: e['time'] as String? ?? '',
    message: e['message'] as String? ?? '',
    amount: (e['amount'] is num) ? (e['amount'] as num).toDouble() : null,
    balance: (e['balance'] is num) ? (e['balance'] as num).toDouble() : null,
    consumer: e['consumer'] as String? ?? '',
    category: e['category'] as String? ?? '',
    upiid: e['upiid'] as String? ?? '',
    transactionType: e['transaction_type'] as String? ?? '',
    bank: e['bank'] as String? ?? '',
    callname: e['callname'] as String? ?? '',
  )).toList();
}


Future<Map<String, double>> getTodayAndMonthTotals() async {
  final db = await database;
  final now = DateTime.now();

  final today = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  final monthStart = '${now.year}-${now.month.toString().padLeft(2, '0')}-01';

  // TODAY
  final todayResult = await db.rawQuery('''
    SELECT
      IFNULL(SUM(CASE WHEN transaction_type = 'CREDIT' THEN CAST(amount AS REAL) ELSE 0 END), 0) AS todayCredited,
      IFNULL(SUM(CASE WHEN transaction_type = 'DEBIT' THEN CAST(amount AS REAL) ELSE 0 END), 0) AS todayDebited
    FROM data
    WHERE date = ?
  ''', [today]);

  // THIS MONTH
  final monthResult = await db.rawQuery('''
    SELECT
      IFNULL(SUM(CASE WHEN transaction_type = 'CREDIT' THEN CAST(amount AS REAL) ELSE 0 END), 0) AS monthCredited,
      IFNULL(SUM(CASE WHEN transaction_type = 'DEBIT' THEN CAST(amount AS REAL) ELSE 0 END), 0) AS monthDebited
    FROM data
    WHERE date >= ? AND date <= ?
  ''', [monthStart, today]);

  return {
    'todayCredited': (todayResult.first['todayCredited'] as num).toDouble(), 
    'todayDebited': (todayResult.first['todayDebited'] as num).toDouble(), 
    'monthCredited': (monthResult.first['monthCredited'] as num).toDouble(), 
    'monthDebited': (monthResult.first['monthDebited'] as num).toDouble(), 
  };
}

}