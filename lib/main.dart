import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:seemytrip/features/auth/presentation/controllers/login_controller.dart';
import 'package:seemytrip/core/presentation/screens/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:seemytrip/core/theme/app_theme.dart';
import 'package:seemytrip/translations/app_translations.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:seemytrip/core/theme/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize GetStorage
  await GetStorage.init();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize controllers
  Get.put(LoginController(), permanent: true);
  await Get.putAsync<ThemeService>(() => ThemeService().init(), permanent: true);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
  ));

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(SeemytripApp());
}

class SeemytripApp extends StatelessWidget {
  const SeemytripApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SeeMyTrip',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeService.theme,
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
