import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF1E88E5);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF64B5F6);
  
  // Secondary Colors
  static const Color secondary = Color(0xFFFFA000);
  static const Color secondaryDark = Color(0xFFF57C00);
  static const Color secondaryLight = Color(0xFFFFB74D);
  
  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFD32F2F);
  
  // Text Colors
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onBackground = Color(0xFF000000);
  static const Color onSurface = Color(0xFF000000);
  static const Color onError = Color(0xFFFFFFFF);
  
  // Other Colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color border = Color(0xFFE0E0E0);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);
  
  // Transparent Colors
  static const Color transparent = Color(0x00000000);
  
  // Text Colors with Opacity
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  
  // Background Colors with Opacity
  static const Color backgroundGrey = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF303030);
  
  // Social Media Colors
  static const Color facebook = Color(0xFF3B5998);
  static const Color google = Color(0xFFDB4437);
  static const Color twitter = Color(0xFF1DA1F2);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryLight],
  );
}
