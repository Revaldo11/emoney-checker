import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static const border = BorderSide(color: AppColors.ink, width: 2);
  static const cardRadius = BorderRadius.all(Radius.circular(16));
  static const smallRadius = BorderRadius.all(Radius.circular(10));
  static const shadow = <BoxShadow>[
    BoxShadow(color: AppColors.ink, offset: Offset(4, 4)),
  ];

  static ThemeData get data {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.yellow,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.yellow,
      onPrimary: AppColors.ink,
      surface: AppColors.cream,
      onSurface: AppColors.ink,
      error: AppColors.error,
      onError: AppColors.ink,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.cream,
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Space Grotesk', fontWeight: FontWeight.w700, color: AppColors.ink),
        displayMedium: TextStyle(fontFamily: 'Space Grotesk', fontWeight: FontWeight.w700, color: AppColors.ink),
        headlineLarge: TextStyle(fontFamily: 'Space Grotesk', fontWeight: FontWeight.w700, color: AppColors.ink),
        headlineMedium: TextStyle(fontFamily: 'Space Grotesk', fontWeight: FontWeight.w700, color: AppColors.ink),
        titleLarge: TextStyle(fontFamily: 'Space Grotesk', fontWeight: FontWeight.w700, color: AppColors.ink),
        bodyLarge: TextStyle(color: AppColors.ink),
        bodyMedium: TextStyle(color: AppColors.ink),
        labelLarge: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.cream,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: cardRadius, side: border),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 48),
          backgroundColor: AppColors.yellow,
          foregroundColor: AppColors.ink,
          shape: const RoundedRectangleBorder(borderRadius: cardRadius, side: border),
          elevation: 0,
          shadowColor: AppColors.ink,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          foregroundColor: AppColors.ink,
          side: border,
          shape: const RoundedRectangleBorder(borderRadius: cardRadius),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          foregroundColor: AppColors.ink,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: smallRadius, borderSide: border),
        enabledBorder: OutlineInputBorder(borderRadius: smallRadius, borderSide: border),
        focusedBorder: OutlineInputBorder(borderRadius: smallRadius, borderSide: border),
      ),
    );
  }
}
