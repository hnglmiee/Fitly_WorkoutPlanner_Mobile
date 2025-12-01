import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF0091FF);
  static const Color secondary = Color(0xFFB7E0FF);
  static const Color third = Color(0xFFEDF7FF);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: Colors.white,
        secondary: secondary,
        onSecondary: Colors.black,
        error: Colors.red,
        onError: Colors.white,
        background: third,
        onBackground: Colors.black,
        surface: Colors.white,
        onSurface: Colors.black,
      ),

      textTheme: TextTheme(
        headlineLarge: GoogleFonts.manrope(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.manrope(fontSize: 14),
        bodyMedium: GoogleFonts.manrope(fontSize: 13),
        bodySmall: GoogleFonts.manrope(fontSize: 12, color: Colors.black54),
      ),

      iconTheme: const IconThemeData(color: primary, size: 24),
    );
  }
}
