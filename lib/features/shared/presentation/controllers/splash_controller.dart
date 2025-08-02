import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/presentation/screens/navigation/navigation_screen.dart';
import 'package:seemytrip/features/auth/presentation/screens/welcome/welcome_screen1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> rotateAnimation;
  late Animation<double> fadeAnimation;

  @override
  void onInit() {
    super.onInit();

    // Initialize AnimationController with longer duration
    animationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    // Create sequence of animations
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60.0,
      ),
    ]).animate(animationController);

    rotateAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    // Start the animation with repeat
    animationController.forward();

    // Check login status and navigate accordingly
    Timer(
      const Duration(seconds: 7),
      () => checkLoginStatus(),
    );
  }

  void startAnimation() {
    if (!animationController.isAnimating) {
      animationController.forward();
    }
  }

  void resetAnimation() {
    animationController.reset();
  }

  void pauseAnimation() {
    if (animationController.isAnimating) {
      animationController.stop();
    }
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
