// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color primaryColorDark = Color(0xFF1B5E20);
  static const Color primaryColorLight = Color(0xFF66BB6A);
  static const Color accentColor = Color(0xFFFF9800);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color textColorPrimary = Color(0xFF212121);
  static const Color textColorSecondary = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFE0E0E0);

  // Text Styles
  static TextStyle get headlineLarge => GoogleFonts.cairo(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColorPrimary,
      );

  static TextStyle get headlineMedium => GoogleFonts.cairo(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColorPrimary,
      );

  static TextStyle get headlineSmall => GoogleFonts.cairo(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColorPrimary,
      );

  static TextStyle get titleLarge => GoogleFonts.cairo(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColorPrimary,
      );

  static TextStyle get titleMedium => GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColorPrimary,
      );

  static TextStyle get titleSmall => GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColorPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textColorPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textColorPrimary,
      );

  static TextStyle get bodySmall => GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textColorSecondary,
      );

  static TextStyle get labelLarge => GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColorPrimary,
      );

  static TextStyle get labelMedium => GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColorPrimary,
      );

  static TextStyle get labelSmall => GoogleFonts.cairo(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textColorSecondary,
      );

  // Light Theme
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
          background: backgroundColor,
          surface: surfaceColor,
          error: errorColor,
        ),
        textTheme: TextTheme(
          headlineLarge: headlineLarge,
          headlineMedium: headlineMedium,
          headlineSmall: headlineSmall,
          titleLarge: titleLarge,
          titleMedium: titleMedium,
          titleSmall: titleSmall,
          bodyLarge: bodyLarge,
          bodyMedium: bodyMedium,
          bodySmall: bodySmall,
          labelLarge: labelLarge,
          labelMedium: labelMedium,
          labelSmall: labelSmall,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: titleLarge.copyWith(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: labelLarge.copyWith(color: Colors.white),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryColor,
            side: const BorderSide(color: primaryColor),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: labelLarge.copyWith(color: primaryColor),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: dividerColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: dividerColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: errorColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: errorColor, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          hintStyle: bodyMedium.copyWith(color: textColorSecondary),
          labelStyle: labelMedium.copyWith(color: textColorSecondary),
        ),
        cardTheme: CardThemeData(
          color: surfaceColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: surfaceColor,
          selectedItemColor: primaryColor,
          unselectedItemColor: textColorSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        dividerTheme: const DividerThemeData(
          color: dividerColor,
          thickness: 1,
        ),
        scaffoldBackgroundColor: backgroundColor,
      );

  // Dark Theme
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        ),
        textTheme: TextTheme(
          headlineLarge: headlineLarge.copyWith(color: Colors.white),
          headlineMedium: headlineMedium.copyWith(color: Colors.white),
          headlineSmall: headlineSmall.copyWith(color: Colors.white),
          titleLarge: titleLarge.copyWith(color: Colors.white),
          titleMedium: titleMedium.copyWith(color: Colors.white),
          titleSmall: titleSmall.copyWith(color: Colors.white),
          bodyLarge: bodyLarge.copyWith(color: Colors.white70),
          bodyMedium: bodyMedium.copyWith(color: Colors.white70),
          bodySmall: bodySmall.copyWith(color: Colors.white60),
          labelLarge: labelLarge.copyWith(color: Colors.white),
          labelMedium: labelMedium.copyWith(color: Colors.white),
          labelSmall: labelSmall.copyWith(color: Colors.white60),
        ),
      );
}
