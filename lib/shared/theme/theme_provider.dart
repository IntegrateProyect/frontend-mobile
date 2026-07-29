import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void setDarkMode(bool enabled) {
    final newMode = enabled
        ? ThemeMode.dark
        : ThemeMode.light;

    if (_themeMode == newMode) return;

    _themeMode = newMode;
    notifyListeners();
  }

  void toggleTheme() {
    setDarkMode(!isDarkMode);
  }
}