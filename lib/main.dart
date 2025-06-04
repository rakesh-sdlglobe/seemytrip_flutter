import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Controller/login_controller.dart';
import 'package:seemytrip/Screens/SplashScreen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:seemytrip/translations/app_translations.dart' show AppTranslations;
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:seemytrip/l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize controllers
  Get.put(LoginController(), permanent: true);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
  ));

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const seemytrip());
}

class seemytrip extends StatelessWidget {
  const seemytrip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: const Locale('en'), // Default language
      fallbackLocale: const Locale('en'),
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('ta'),
        Locale('kn'),
        Locale('te'),
        Locale('or'),
      ],
       localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
      home: SplashScreen(),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
