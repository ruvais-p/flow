import 'package:flutter/material.dart';

class TrendingPageProvider with ChangeNotifier {
  int _currentPage = 0;
  
  int get currentPage => _currentPage;
  
  set currentPage(int index) {
    if (_currentPage != index) {
      _currentPage = index;
      // Add a small delay to batch updates and reduce rebuilds
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }
  
  // Alternative method with debouncing for even better performance
  void updateCurrentPage(int index) {
    if (_currentPage != index) {
      _currentPage = index;
      notifyListeners();
    }
  }
}

class ChartTabProvider with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }
}
