import 'package:flutter/material.dart';

/// App theme configuration
class AppTheme {
  /// Private constructor to prevent instantiation
  AppTheme._();

  // Color constants
  static const Color _primaryColor = Color(0xFF4CAF50);
  static const Color _secondaryColor = Color(0xFF2E7D32);
  static const Color _errorColor = Color(0xFFD32F2F);
  static const Color _backgroundColor = Color(0xFFF5F5F5);
  static const Color _cardColor = Colors.white;

  // Dark theme colors
  static const Color _darkPrimaryColor = Color(0xFF388E3C);
  static const Color _darkSecondaryColor = Color(0xFF66BB6A);
  static const Color _darkBackgroundColor = Color(0xFF121212);
  static const Color _darkCardColor = Color(0xFF1E1E1E);

  /// Light theme configuration
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: _primaryColor,
      secondary: _secondaryColor,
      error: _errorColor,
      // background: _backgroundColor,
      surface: _backgroundColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: const CardTheme(
      color: _cardColor,
      elevation: 2,
      margin: EdgeInsets.all(8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _secondaryColor,
      foregroundColor: Colors.white,
    ),
    dividerTheme: const DividerThemeData(
      thickness: 1,
      space: 16,
    ),
  );

  /// Dark theme configuration
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: _darkPrimaryColor,
      secondary: _darkSecondaryColor,
      error: _errorColor,
      surface: _darkBackgroundColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _darkPrimaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: const CardTheme(
      color: _darkCardColor,
      elevation: 2,
      margin: EdgeInsets.all(8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkPrimaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _darkSecondaryColor,
      foregroundColor: Colors.white,
    ),
    dividerTheme: const DividerThemeData(
      thickness: 1,
      space: 16,
      color: Colors.grey,
    ),
  );
}
