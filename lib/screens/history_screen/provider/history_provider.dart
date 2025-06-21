import 'package:decimal/decimal.dart';
import 'package:flow/screens/history_screen/services/history_db_services.dart';
import 'package:flutter/material.dart';
import 'package:flow/model/data.dart';

class HistoryDataProvider extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  List<Data> monthlyTransactions = [];

  Decimal totalCredited = Decimal.zero;
  Decimal totalDebited = Decimal.zero;

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
    monthlyTransactions = await HistoryDBServices.instance.getTransactionsForMonth(selectedDate);
    calculateTotals();
    notifyListeners();
    
  }

  void calculateTotals() {
  totalCredited = Decimal.zero;
  totalDebited = Decimal.zero;

  for (var item in monthlyTransactions) {
    final amount = Decimal.parse((item.amount ?? 0.0).toString());
    if (item.transactionType.toLowerCase() == 'credit') {
      totalCredited += amount;
    } else if (item.transactionType.toLowerCase() == 'debit') {
      totalDebited += amount;
    }
  }
}

  Future<void> updateCategory(int id, String newCategory) async {
    await HistoryDBServices.instance.updateTransactionCategory(id, newCategory);
    loadTransactionsForSelectedMonth();
    notifyListeners();
  }

  void updateTransactionCategory(int id, String newCategory) {
    int index = monthlyTransactions.indexWhere((tx) => tx.id == id);
    if (index != -1) {
      monthlyTransactions[index].category = newCategory;
      notifyListeners();
    }
  }

  Map<String, double> get debitCategoryPieData {
  final Map<String, double> dataMap = {};
  for (var item in monthlyTransactions) {
    if (item.transactionType.toLowerCase() == 'debit') {
      dataMap[item.category] = (dataMap[item.category] ?? 0) + (item.amount ?? 0);
    }
  }
  return dataMap;
}

Map<String, double> get creditCategoryPieData {
  final Map<String, double> dataMap = {};
  for (var item in monthlyTransactions) {
    if (item.transactionType.toLowerCase() == 'credit') {
      dataMap[item.category] = (dataMap[item.category] ?? 0) + (item.amount ?? 0);
    }
  }
  return dataMap;
}


  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

}
