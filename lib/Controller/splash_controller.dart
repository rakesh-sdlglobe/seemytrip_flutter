import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Screens/WelcomeScreen/welcome_screen1.dart';

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

    // Navigate to WelcomeScreen1 after 10 seconds
    Timer(
      const Duration(seconds: 6),
      () => Get.off(() => WelcomeScreen1()),
    );
  }

  @override
  void onClose() {
    // Dispose of the animation controller to free resources
    animationController.dispose();
    super.onClose();
  }
}
