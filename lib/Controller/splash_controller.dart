import 'dart:async';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Screens/WelcomeScreen/welcome_screen1.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Timer(
      Duration(seconds: 6),
          () => Get.off(
        WelcomeScreen1(),
      ),
    );
    super.onInit();
  }
}
