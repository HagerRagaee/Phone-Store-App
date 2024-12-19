import 'package:flutter/material.dart';

class ProvStore with ChangeNotifier {
  static const String storeItemsKey = "storeItems";

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void onTappedItem(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
