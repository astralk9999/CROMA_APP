import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // CROMA Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF4F4F5);
  static const Color gray200 = Color(0xFFE4E4E7);
  static const Color gray300 = Color(0xFFD4D4D8);
  static const Color gray400 = Color(0xFFA1A1AA);
  static const Color gray500 = Color(0xFF71717A);
  static const Color gray600 = Color(0xFF52525B);
  static const Color gray800 = Color(0xFF27272A);
  static const Color gray900 = Color(0xFF202020);
  static const Color brandRed = Color(0xFFE53935);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: white,
      primaryColor: black,
      colorScheme: const ColorScheme.light(
        primary: black,
        secondary: gray900,
        surface: white,
        error: brandRed,
        onPrimary: white,
        onSecondary: white,
        onSurface: black,
        onError: white,
      ),
      textTheme: TextTheme(
        // Urban brand font replacement (Oswald / Bebas Neue)
        displayLarge: GoogleFonts.oswald(
          color: black,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          textStyle: const TextStyle(letterSpacing: -1.5),
        ),
        displayMedium: GoogleFonts.oswald(
          color: black,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          textStyle: const TextStyle(letterSpacing: -1.0),
        ),
        displaySmall: GoogleFonts.oswald(
          color: black,
          fontWeight: FontWeight.w900,
          textStyle: const TextStyle(letterSpacing: -0.5),
        ),
        headlineMedium: GoogleFonts.oswald(
          color: black,
          fontWeight: FontWeight.w900,
        ),
        // Monospace for tags
        labelSmall: GoogleFonts.robotoMono(
          color: gray500,
          fontWeight: FontWeight.w900,
          textStyle: const TextStyle(letterSpacing: 2.0),
        ),
        // Standard text
        bodyLarge: GoogleFonts.inter(color: black, fontWeight: FontWeight.w500),
        bodyMedium: GoogleFonts.inter(
          color: gray600,
          fontWeight: FontWeight.w500,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: black,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: black,
          foregroundColor: white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Industrial square corners
          ),
          textStyle: GoogleFonts.oswald(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 1.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: black,
          backgroundColor: Colors.transparent,
          side: const BorderSide(color: black, width: 2),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: GoogleFonts.oswald(
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 1.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: black, width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: gray300, width: 2),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: black, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: brandRed, width: 2),
        ),
        labelStyle: GoogleFonts.inter(
          color: gray500,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }
}
