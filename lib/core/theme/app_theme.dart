import 'package:flutter/material.dart';

class AppTheme {
  // Common visual constants
  static const double borderRadius = 12.0;

  // Solid professional colors
  static const Color primaryLight = Color(0xFF04684A); // Deep Emerald
  static const Color primaryDark = Color(0xFF10B981); // Bright Emerald for dark mode
  
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate 50
  
  static const Color surfaceDark = Color(0xFF1E293B); // Slate 800
  static const Color backgroundDark = Color(0xFF0F172A); // Slate 900

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryLight,
      scaffoldBackgroundColor: backgroundLight,
      cardColor: surfaceLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceLight,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryLight,
        secondary: Color(0xFF0EA5E9), // Sky Blue for secondary accents
        surface: surfaceLight,
      ),
      cardTheme: CardThemeData(
        color: surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1), // Slate 200
        ),
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
      primaryColor: primaryDark,
      scaffoldBackgroundColor: backgroundDark,
      cardColor: surfaceDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryDark,
        secondary: Color(0xFF38BDF8), // Light Sky Blue for secondary
        surface: surfaceDark,
      ),
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: const BorderSide(color: Color(0xFF334155), width: 1), // Slate 700
        ),
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
