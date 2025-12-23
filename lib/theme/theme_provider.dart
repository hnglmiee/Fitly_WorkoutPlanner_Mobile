import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system; // Default to system
  bool _useSystemTheme = true;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get useSystemTheme => _useSystemTheme;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  /// Load theme từ SharedPreferences
  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if user wants to use system theme
    _useSystemTheme = prefs.getBool('useSystemTheme') ?? true;

    if (_useSystemTheme) {
      _themeMode = ThemeMode.system;
    } else {
      final isDark = prefs.getBool('isDarkMode') ?? false;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    }

    notifyListeners();
  }

  /// Toggle between light and dark (disables system theme)
  Future<void> toggleTheme() async {
    // Disable system theme when manually toggling
    _useSystemTheme = false;

    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useSystemTheme', false);
    await prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark);

    notifyListeners();
  }

  /// Enable system theme
  Future<void> useSystemThemeMode() async {
    _useSystemTheme = true;
    _themeMode = ThemeMode.system;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useSystemTheme', true);

    notifyListeners();
  }

  /// Set theme explicitly
  Future<void> setTheme(ThemeMode mode) async {
    if (mode == ThemeMode.system) {
      await useSystemThemeMode();
      return;
    }

    _useSystemTheme = false;
    _themeMode = mode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useSystemTheme', false);
    await prefs.setBool('isDarkMode', mode == ThemeMode.dark);

    notifyListeners();
  }

  /// Get current theme status for display
  String get currentThemeStatus {
    if (_useSystemTheme) return 'System';
    return _themeMode == ThemeMode.dark ? 'Dark' : 'Light';
  }
}
