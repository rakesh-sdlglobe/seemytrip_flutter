import 'package:flutter/material.dart';
import 'colors.dart';

class AppStyles {
  // Text Styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.25,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );

  // Button Styles
  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: AppColors.onPrimary,
    backgroundColor: AppColors.primary,
    elevation: 2,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  static ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: AppColors.primary,
    side: const BorderSide(color: AppColors.primary),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  static ButtonStyle textButtonStyle = TextButton.styleFrom(
    foregroundColor: AppColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  );

  // Card Style
  static CardTheme cardTheme = CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
      side: BorderSide(color: Colors.grey.shade200),
    ),
    margin: const EdgeInsets.all(8.0),
  );

  // Input Decoration
  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade50,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: AppColors.error, width: 2.0),
    ),
    labelStyle: bodyMedium.copyWith(color: AppColors.textSecondary),
    hintStyle: bodyMedium.copyWith(color: Colors.grey.shade400),
    errorStyle: bodySmall.copyWith(color: AppColors.error),
  );

  // App Bar Theme
  static AppBarTheme appBarTheme = const AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: AppColors.surface,
    iconTheme: IconThemeData(color: AppColors.textPrimary),
    titleTextStyle: titleLarge,
  );

  // Tab Bar Theme
  static TabBarTheme tabBarTheme = TabBarTheme(
    labelColor: AppColors.primary,
    unselectedLabelColor: AppColors.textSecondary,
    labelStyle: labelLarge,
    unselectedLabelStyle: labelMedium,
    indicator: const UnderlineTabIndicator(
      borderSide: BorderSide(width: 2.0, color: AppColors.primary),
    ),
  );

  // Bottom Navigation Bar Theme
  static BottomNavigationBarThemeData bottomNavigationBarTheme = const BottomNavigationBarThemeData(
    backgroundColor: AppColors.surface,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.textSecondary,
    selectedLabelStyle: labelSmall,
    unselectedLabelStyle: labelSmall,
    type: BottomNavigationBarType.fixed,
    elevation: 8.0,
  );
}
