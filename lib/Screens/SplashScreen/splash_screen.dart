import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Center(
        child: GetBuilder<SplashController>(
          builder: (controller) {
            return AnimatedBuilder(
              animation: controller.scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: controller.scaleAnimation.value,
                  child: Image.asset(
                    'assets/images/comp_logo.png',
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
