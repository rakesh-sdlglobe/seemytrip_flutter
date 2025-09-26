import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/shared/presentation/controllers/language_controller.dart';

/// Global wrapper that ensures all screens respond to language changes
class GlobalLanguageWrapper extends StatelessWidget {
  final Widget child;
  final bool showLanguageFAB;
  
  const GlobalLanguageWrapper({
    Key? key,
    required this.child,
    this.showLanguageFAB = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(
      builder: (languageController) {
        return Directionality(
          textDirection: languageController.getTextDirection(),
          child: child,
        );
      },
    );
  }
}

/// Extension to wrap any widget with language responsiveness
extension LanguageResponsive on Widget {
  Widget withLanguageSupport({bool showFAB = false}) {
    return GlobalLanguageWrapper(
      child: this,
      showLanguageFAB: showFAB,
    );
  }
}

/// Base class for all screens to ensure language responsiveness
abstract class LanguageResponsiveScreen extends StatelessWidget {
  const LanguageResponsiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(
      builder: (languageController) {
        return Directionality(
          textDirection: languageController.getTextDirection(),
          child: buildScreen(context),
        );
      },
    );
  }

  /// Override this method to build your screen content
  Widget buildScreen(BuildContext context);
}

/// Base class for stateful screens
abstract class LanguageResponsiveStatefulScreen extends StatefulWidget {
  const LanguageResponsiveStatefulScreen({Key? key}) : super(key: key);
}

abstract class LanguageResponsiveState<T extends LanguageResponsiveStatefulScreen> 
    extends State<T> {
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(
      builder: (languageController) {
        return Directionality(
          textDirection: languageController.getTextDirection(),
          child: buildScreen(context),
        );
      },
    );
  }

  /// Override this method to build your screen content
  Widget buildScreen(BuildContext context);
}
