import 'package:flow/model/data.dart';
import 'package:flow/services/database_servieces.dart';
import 'package:sqflite/sqflite.dart';

class HistoryDBServices {
  static final HistoryDBServices instance = HistoryDBServices._internal();
  HistoryDBServices._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await DatabaseService.instance.database;
    return _db!;
  }

  Future<List<Data>> getTransactionsForMonth(DateTime selectedDate) async {
    final db = await database;

    final start = DateTime(selectedDate.year, selectedDate.month, 1);
    final end = DateTime(selectedDate.year, selectedDate.month + 1, 0, 23, 59, 59);

    final result = await db.query(
      'data',
      where: 'date >= ? AND date <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC, time DESC',
    );

    return result.map((e) => Data(
      id: e['id'] as int?, // ensure `id` is included in your model
      date: e['date'] as String? ?? '',
      time: e['time'] as String? ?? '',
      message: e['message'] as String? ?? '',
      amount: (e['amount'] is num) ? (e['amount'] as num).toDouble() : 0.0,
      balance: (e['balance'] is num) ? (e['balance'] as num).toDouble() : 0.0,
      consumer: e['consumer'] as String? ?? '',
      category: e['category'] as String? ?? '',
      upiid: e['upiid'] as String? ?? '',
      transactionType: e['transaction_type'] as String? ?? '',
      bank: e['bank'] as String? ?? '',
      callname: e['callname'] as String? ?? '',
    )).toList();
  }

  Future<void> updateTransactionCategory(int id, String newCategory) async {
    final db = await database;
    await db.update(
      'data',
      {'category': newCategory},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
