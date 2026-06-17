import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFFFF5F00);
  static const primaryLight = Color(0xFFFF8B47);
  static const primaryDark = Color(0xFFE05500);
  static const background = Color(0xFF020817);
  static const backgroundAlt = Color(0xFF0B1120);
  static const surface = Color(0xFF0F172A);
  static const surfaceElevated = Color(0xFF111C34);
  static const text = Color(0xFFF8FAFC);
  static const muted = Color(0xFF94A3B8);
  static const border = Color(0xFF1E293B);
  static const success = Color(0xFF16A34A);
  static const danger = Color(0xFFDC2626);
  static const warning = Color(0xFFD97706);
  static const cardShadow = Color(0x33000000);
}

class AppTheme {
  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.interTextTheme().apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
        onPrimary: Colors.white,
        onSurface: AppColors.text,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
        ),
        iconTheme: const IconThemeData(color: AppColors.text),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        labelStyle: const TextStyle(color: AppColors.muted),
        hintStyle: const TextStyle(color: AppColors.muted),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.border, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          foregroundColor: AppColors.text,
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: const BorderSide(color: AppColors.border),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        side: const BorderSide(color: AppColors.border),
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        labelStyle: GoogleFonts.inter(fontSize: 13, color: AppColors.text),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surfaceElevated,
        contentTextStyle: GoogleFonts.inter(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 0.5,
        space: 0,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        height: 72,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? AppColors.text
                : AppColors.muted,
          );
        }),
        indicatorColor: AppColors.primary.withValues(alpha: 0.16),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          return IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.primaryLight
                : AppColors.muted,
          );
        }),
      ),
    );
  }
}
