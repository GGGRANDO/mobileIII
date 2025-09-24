import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  Color _appBarColor = Colors.blue;

  Color get appBarColor => _appBarColor;

  void setAppBarColor(Color color) {
    _appBarColor = color;
    notifyListeners();
  }
}
