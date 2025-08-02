import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:seemytrip/features/shared/presentation/controllers/splash_controller.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/shared/constants/images.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Optional: Background image or gradient
          // Container(
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [Colors.white, Colors.grey.shade200],
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //     ),
          //   ),
          // ),

          Container(color: Colors.transparent),

          Center(
            child: GetBuilder<SplashController>(
              builder: (controller) {
                return AnimatedBuilder(
                  animation: controller.scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: controller.scaleAnimation.value,
                      child: FadeTransition(
                        opacity: controller.fadeAnimation,
                        child: Container(
                          constraints: BoxConstraints(maxWidth: size.width * 0.8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                compLogo,
                                width: size.width * 0.5,
                                height: size.height * 0.12,
                                fit: BoxFit.contain,
                              ),

                              SizedBox(height: 35),

                              AspectRatio(
                                aspectRatio: 1.5,
                                child: Lottie.asset(
                                  'assets/jsons/travel_animation.json',
                                  fit: BoxFit.contain,
                                  repeat: true,
                                  animate: true,
                                  frameRate: FrameRate(60),
                                  onLoaded: (_) => splashController.startAnimation(),
                                  errorBuilder: (context, error, stackTrace) => Center(
                                    child: Icon(Icons.error_outline, color: Colors.red, size: 50),
                                  ),
                                ),
                              ),

                              SizedBox(height: 35),

                              Text(
                                'SeeMyTrip',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: black2E2,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.3,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 4,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 12),

                              Text(
                                'Your journey begins here',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: black2E2.withOpacity(0.7),
                                  fontSize: 18,
                                  // fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 3,
                                      color: Colors.black12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
