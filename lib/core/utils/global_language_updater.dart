import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/shared/presentation/controllers/language_controller.dart';
import '../widgets/dynamic_language_selector.dart';

/// Utility class to help update screens to support dynamic language switching
class GlobalLanguageUpdater {
  static final LanguageController _languageController = Get.find<LanguageController>();
  
  /// Wrap any widget to make it responsive to language changes
  static Widget wrapWithLanguageSupport(Widget child) {
    return GetBuilder<LanguageController>(
      builder: (controller) {
        return Directionality(
          textDirection: controller.getTextDirection(),
          child: child,
        );
      },
    );
  }
  
  /// Create an app bar with language support
  static AppBar createLanguageAwareAppBar({
    required String titleKey,
    List<Widget>? actions,
    Widget? leading,
    Color? backgroundColor,
    bool automaticallyImplyLeading = true,
  }) {
    return AppBar(
      title: Text(titleKey.tr),
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      actions: [
        if (actions != null) ...actions,
        QuickLanguageSwitcher(),
        SizedBox(width: 16),
      ],
    );
  }
  
  /// Update a text widget to use translations
  static Widget translatedText(
    String key, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    String? fallback,
  }) {
    return GetBuilder<LanguageController>(
      builder: (controller) {
        String text;
        try {
          text = key.tr;
        } catch (e) {
          text = fallback ?? key;
        }
        
        return Text(
          text,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
          textDirection: controller.getTextDirection(),
        );
      },
    );
  }
  
  /// Show a language-aware snackbar
  static void showLanguageAwareSnackbar({
    required String titleKey,
    required String messageKey,
    SnackPosition position = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? colorText,
  }) {
    Get.snackbar(
      titleKey.tr,
      messageKey.tr,
      snackPosition: position,
      duration: duration,
      backgroundColor: backgroundColor,
      colorText: colorText,
      margin: EdgeInsets.all(16),
    );
  }
  
  /// Get current language info
  static String getCurrentLanguageName() => _languageController.getCurrentLanguageName();
  static bool isCurrentLanguageRTL() => _languageController.isCurrentLanguageRTL();
  static String getCurrentLanguageCode() => _languageController.currentLocale.value.languageCode;
}

/// Extension to make any widget language-aware
extension LanguageAware on Widget {
  Widget withLanguageSupport() {
    return GlobalLanguageUpdater.wrapWithLanguageSupport(this);
  }
}

