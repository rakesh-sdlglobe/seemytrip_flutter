import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Screens/WelcomeScreen/welcome_screen1.dart';
import 'package:makeyourtripapp/Screens/NavigationSCreen/navigation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController
    with SingleGetTickerProviderMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  @override
  void onInit() {
    super.onInit();

    // Initialize AnimationController
    animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Define the scale animation
    scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    // Start the animation
    animationController.forward();

    // Check login status and navigate accordingly
    Timer(
      const Duration(seconds: 6),
      () => checkLoginStatus(),
    );
  }

  Future<void> checkLoginStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token != null && token.isNotEmpty) {
        // User is logged in, navigate to home
        Get.off(() => NavigationScreen());
      } else {
        // User is not logged in, show onboarding
        Get.off(() => WelcomeScreen1());
      }
    } catch (error) {
      print("Error checking login status: $error");
      // If there's an error, default to onboarding
      Get.off(() => WelcomeScreen1());
    }
  }

  @override
  void onClose() {
    // Dispose of the animation controller to free resources
    animationController.dispose();
    super.onClose();
  }
}
