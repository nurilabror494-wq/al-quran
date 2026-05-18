import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.green,
      primaryColor: const Color(0xFF0D9A5B),
      scaffoldBackgroundColor: const Color(0xFFF6F8FA),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0D9A5B),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF0D9A5B),
        secondary: Color(0xFF13C474),
        surface: Colors.white,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(color: Colors.black87),
        bodySmall: TextStyle(color: Colors.black54),
      ),
      useMaterial3: true,
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.green,
      primaryColor: const Color(0xFF13C474),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF13C474),
        secondary: Color(0xFF0D9A5B),
        surface: Color(0xFF1E1E1E),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(color: Colors.white70),
        bodySmall: TextStyle(color: Colors.white54),
      ),
      useMaterial3: true,
    );
  }
}
