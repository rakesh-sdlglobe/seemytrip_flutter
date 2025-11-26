// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors {
  // ==================== New Theme Colors ====================
  // Common Colors
  static const Color primary = redCA0; // redCA0
  static const Color primaryDark = redCA0;
  static const Color secondary = Color(0xFF03DAC5);
  static const Color error = Color(0xFFB00020);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  // Light Theme Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFE0E0E0);
  static const Color scaffoldBackground = Color(0xFFF5F5F5);

  // Dark Theme Colors
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF2A2A2A);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0BEC5);
  static const Color textHintDark = Color(0xFF757575);
  static const Color disabledDark = Color(0xFF4A4A4A);
  static const Color dividerDark = Color(0xFF3A3A3A);
  static const Color borderDark = Color(0xFF3A3A3A);
  static const Color shadowDark = Color(0xFF000000);
  static const Color shadowLight = Color(0xFF000000);

  // ==================== Old Theme Colors (Kept for backward compatibility) ====================
  // Theme Colors
  static const Color primaryOld = Color(0xFFCA0B0B);
  static const Color primaryLight = Color(0xFFFFEBEE);
  static const Color accent = Color(0xFFFF4081);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA000);
  static const Color info = Color(0xFF2196F3);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color card = Color(0xFF898989);
  
  // Grayscale
  static const Color grey2E2 = Color(0xFF2E2E2E);
  static const Color grey323 = Color(0xFF323232);
  static const Color grey363 = Color(0xFF363636);
  static const Color grey4B4 = Color(0xFF4B4B4B);
  static const Color grey515 = Color(0xFF515151);
  static const Color grey5F5 = Color(0xFF5F5F5F);
  static const Color grey656 = Color(0xFF656565);
  static const Color grey717 = Color(0xFF717171);
  static const Color grey757 = Color(0xFF757575);
  static const Color grey7B7 = Color(0xFF7B7B7B);
  static const Color grey818 = Color(0xFF818181);
  static const Color grey878 = Color(0xFF878787);
  static const Color grey888 = Color(0xFF888888);
  static const Color grey8E8 = Color(0xFF8E8E8E);
  static const Color grey929 = Color(0xFF929292);
  static const Color grey959 = Color(0xFF959595);
  static const Color grey969 = Color(0xFF969696);
  static const Color grey9B9 = Color(0xFF9B9B9B);
  static const Color greyAAA = Color(0xFFAAAAAA);
  static const Color greyB8B = Color(0xFFB8B8B8);
  static const Color greyB9B = Color(0xFFB9B9B9);
  static const Color greyBAB = Color(0xFFBABABA);
  static const Color greyBEB = Color(0xFFBEBEBE);
  static const Color greyC2C = Color(0xFFC2C2C2);
  static const Color greyC7C = Color(0xFFC7C7C7);
  static const Color greyC8C = Color(0xFFC8C8C8);
  static const Color greyCAC = Color(0xFFCACACA);
  static const Color greyD3D = Color(0xFFD3D3D3);
  static const Color greyD4D = Color(0xFFD4D4D4);
  static const Color greyD8D = Color(0xFFD8D8D8);
  static const Color greyD9D = Color(0xFFD9D9D9);
  static const Color greyDBD = Color(0xFFDBDBDB);
  static const Color greyDED = Color(0xFFDEDEDE);
  static const Color greyE2E = Color(0xFFE2E2E2);
  static const Color greyE8E = Color(0xFFE8E8E8);
  static const Color greyE9E = Color(0xFFE9E9E9);
  static const Color greyEEE = Color(0xFFEEEEEE);
  static const Color whiteF2F = Color(0xFFF2F2F2);
  
  // Brand Colors
  static const Color redCA0 = Color(0xFFCA0F2E);
  static const Color redF9E = Color(0xFFF9E2E6);
  static const Color redF8E = Color(0xFFF8EAED);
  static const Color redFAE = Color(0xFFFAE9EC);
  static const Color blue1F9 = Color(0xFF1F91D8);
  static const Color orangeFFB = Color(0xFFFFBE9D);
  static const Color orangeEB9 = Color(0xFFEB996E);
  static const Color yellowF7C = Color(0xFFF7CC7F);
  static const Color yellowCE8 = Color(0xFFCE8300);
  static const Color greyBCB = Color(0xFFBCBEC0);
  static const Color black2E2 = Color(0xFF2E2E2E);
  static const Color greyA1A = Color(0xFFA1A1A1);
  static const Color greyB3B = Color(0xFFB3B3B3);
  static const Color greyAFA = Color(0xFFAFAFAF);
  static const Color redFD3 = Color(0xFFFD3C3C);
  static const Color grey575 = Color(0xFF575757);
  static const Color greyD0D = Color(0xFFD0D0D0);
  static const Color greyD7D = Color(0xFFD7D7D7);
  static const Color greyE7E = Color(0xFFE7E7E7);
  static const Color green00A = Color(0xFF00A86B);
  static const Color grey50 = Color(0xFF505050);
  static const Color black262 = Color(0xFF262626);
  static const Color blueCA0 = Color(0xFF0F2ECA);
  static const Color fbecef = Color(0xFFFBECEF);
  
  // Theme-aware color getters (compatibility layer)
  static Color get scaffoldBackgroundOld => _isDarkMode ? grey2E2 : whiteF2F;
  static Color get cardBackground => _isDarkMode ? grey363 : white;
  static Color get text => _isDarkMode ? white : black2E2;
  static Color get secondaryText => _isDarkMode ? greyB9B : grey656;
  static Color get borderColor => _isDarkMode ? grey5F5 : greyD9D;
  
  static bool get _isDarkMode => Get.isDarkMode;
}

// Extension for theme-aware colors throughout the app
extension ThemeAwareColors on BuildContext {
  Color get scaffoldBg => Theme.of(this).scaffoldBackgroundColor;
  Color get cardBg => Theme.of(this).cardColor;
  Color get primaryText => Theme.of(this).textTheme.bodyLarge?.color ?? AppColors.black2E2;
  Color get secondaryText => Theme.of(this).textTheme.bodyMedium?.color ?? AppColors.grey717;
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get surfaceColor => Theme.of(this).colorScheme.surface;
  Color get dividerColor => Theme.of(this).dividerColor;
  
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  
  // Theme-aware shadow colors
  Color get cardShadowColor => isDarkMode 
      ? Colors.black.withOpacity(0.4) 
      : Colors.grey.withOpacity(0.1);
  
  Color get elevatedShadowColor => isDarkMode 
      ? Colors.black.withOpacity(0.5) 
      : Colors.black.withOpacity(0.15);
  
  double get cardShadowBlur => isDarkMode ? 16.0 : 12.0;
  double get elevatedShadowBlur => isDarkMode ? 20.0 : 15.0;
}