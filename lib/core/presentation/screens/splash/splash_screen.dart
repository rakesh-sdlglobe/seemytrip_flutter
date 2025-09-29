import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../features/shared/presentation/controllers/splash_controller.dart';
import '../../../../shared/constants/images.dart';
import '../../../theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  final SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Beautiful Custom Animation Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark 
                    ? [
                        AppColors.backgroundDark,
                        AppColors.surfaceDark,
                        AppColors.backgroundDark,
                      ]
                    : [
                        AppColors.white,
                        AppColors.greyE8E,
                        AppColors.white,
                      ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: GetBuilder<SplashController>(
              builder: (SplashController controller) => AnimatedBuilder(
                animation: controller.fadeAnimation,
                builder: (BuildContext context, Widget? child) => Opacity(
                  opacity: controller.fadeAnimation.value,
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: TravelAnimationPainter(
                      animation: controller.fadeAnimation,
                      isDark: isDark,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Gradient Overlay for better text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  isDark 
                      ? Colors.black.withValues(alpha: 0.6)
                      : Colors.white.withValues(alpha: 0.8),
                ],
                stops: [0.0, 0.4, 1.0],
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: GetBuilder<SplashController>(
              builder: (SplashController controller) => AnimatedBuilder(
                animation: controller.scaleAnimation,
                builder: (BuildContext context, Widget? child) => Transform.scale(
                  scale: controller.scaleAnimation.value,
                  child: FadeTransition(
                    opacity: controller.fadeAnimation,
                    child: Column(
                      children: [
                        // Top Section with Logo
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Logo Container
                                Container(
                                  padding: EdgeInsets.all(25),
                                  decoration: BoxDecoration(
                                    color: isDark 
                                        ? AppColors.cardDark.withValues(alpha: 0.9)
                                        : AppColors.white.withValues(alpha: 0.95),
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isDark 
                                            ? AppColors.black262.withValues(alpha: 0.4)
                                            : AppColors.black262.withValues(alpha: 0.15),
                                        blurRadius: 25,
                                        spreadRadius: 0,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    compLogo,
                                    width: size.width * 0.6,
                                    height: size.height * 0.12,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(height: 30),
                                
                                // App Name
                                Text(
                                  'SeeMyTrip',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.white : AppColors.black2E2,
                                    fontSize: 42,
                                    letterSpacing: 2.0,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0, 3),
                                        blurRadius: 12,
                                        color: isDark 
                                            ? Colors.black.withValues(alpha: 0.6)
                                            : Colors.black.withValues(alpha: 0.2),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
                                
                                // Tagline
                                Text(
                                  'Your journey begins here',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    color: isDark 
                                        ? AppColors.white.withValues(alpha: 0.9)
                                        : AppColors.black2E2.withValues(alpha: 0.8),
                                    fontSize: 18,
                                    letterSpacing: 0.8,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 6,
                                        color: isDark 
                                            ? Colors.black.withValues(alpha: 0.4)
                                            : Colors.black.withValues(alpha: 0.15),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Bottom Section with Loading
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _buildLoadingIndicator(isDark),
                              SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(bool isDark) => GetBuilder<SplashController>(
      builder: (controller) => AnimatedBuilder(
        animation: controller.fadeAnimation,
        builder: (context, child) => Opacity(
          opacity: controller.fadeAnimation.value,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Modern Loading Animation
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isDark 
                      ? AppColors.cardDark.withValues(alpha: 0.9)
                      : AppColors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: isDark 
                          ? AppColors.black262.withValues(alpha: 0.3)
                          : AppColors.black262.withValues(alpha: 0.15),
                      blurRadius: 15,
                      spreadRadius: 0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: LoadingAnimationWidget.dotsTriangle(
                      color: isDark ? AppColors.white : AppColors.redCA0,
                      size: 30,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              
              // Loading Text
              Text(
                'Loading...',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: isDark 
                      ? AppColors.white.withValues(alpha: 0.9)
                      : AppColors.black2E2.withValues(alpha: 0.8),
                  fontSize: 16,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: isDark 
                          ? Colors.black.withValues(alpha: 0.3)
                          : Colors.black.withValues(alpha: 0.1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
}

// Custom Animation Painter for Beautiful Travel-themed Animations
class TravelAnimationPainter extends CustomPainter {
  final Animation<double> animation;
  final bool isDark;

  TravelAnimationPainter({
    required this.animation,
    required this.isDark,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    final progress = animation.value;

    // Draw world map background
    _drawWorldMap(canvas, size, paint, progress);
    
    // Draw destination pins
    _drawDestinationPins(canvas, size, paint, progress);
    
    // Draw animated airplane with route
    _drawAirplaneRoute(canvas, size, paint, progress);
    
    // Draw luggage and travel items
    _drawTravelItems(canvas, size, paint, progress);
    
    // Draw booking progress indicators
    _drawBookingProgress(canvas, size, paint, progress);
    
    // Draw floating travel icons
    _drawFloatingTravelIcons(canvas, size, paint, progress);
  }

  void _drawWorldMap(Canvas canvas, Size size, Paint paint, double progress) {
    // Draw simplified world map with continents
    paint.color = (isDark ? AppColors.white : AppColors.grey717)
        .withValues(alpha: 0.1);
    paint.style = PaintingStyle.fill;
    
    // Draw continents as simple shapes
    final continents = [
      // North America
      Rect.fromLTWH(size.width * 0.1, size.height * 0.2, size.width * 0.25, size.height * 0.3),
      // Europe
      Rect.fromLTWH(size.width * 0.4, size.height * 0.15, size.width * 0.15, size.height * 0.2),
      // Asia
      Rect.fromLTWH(size.width * 0.6, size.height * 0.1, size.width * 0.25, size.height * 0.4),
      // Africa
      Rect.fromLTWH(size.width * 0.45, size.height * 0.4, size.width * 0.15, size.height * 0.35),
      // Australia
      Rect.fromLTWH(size.width * 0.7, size.height * 0.6, size.width * 0.2, size.height * 0.15),
    ];
    
    for (final continent in continents) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(continent, Radius.circular(8)),
        paint,
      );
    }
  }

  void _drawDestinationPins(Canvas canvas, Size size, Paint paint, double progress) {
    final destinations = [
      Offset(size.width * 0.2, size.height * 0.3), // New York
      Offset(size.width * 0.5, size.height * 0.25), // London
      Offset(size.width * 0.75, size.height * 0.2), // Tokyo
      Offset(size.width * 0.5, size.height * 0.55), // Dubai
      Offset(size.width * 0.8, size.height * 0.65), // Sydney
    ];
    
    for (int i = 0; i < destinations.length; i++) {
      final pin = destinations[i];
      final pulse = math.sin(progress * 4 * math.pi + i) * 0.3 + 0.7;
      
      // Pin shadow
      paint.color = Colors.black.withValues(alpha: 0.2);
      canvas.drawCircle(Offset(pin.dx + 2, pin.dy + 2), 8 * pulse, paint);
      
      // Pin body
      paint.color = isDark ? AppColors.redCA0 : AppColors.redCA0;
      canvas.drawCircle(pin, 8 * pulse, paint);
      
      // Pin point
      paint.color = isDark ? AppColors.redCA0 : AppColors.redCA0;
      final pinPath = Path();
      pinPath.moveTo(pin.dx, pin.dy + 8 * pulse);
      pinPath.lineTo(pin.dx - 4 * pulse, pin.dy + 15 * pulse);
      pinPath.lineTo(pin.dx + 4 * pulse, pin.dy + 15 * pulse);
      pinPath.close();
      canvas.drawPath(pinPath, paint);
    }
  }

  void _drawAirplaneRoute(Canvas canvas, Size size, Paint paint, double progress) {
    // Draw flight routes between destinations
    final routes = [
      [Offset(size.width * 0.2, size.height * 0.3), Offset(size.width * 0.5, size.height * 0.25)],
      [Offset(size.width * 0.5, size.height * 0.25), Offset(size.width * 0.75, size.height * 0.2)],
      [Offset(size.width * 0.75, size.height * 0.2), Offset(size.width * 0.5, size.height * 0.55)],
      [Offset(size.width * 0.5, size.height * 0.55), Offset(size.width * 0.8, size.height * 0.65)],
    ];
    
    for (final route in routes) {
      final path = Path();
      path.moveTo(route[0].dx, route[0].dy);
      path.quadraticBezierTo(
        (route[0].dx + route[1].dx) / 2,
        (route[0].dy + route[1].dy) / 2 - 30,
        route[1].dx,
        route[1].dy,
      );
      
      paint.color = (isDark ? AppColors.redCA0 : AppColors.redCA0)
          .withValues(alpha: 0.3);
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 2.0;
      
      canvas.drawPath(path, paint);
    }
    
    // Draw animated airplane
    final airplaneProgress = (progress * 2) % 1.0;
    final routeIndex = (progress * 2).floor() % routes.length;
    final route = routes[routeIndex];
    final t = airplaneProgress;
    
    final airplaneX = route[0].dx + (route[1].dx - route[0].dx) * t;
    final airplaneY = route[0].dy + (route[1].dy - route[0].dy) * t;
    
    // Draw airplane
    paint.color = isDark ? AppColors.redCA0 : AppColors.redCA0;
    paint.style = PaintingStyle.fill;
    
    final airplanePath = Path();
    final airplaneSize = 12.0;
    airplanePath.moveTo(airplaneX, airplaneY - airplaneSize);
    airplanePath.lineTo(airplaneX - airplaneSize, airplaneY + airplaneSize);
    airplanePath.lineTo(airplaneX + airplaneSize, airplaneY + airplaneSize);
    airplanePath.close();
    
    canvas.drawPath(airplanePath, paint);
  }

  void _drawTravelItems(Canvas canvas, Size size, Paint paint, double progress) {
    // Draw luggage
    final luggagePositions = [
      Offset(size.width * 0.15, size.height * 0.7),
      Offset(size.width * 0.85, size.height * 0.75),
    ];
    
    for (int i = 0; i < luggagePositions.length; i++) {
      final pos = luggagePositions[i];
      final bounce = math.sin(progress * 6 * math.pi + i) * 5;
      
      // Luggage body
      paint.color = (isDark ? AppColors.white : AppColors.grey717)
          .withValues(alpha: 0.8);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(pos.dx - 15, pos.dy + bounce - 20, 30, 20),
          Radius.circular(4),
        ),
        paint,
      );
      
      // Luggage handle
      paint.color = isDark ? AppColors.redCA0 : AppColors.redCA0;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(pos.dx - 8, pos.dy + bounce - 25, 16, 5),
          Radius.circular(2),
        ),
        paint,
      );
    }
  }

  void _drawBookingProgress(Canvas canvas, Size size, Paint paint, double progress) {
    // Draw booking progress bar
    final barY = size.height * 0.85;
    final barWidth = size.width * 0.6;
    final barX = (size.width - barWidth) / 2;
    
    // Background bar
    paint.color = (isDark ? AppColors.white : AppColors.grey717)
        .withValues(alpha: 0.2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(barX, barY, barWidth, 6),
        Radius.circular(3),
      ),
      paint,
    );
    
    // Progress fill
    paint.color = isDark ? AppColors.redCA0 : AppColors.redCA0;
    final progressWidth = barWidth * (0.3 + 0.7 * progress);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(barX, barY, progressWidth, 6),
        Radius.circular(3),
      ),
      paint,
    );
    
    // Progress text
    paint.color = isDark ? AppColors.white : AppColors.black2E2;
    paint.style = PaintingStyle.fill;
    // Note: Text painting would require a TextPainter, simplified here
  }

  void _drawFloatingTravelIcons(Canvas canvas, Size size, Paint paint, double progress) {
    final icons = [
      {'pos': Offset(size.width * 0.1, size.height * 0.1), 'type': 'hotel'},
      {'pos': Offset(size.width * 0.9, size.height * 0.2), 'type': 'car'},
      {'pos': Offset(size.width * 0.1, size.height * 0.9), 'type': 'train'},
      {'pos': Offset(size.width * 0.9, size.height * 0.8), 'type': 'bus'},
    ];
    
    for (int i = 0; i < icons.length; i++) {
      final icon = icons[i];
      final pos = icon['pos'] as Offset;
      final type = icon['type'] as String;
      final float = math.sin(progress * 3 * math.pi + i) * 10;
      
      paint.color = (isDark ? AppColors.redCA0 : AppColors.redCA0)
          .withValues(alpha: 0.6);
      
      // Draw simple icon shapes
      switch (type) {
        case 'hotel':
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(pos.dx - 8, pos.dy + float - 8, 16, 12),
              Radius.circular(2),
            ),
            paint,
          );
          break;
        case 'car':
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(pos.dx - 10, pos.dy + float - 6, 20, 8),
              Radius.circular(4),
            ),
            paint,
          );
          break;
        case 'train':
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(pos.dx - 12, pos.dy + float - 6, 24, 8),
              Radius.circular(4),
            ),
            paint,
          );
          break;
        case 'bus':
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(pos.dx - 10, pos.dy + float - 8, 20, 12),
              Radius.circular(2),
            ),
            paint,
          );
          break;
      }
    }
  }

  @override
  bool shouldRepaint(TravelAnimationPainter oldDelegate) => oldDelegate.animation != animation || oldDelegate.isDark != isDark;
}
