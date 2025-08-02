import 'package:flutter/material.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import 'package:seemytrip/core/theme/app_dimens.dart';
import 'package:seemytrip/core/theme/app_text_styles.dart';

extension ContextExtensions on BuildContext {
  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  // MediaQuery shortcuts
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get screenWidth => mediaQuery.size.width;
  double get screenHeight => mediaQuery.size.height;
  double get statusBarHeight => mediaQuery.padding.top;
  double get bottomInset => mediaQuery.padding.bottom;
  
  // Text styles with theme
  TextStyle? get heading1 => textTheme.displayLarge;
  TextStyle? get heading2 => textTheme.displayMedium;
  TextStyle? get heading3 => textTheme.displaySmall;
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;
  
  // Colors
  Color get primaryColor => colorScheme.primary;
  Color get backgroundColor => colorScheme.background;
  Color get surfaceColor => colorScheme.surface;
  Color get errorColor => colorScheme.error;
  Color get onPrimaryColor => colorScheme.onPrimary;
  Color get onBackgroundColor => colorScheme.onBackground;
  
  // Responsive helpers
  bool get isSmallScreen => screenWidth < 360;
  bool get isMediumScreen => screenWidth >= 360 && screenWidth < 600;
  bool get isLargeScreen => screenWidth >= 600;
  
  double responsiveWidth(double size) {
    if (isSmallScreen) return size * 0.9;
    if (isLargeScreen) return size * 1.1;
    return size;
  }
  
  double responsiveHeight(double size) {
    if (screenHeight < 700) return size * 0.9;
    if (screenHeight > 800) return size * 1.1;
    return size;
  }
  
  // Navigation
  void pop<T>([T? result]) => Navigator.of(this).pop(result);
  
  Future<T?> push<T>(Widget page) => Navigator.of(this).push<T>(
    MaterialPageRoute(builder: (_) => page),
  );
  
  void pushReplacement(Widget page) => Navigator.of(this).pushReplacement(
    MaterialPageRoute(builder: (_) => page),
  );
  
  // Dialogs
  Future<T?> showAppDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
    );
  }
  
  // SnackBar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
        ),
        backgroundColor: isError ? AppColors.error : AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusS),
        ),
      ),
    );
  }
  
  // Responsive padding
  EdgeInsets get responsivePadding => EdgeInsets.symmetric(
    horizontal: isSmallScreen 
      ? AppDimens.spaceM 
      : isMediumScreen 
        ? AppDimens.spaceL 
        : AppDimens.spaceXL,
    vertical: AppDimens.spaceM,
  );
  
  // Screen size helpers
  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;
  
  // Text scaling
  double get textScaleFactor => mediaQuery.textScaleFactor.clamp(0.8, 1.2);
  
  // Keyboard visibility
  bool get isKeyboardVisible => mediaQuery.viewInsets.bottom > 0.0;
  
  // Safe area padding
  EdgeInsets get safeAreaPadding => mediaQuery.padding;
  
  // Device info
  bool get isAndroid => Theme.of(this).platform == TargetPlatform.android;
  bool get isIOS => Theme.of(this).platform == TargetPlatform.iOS;
}
