import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import '../controllers/network_controller.dart';
import '../presentation/screens/no_connection/no_connection_screen.dart';
import '../theme/app_theme.dart';
import '../theme/theme_service.dart';
import '../../features/shared/presentation/controllers/language_controller.dart';
import '../../translations/app_translations.dart';

/// Wrapper widget that monitors connectivity and shows no-connection screen when offline
class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final networkController = Get.find<NetworkController>();
    final themeService = Get.find<ThemeService>();
    final languageController = Get.find<LanguageController>();

    return Obx(() {
      if (!networkController.isConnected.value) {
        // Wrap with MaterialApp to provide Directionality and Material context
        // Use Obx to react to theme changes
        return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: const NoConnectionScreen(),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeService.theme,
          translations: AppTranslations(),
          locale: languageController.currentLocale.value,
          fallbackLocale: const Locale('en'),
          supportedLocales: const [
            Locale('en'),
            Locale('hi'),
            Locale('ta'),
            Locale('kn'),
            Locale('te'),
            Locale('or'),
            Locale('fr'),
            Locale('es'),
            Locale('ar'),
            Locale('de'),
            Locale('zh'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ));
      }
      return child;
    });
  }
}

