import 'package:flow/model/chart.dart';
import 'package:flow/services/database_servieces.dart';
import 'package:sqflite/sqflite.dart';

class AnalysticDbServices {
  static final AnalysticDbServices instance = AnalysticDbServices._internal();
  AnalysticDbServices._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await DatabaseService.instance.database;
    return _db!;
  }

  Future<List<Map<String, dynamic>>> fetchMonthlyCreditDebit() async {
    final db = await database;

    return await db.rawQuery('''
      SELECT 
        strftime('%Y-%m', date) as month,
        SUM(CASE WHEN transaction_type = 'CREDIT' THEN amount ELSE 0 END) AS total_credited,
        SUM(CASE WHEN transaction_type = 'DEBIT' THEN amount ELSE 0 END) AS total_debited
      FROM data
      GROUP BY month
      ORDER BY month;
    ''');
  }

  Future<List<Map<String, dynamic>>> fetchYearlyCreditDebit() async {
    final db = await database;

    return await db.rawQuery('''
      SELECT 
        strftime('%Y', date) as year,
        SUM(CASE WHEN transaction_type = 'CREDIT' THEN amount ELSE 0 END) AS total_credited,
        SUM(CASE WHEN transaction_type = 'DEBIT' THEN amount ELSE 0 END) AS total_debited
      FROM data
      GROUP BY year
      ORDER BY year;
    ''');
  }

  Future<List<ChartData>> fetchCategoryCreditDebitByYear(int year, String type) async {
  final db = await database;

  final result = await db.rawQuery('''
    SELECT 
      category,
      SUM(amount) as total
    FROM data
    WHERE transaction_type = ? AND strftime('%Y', date) = ?
    GROUP BY category
  ''', [type.toUpperCase(), year.toString()]);

  return result.map((row) {
    return ChartData(
      row['category']?.toString() ?? 'Unknown',
      double.tryParse(row['total']?.toString() ?? '0') ?? 0,
    );
  }).toList();
}
}
