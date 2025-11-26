// lib/core/theme/theme_extensions.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Extension to easily access theme-aware colors and properties throughout the app
/// 
/// Usage:
/// ```dart
/// Container(
///   color: context.primary,
///   child: Text(
///     'Hello',
///     style: TextStyle(color: context.textPrimary),
///   ),
/// )
/// ```
extension AppThemeExtension on BuildContext {
  // Theme access
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  
  // Brightness
  bool get isDark => theme.brightness == Brightness.dark;
  bool get isLight => !isDark;
  Brightness get brightness => theme.brightness;
  
  // Primary colors
  Color get primary => colorScheme.primary;
  Color get primaryContainer => colorScheme.primaryContainer;
  Color get onPrimary => colorScheme.onPrimary;
  
  // Secondary colors
  Color get secondary => colorScheme.secondary;
  Color get onSecondary => colorScheme.onSecondary;
  
  // Surface colors
  Color get surface => colorScheme.surface;
  Color get onSurface => colorScheme.onSurface;
  Color get scaffold => theme.scaffoldBackgroundColor;
  
  // Background colors
  Color get background => colorScheme.background;
  Color get onBackground => colorScheme.onBackground;
  
  // Card colors
  Color get card => theme.cardColor;
  
  // Text colors
  Color get textPrimary => isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
  Color get textSecondary => isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
  Color get textHint => isDark ? AppColors.textHintDark : AppColors.textHint;
  
  // Border and divider colors
  Color get border => isDark ? AppColors.borderDark : AppColors.border;
  Color get divider => theme.dividerColor;
  
  // Status colors
  Color get error => colorScheme.error;
  Color get onError => colorScheme.onError;
  
  // Disabled colors
  Color get disabled => isDark ? AppColors.disabledDark : AppColors.disabled;
  
  // Shadow colors
  Color get shadow => theme.shadowColor;
  
  // AppBar colors
  Color get appBarBg => theme.appBarTheme.backgroundColor ?? primary;
  Color get appBarFg => theme.appBarTheme.iconTheme?.color ?? Colors.white;
  
  // Button colors
  Color get buttonPrimary => primary;
  Color get buttonOnPrimary => onPrimary;
  
  // Input decoration colors
  Color get inputFill => isDark ? AppColors.surfaceDark : AppColors.surface;
  Color get inputBorder => isDark ? AppColors.borderDark : AppColors.border;
  
  // Icon colors
  Color get iconPrimary => isDark ? Colors.white : AppColors.textPrimary;
  Color get iconSecondary => textSecondary;
  
  // Common app colors (always available)
  Color get white => AppColors.white;
  Color get black => AppColors.black;
  Color get transparent => AppColors.transparent;
  Color get success => AppColors.success;
  Color get warning => AppColors.warning;
  Color get info => AppColors.info;
}

/// Extension for common theme-aware text styles
extension TextStyleExtension on BuildContext {
  TextStyle? get displayLarge => textTheme.displayLarge;
  TextStyle? get displayMedium => textTheme.displayMedium;
  TextStyle? get displaySmall => textTheme.displaySmall;
  
  TextStyle? get headlineLarge => textTheme.headlineLarge;
  TextStyle? get headlineMedium => textTheme.headlineMedium;
  TextStyle? get headlineSmall => textTheme.headlineSmall;
  
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;
  
  TextStyle? get labelLarge => textTheme.labelLarge;
  TextStyle? get labelMedium => textTheme.labelMedium;
  TextStyle? get labelSmall => textTheme.labelSmall;
  
  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get titleSmall => textTheme.titleSmall;
}

/// Extension for common theme-aware decorations
extension DecorationExtension on BuildContext {
  /// Creates a theme-aware card decoration
  BoxDecoration cardDecoration({
    Color? color,
    double? borderRadius,
    bool withShadow = true,
  }) {
    final shadowColor = isDark 
        ? Colors.black.withOpacity(0.4) 
        : Colors.grey.withOpacity(0.1);
    final shadowBlur = isDark ? 16.0 : 12.0;
    
    return BoxDecoration(
      color: color ?? card,
      borderRadius: BorderRadius.circular(borderRadius ?? 12),
      boxShadow: withShadow
          ? [
              BoxShadow(
                color: shadowColor,
                blurRadius: shadowBlur,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
    );
  }
  
  /// Creates a theme-aware border
  Border themeBorder({Color? color, double width = 1.0}) {
    return Border.all(
      color: color ?? border,
      width: width,
    );
  }
  
  /// Creates a theme-aware input decoration
  InputDecoration themedInputDecoration({
    String? hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? errorText,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: errorText,
      filled: true,
      fillColor: inputFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: primary, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: error),
      ),
    );
  }
}

