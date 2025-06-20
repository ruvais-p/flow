import 'package:flow/screens/history_screen/services/history_db_services.dart';
import 'package:flutter/material.dart';
import 'package:flow/model/data.dart';

class HistoryDataProvider extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  List<Data> monthlyTransactions = [];

  double totalCredited = 0.0;
  double totalDebited = 0.0;

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
}
