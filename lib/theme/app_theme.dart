import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Theme Colors
  static const Color primary = Color(0xFF0091FF);
  static const Color secondary = Color(0xFFB7E0FF);
  static const Color third = Color(0xFFEDF7FF);
  static const Color lightBackground = Color(0xFFF8FAFC);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFFD3FF56);
  // static const Color darkSecondary = Color(0xFFDCFCB4);
  static const Color darkSecondary = Color(0xFF313130);
  static const Color darkThird = Color(0xFF3F403D);
  static const Color darkBackground = Color(0xFF1C1C1C); // Darker for better contrast
  static const Color darkText = Color(0xFFF6F8F1);

  /// =====================================================
  /// GRADIENT DEFINITIONS
  /// =====================================================

  /// Light Mode Gradient
  static BoxDecoration get lightGradientBackground {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primary.withOpacity(0.05),
          secondary.withOpacity(0.15),
          third.withOpacity(0.1),
        ],
        stops: const [0.0, 0.5, 1.0],
      ),
    );
  }

  /// Dark Mode Gradient
  static BoxDecoration get darkGradientBackground {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          darkThird.withOpacity(0.3),
          darkSecondary.withOpacity(0.5),
          darkBackground,
        ],
        stops: const [0.0, 0.5, 1.0],
      ),
    );
  }

  /// Subtle Light Gradient
  static BoxDecoration get subtleLightGradient {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white, lightBackground],
      ),
    );
  }

  /// Card Gradient
  static BoxDecoration cardGradient({Color? startColor, Color? endColor}) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [startColor ?? primary, endColor ?? secondary],
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: (startColor ?? primary).withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  /// Button Gradient
  static BoxDecoration get buttonGradient {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF0091FF), Color(0xFF00D4FF)],
      ),
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: primary.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// =====================================================
  /// THEMES
  /// =====================================================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      splashFactory: InkRipple.splashFactory,
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
          color: Colors.black,
        ),
        headlineMedium: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        titleMedium: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        bodyLarge: GoogleFonts.manrope(fontSize: 14, color: Colors.black),
        bodyMedium: GoogleFonts.manrope(fontSize: 13, color: Colors.black),
        bodySmall: GoogleFonts.manrope(fontSize: 12, color: Colors.black54),
      ),

      iconTheme: const IconThemeData(color: primary, size: 24),

      scaffoldBackgroundColor: Colors.white,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: darkPrimary,
        onPrimary: Colors.black,
        secondary: darkSecondary,
        onSecondary: darkText,
        error: Colors.redAccent,
        onError: Colors.black,
        background: darkThird,
        onBackground: darkText,
        surface: darkSecondary,
        onSurface: darkText,
      ),

      textTheme: TextTheme(
        headlineLarge: GoogleFonts.manrope(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: darkText,
        ),
        headlineMedium: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: darkText,
        ),
        titleMedium: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkText,
        ),
        bodyLarge: GoogleFonts.manrope(fontSize: 14, color: darkText),
        bodyMedium: GoogleFonts.manrope(fontSize: 13, color: darkText),
        bodySmall: GoogleFonts.manrope(
          fontSize: 12,
          color: darkText.withOpacity(0.7),
        ),
      ),

      iconTheme: const IconThemeData(color: darkPrimary, size: 24),

      scaffoldBackgroundColor: darkBackground,

      // Additional dark theme styling
      appBarTheme: AppBarTheme(
        backgroundColor: darkSecondary,
        foregroundColor: darkText,
        elevation: 0,
      ),

      cardTheme: CardThemeData(
        color: darkSecondary,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: Colors.black,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
