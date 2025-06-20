import 'package:flow/model/data.dart';
import 'package:flow/services/database_servieces.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class HistoryProvider with ChangeNotifier {
  DateTime? _selectedDate;

  DateTime? get selectedDate => _selectedDate;

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
}


class HistoryDataProvider extends ChangeNotifier {
  DateTime selectedDate = DateTime.now(); // Initially current month
  List<Data> monthlyTransactions = [];

  double totalCredited = 0.0;
  double totalDebited = 0.0;

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await DatabaseService.instance.database;
    return _db!;
  }

  void setMonth(DateTime newDate) {
    selectedDate = newDate;
    loadTransactionsForSelectedMonth();
    notifyListeners();
  }

  void goToPreviousMonth() {
    selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
    loadTransactionsForSelectedMonth();
    notifyListeners();
  }

  void goToNextMonth() {
    selectedDate = DateTime(selectedDate.year, selectedDate.month + 1);
    loadTransactionsForSelectedMonth();
      notifyListeners();
    }

      Future<void> loadTransactionsForSelectedMonth() async {
    final db = await database;
  
    // Start of the month
    final start = DateTime(selectedDate.year, selectedDate.month, 1);
  
    // End of the month — inclusive up to the LAST SECOND
    final end = DateTime(selectedDate.year, selectedDate.month + 1, 0, 23, 59, 59);
  
    final result = await db.query(
      'data',
      where: 'date >= ? AND date <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC, time DESC', // Sort by newest date & time first
    );
  
    monthlyTransactions = result.map((e) => Data(
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
  
    calculateTotals();
    notifyListeners();
  }
  
  void calculateTotals() {
    totalCredited = 0.0;
    totalDebited = 0.0;

    for (var item in monthlyTransactions) {
      if (item.transactionType.toLowerCase() == 'credit') {
        totalCredited += item.amount ?? 0.0;
      } else if (item.transactionType.toLowerCase() == 'debit') {
        totalDebited += item.amount ?? 0.0;
      }
    }
  }
}
