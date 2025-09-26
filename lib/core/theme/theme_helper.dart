// lib/core/theme/theme_helper.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Helper class for theme-aware styling
class ThemeHelper {
  /// Get theme-aware text color for primary text
  static Color getTextColor(BuildContext context, {Color? fallback}) {
    return Theme.of(context).textTheme.bodyLarge?.color ?? 
           fallback ?? 
           (Theme.of(context).brightness == Brightness.dark 
               ? AppColors.white 
               : AppColors.textPrimary);
  }

  /// Get theme-aware text color for secondary text
  static Color getSecondaryTextColor(BuildContext context, {Color? fallback}) {
    return Theme.of(context).textTheme.bodyMedium?.color ?? 
           fallback ?? 
           (Theme.of(context).brightness == Brightness.dark 
               ? AppColors.textSecondaryDark 
               : AppColors.textSecondary);
  }

  /// Get theme-aware text color for hints
  static Color getHintTextColor(BuildContext context, {Color? fallback}) {
    return Theme.of(context).textTheme.bodySmall?.color ?? 
           fallback ?? 
           (Theme.of(context).brightness == Brightness.dark 
               ? AppColors.textHintDark 
               : AppColors.textHint);
  }

  /// Get theme-aware card shadow
  static List<BoxShadow> getCardShadow(BuildContext context, {
    double? blurRadius,
    double? spreadRadius,
    Offset? offset,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return [
      BoxShadow(
        color: isDark 
            ? Colors.black.withOpacity(0.4)
            : Colors.black.withOpacity(0.1),
        blurRadius: blurRadius ?? (isDark ? 16.0 : 12.0),
        spreadRadius: spreadRadius ?? (isDark ? 0.0 : 1.0),
        offset: offset ?? Offset(0, isDark ? 6.0 : 4.0),
      ),
    ];
  }

  /// Get theme-aware elevated shadow
  static List<BoxShadow> getElevatedShadow(BuildContext context, {
    double? blurRadius,
    double? spreadRadius,
    Offset? offset,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return [
      BoxShadow(
        color: isDark 
            ? Colors.black.withOpacity(0.5)
            : Colors.black.withOpacity(0.15),
        blurRadius: blurRadius ?? (isDark ? 20.0 : 15.0),
        spreadRadius: spreadRadius ?? (isDark ? 0.0 : 2.0),
        offset: offset ?? Offset(0, isDark ? 8.0 : 6.0),
      ),
    ];
  }

  /// Get theme-aware surface color
  static Color getSurfaceColor(BuildContext context, {Color? fallback}) {
    return Theme.of(context).cardColor;
  }

  /// Get theme-aware background color
  static Color getBackgroundColor(BuildContext context, {Color? fallback}) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  /// Get theme-aware divider color
  static Color getDividerColor(BuildContext context, {Color? fallback}) {
    return Theme.of(context).dividerColor;
  }

  /// Check if current theme is dark
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Get theme-aware icon color
  static Color getIconColor(BuildContext context, {Color? fallback}) {
    return isDarkMode(context) 
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;
  }

  /// Get theme-aware border color
  static Color getBorderColor(BuildContext context, {Color? fallback}) {
    return isDarkMode(context) 
        ? AppColors.borderDark
        : AppColors.border;
  }
}

/// Extension to make ThemeHelper more convenient to use
extension ThemeHelperExtension on BuildContext {
  /// Get theme-aware text color for primary text
  Color get primaryTextColor => ThemeHelper.getTextColor(this);
  
  /// Get theme-aware text color for secondary text
  Color get secondaryTextColor => ThemeHelper.getSecondaryTextColor(this);
  
  /// Get theme-aware text color for hints
  Color get hintTextColor => ThemeHelper.getHintTextColor(this);
  
  /// Get theme-aware card shadow
  List<BoxShadow> get cardShadow => ThemeHelper.getCardShadow(this);
  
  /// Get theme-aware elevated shadow
  List<BoxShadow> get elevatedShadow => ThemeHelper.getElevatedShadow(this);
  
  /// Get theme-aware surface color
  Color get surfaceColor => ThemeHelper.getSurfaceColor(this);
  
  /// Get theme-aware background color
  Color get backgroundColor => ThemeHelper.getBackgroundColor(this);
  
  /// Get theme-aware divider color
  Color get dividerColor => ThemeHelper.getDividerColor(this);
  
  /// Check if current theme is dark
  bool get isDarkMode => ThemeHelper.isDarkMode(this);
  
  /// Get theme-aware icon color
  Color get iconColor => ThemeHelper.getIconColor(this);
  
  /// Get theme-aware border color
  Color get borderColor => ThemeHelper.getBorderColor(this);
}
