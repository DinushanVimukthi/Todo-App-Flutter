import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // ThemeData _currentTheme = MediaQueryData.fromView(WidgetsBinding.instance!.window).platformBrightness == Brightness.dark ? ThemeData.dark() : ThemeData.light();
  ThemeData _currentTheme = ThemeData.dark();



  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    _currentTheme = (_currentTheme == ThemeData.light()) ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }
}
