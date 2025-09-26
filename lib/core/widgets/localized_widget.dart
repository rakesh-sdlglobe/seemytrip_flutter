import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/shared/presentation/controllers/language_controller.dart';

/// A widget that automatically adapts to the current language direction
class LocalizedWidget extends StatelessWidget {
  final Widget child;
  
  const LocalizedWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(
      builder: (controller) {
        return Directionality(
          textDirection: controller.getTextDirection(),
          child: child,
        );
      },
    );
  }
}

/// A helper widget for creating localized text with proper direction
class LocalizedText extends StatelessWidget {
  final String textKey;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? fallbackText;

  const LocalizedText(
    this.textKey, {
    Key? key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fallbackText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(
      builder: (controller) {
        String text;
        try {
          text = textKey.tr;
        } catch (e) {
          text = fallbackText ?? textKey;
        }
        
        return Directionality(
          textDirection: controller.getTextDirection(),
          child: Text(
            text,
            style: style,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
            textDirection: controller.getTextDirection(),
          ),
        );
      },
    );
  }
}
