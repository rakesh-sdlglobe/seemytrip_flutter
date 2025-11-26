import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/network_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

/// Animated screen shown when there's no internet connection
class NoConnectionScreen extends StatefulWidget {
  const NoConnectionScreen({Key? key}) : super(key: key);

  @override
  State<NoConnectionScreen> createState() => _NoConnectionScreenState();
}

class _NoConnectionScreenState extends State<NoConnectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation for the icon
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Rotation animation for the refresh icon
    _rotationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _handleRetry(NetworkController networkController) async {
    _rotationController.forward(from: 0.0);
    await networkController.checkConnectivity();
    _rotationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final networkController = Get.find<NetworkController>();
    final isDark = Get.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Animated WiFi icon with pulse effect
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.25,
                                width: MediaQuery.of(context).size.width * 0.5,
                                constraints: const BoxConstraints(
                                  maxHeight: 200,
                                  maxWidth: 200,
                                  minHeight: 150,
                                  minWidth: 150,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark 
                                      ? AppColors.surfaceDark.withOpacity(0.3)
                                      : AppColors.primaryLight.withOpacity(0.3),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.wifi_off_rounded,
                                    size: MediaQuery.of(context).size.height * 0.12,
                                    color: isDark 
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                        
                        // Title
                        Text(
                          'No Internet Connection',
                          style: AppTextStyles.heading2.copyWith(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        
                        // Description
                        Text(
                          'Please check your internet connection\nand try again',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                        
                        // Retry button with rotation animation
                        Obx(() => AnimatedBuilder(
                          animation: _rotationController,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotationController.value * 2 * 3.14159,
                              child: ElevatedButton.icon(
                                onPressed: networkController.isConnected.value
                                    ? null
                                    : () => _handleRetry(networkController),
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.white,
                                  disabledBackgroundColor: AppColors.disabled,
                                  disabledForegroundColor: AppColors.textHint,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                              ),
                            );
                          },
                        )),
                        const SizedBox(height: 20),
                        
                        // Connection status indicator
                        Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: networkController.isConnected.value
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              networkController.isConnected.value
                                  ? 'Connected'
                                  : 'Disconnected',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: networkController.isConnected.value
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

