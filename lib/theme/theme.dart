import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    primaryColorLight: AppColors.primaryLight,
    primaryColorDark: AppColors.primaryDark,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surfaceLight,
      background: AppColors.backgroundLight,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.black,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
      iconTheme: IconThemeData(color: AppColors.black),
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.heading1,
      displayMedium: AppTextStyles.heading2,
      displaySmall: AppTextStyles.heading3,
      headlineMedium: AppTextStyles.heading4,
      titleLarge: AppTextStyles.productTitle,
      titleMedium: AppTextStyles.labelLarge,
      titleSmall: AppTextStyles.labelMedium,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.buttonLarge,
      labelMedium: AppTextStyles.buttonMedium,
      labelSmall: AppTextStyles.buttonSmall,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTextStyles.buttonMedium,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(color: AppColors.primary),
        textStyle: AppTextStyles.buttonMedium,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grey100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(color: AppColors.grey500),
    ),
    // cardTheme: CardTheme(
    //   color: AppColors.white,
    //   elevation: 2,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(16),
    //   ),
    //   margin: EdgeInsets.zero,
    // ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey400,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.primary,
    primaryColorLight: AppColors.primaryLight,
    primaryColorDark: AppColors.primaryDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surfaceDark,
      background: AppColors.backgroundDark,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.grey900,
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
      iconTheme: IconThemeData(color: AppColors.white),
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.heading1.copyWith(color: AppColors.white),
      displayMedium: AppTextStyles.heading2.copyWith(color: AppColors.white),
      displaySmall: AppTextStyles.heading3.copyWith(color: AppColors.white),
      headlineMedium: AppTextStyles.heading4.copyWith(color: AppColors.white),
      titleLarge: AppTextStyles.productTitle.copyWith(color: AppColors.white),
      titleMedium: AppTextStyles.labelLarge.copyWith(color: AppColors.white),
      titleSmall: AppTextStyles.labelMedium.copyWith(color: AppColors.white),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.grey200),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey200),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.grey300),
      labelLarge: AppTextStyles.buttonLarge.copyWith(color: AppColors.white),
      labelMedium: AppTextStyles.buttonMedium.copyWith(color: AppColors.white),
      labelSmall: AppTextStyles.buttonSmall.copyWith(color: AppColors.grey300),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTextStyles.buttonMedium,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(color: AppColors.primary),
        textStyle: AppTextStyles.buttonMedium,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grey800,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(color: AppColors.grey400),
    ),
    // cardTheme: CardTheme(
    //   color: AppColors.grey800,
    //   elevation: 2,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(16),
    //   ),
    //   margin: EdgeInsets.zero,
    // ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.grey900,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey400,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    useMaterial3: true,
  );
}