import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider extends ChangeNotifier with WidgetsBindingObserver {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

  ThemeMode get themeMode => _themeMode;

  /// Resuelve el modo actual contra el brillo del sistema cuando
  /// _themeMode == system, o devuelve directamente light/dark si fue fijado.
  bool get isDarkMode {
    switch (_themeMode) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        final brightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        return brightness == Brightness.dark;
    }
  }

  void setDarkMode(bool enabled) {
    final newMode = enabled ? ThemeMode.dark : ThemeMode.light;

    if (_themeMode == newMode) return;

    _themeMode = newMode;
    notifyListeners();
  }

  void toggleTheme() {
    setDarkMode(!isDarkMode);
  }

  /// Vuelve a seguir el tema del sistema.
  void useSystemTheme() {
    if (_themeMode == ThemeMode.system) return;
    _themeMode = ThemeMode.system;
    notifyListeners();
  }

  @override
  void didChangePlatformBrightness() {
    // Solo nos importa si estamos en modo "system": ahí el brillo
    // efectivo cambia en vivo y hay que notificar a los listeners
    // (toggles, MaterialApp, etc.).
    if (_themeMode == ThemeMode.system) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}