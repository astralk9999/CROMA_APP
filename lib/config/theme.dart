import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color brandRed = Color(0xFFE60000);

  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: black,
      scaffoldBackgroundColor: white,
      colorScheme: const ColorScheme.light(
        primary: black,
        secondary: brandRed,
        surface: white,
        error: brandRed,
        onPrimary: white,
        onSecondary: white,
        onSurface: black,
      ),

      // Typography
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 42,
          fontWeight: FontWeight.w900,
          color: black,
          letterSpacing: -1.5,
          fontStyle: FontStyle.italic,
        ),
        displayMedium: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 34,
          fontWeight: FontWeight.w900,
          color: black,
          letterSpacing: -0.5,
          fontStyle: FontStyle.italic,
        ),
        displaySmall: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 28,
          fontWeight: FontWeight.w900,
          color: black,
          fontStyle: FontStyle.italic,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: black,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: black,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: black,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: black,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: black),
        bodyMedium: TextStyle(fontSize: 14, color: gray800),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          color: white,
        ),
      ),

      // Button Styles
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: black,
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Urban sharp edges
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: black,
          side: const BorderSide(color: black, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: black,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: black,
          letterSpacing: -0.5,
        ),
      ),

      // Inputs
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: gray300, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: gray300, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: black, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        contentPadding: EdgeInsets.all(16),
        labelStyle: TextStyle(color: gray600),
      ),
    );
  }
}
