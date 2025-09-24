import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/features/train/presentation/controllers/train_contact_information_controller.dart';

// Design Constants
const double _contentPadding = 24.0;
const Duration _animationDuration = Duration(milliseconds: 300);
const Curve _animationCurve = Curves.easeInOutCubic;

class TrainAndBusContactInformationScreen extends StatefulWidget {
  TrainAndBusContactInformationScreen({Key? key}) : super(key: key);

  @override
  _TrainAndBusContactInformationScreenState createState() =>
      _TrainAndBusContactInformationScreenState();
}

class _TrainAndBusContactInformationScreenState
    extends State<TrainAndBusContactInformationScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final controller = Get.put(TrainContactInformationController());
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onTextChanged);
    
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: _animationCurve),
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: _animationCurve,
      ),
    );
    
    // Start animations after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }



  void _onTextChanged() {
    controller.validateUsername(_usernameController.text);
  }



  @override
  void dispose() {
    _usernameController.dispose();
    _animationController.dispose();
    controller.clearForm();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!controller.isUsernameValid.value) return;
    
    // Dismiss keyboard
    FocusScope.of(context).unfocus();
    
    // Haptic feedback
    await HapticFeedback.mediumImpact();
    
    // Simulate API call
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Validate the username (simple validation for demo)
    if (_usernameController.text.toLowerCase() == 'demo') {
      controller.errorMessage.value = 'Invalid username. Please try again.';
      controller.successMessage.value = '';
      controller.isUsernameValid.value = false;
    } else {
      controller.successMessage.value = 'Username verified successfully!';
      controller.errorMessage.value = '';
      controller.isUsernameValid.value = true;
      
      // Close the bottom sheet after a delay
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        Get.back(result: _usernameController.text);
      }
    }
  }

  // Helper method for footer links
  Widget _buildFooterLink(String text, {required VoidCallback onTap}) => GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: redCA0,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(_contentPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with animation
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Contact Information",
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[50],
                            child: InkWell(
                              onTap: () => Get.back(),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 24,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Info Card with animation
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: AnimatedContainer(
                        duration: _animationDuration,
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1).withOpacity(0.9),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFFFE082)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              color: Color(0xFFFFA000),
                              size: 22,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                "Please enter your IRCTC username. You'll need to enter the password for this account after payment to complete your booking.",
                                style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  color: const Color(0xFF5D4037),
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Username Field with animation
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "IRCTC Username",
                            style: GoogleFonts.poppins(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Obx(() {
                            final hasError = controller.errorMessage.isNotEmpty;
                            final hasSuccess = controller.successMessage.isNotEmpty;
                            
                            return AnimatedContainer(
                              duration: _animationDuration,
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: hasError
                                      ? Colors.red.withOpacity(0.8)
                                      : hasSuccess
                                          ? Colors.green.withOpacity(0.8)
                                          : Colors.grey[300]!,
                                  width: hasError || hasSuccess ? 1.8 : 1.5,
                                ),
                                boxShadow: [
                                  if (hasError || hasSuccess)
                                    BoxShadow(
                                      color: (hasError ? Colors.red : Colors.green).withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                ],
                              ),
                              child: TextField(
                                controller: _usernameController,
                                style: GoogleFonts.poppins(
                                  fontSize: 15.5,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.1,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Enter IRCTC username",
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey[500],
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 18,
                                  ),
                                  border: InputBorder.none,
                                  suffixIcon: Obx(() {
                                    if (controller.isLoading.value) {
                                      return Padding(
                                        padding: EdgeInsets.only(right: 16),
                                        child: SizedBox(
                                          child: LoadingAnimationWidget.fourRotatingDots(
                                            color: white,
                                            size: 20,
                                          ),
                                        ),
                                      );
                                    }
                                    if (controller.successMessage.isNotEmpty) {
                                      return const Padding(
                                        padding: EdgeInsets.only(right: 16),
                                        child: Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.green,
                                          size: 22,
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  }),
                                ),
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _handleSubmit(),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  // Error/Success message with animation
                  Obx(() {
                    final message = controller.errorMessage.isNotEmpty
                        ? controller.errorMessage.value
                        : controller.successMessage.isNotEmpty
                            ? controller.successMessage.value
                            : null;
                    
                    if (message != null) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  controller.errorMessage.isNotEmpty
                                      ? Icons.error_outline_rounded
                                      : Icons.check_circle_outline_rounded,
                                  size: 16,
                                  color: controller.errorMessage.isNotEmpty
                                      ? Colors.red
                                      : Colors.green,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    message,
                                    style: GoogleFonts.poppins(
                                      color: controller.errorMessage.isNotEmpty
                                          ? Colors.red
                                          : Colors.green,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w500,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  const SizedBox(height: 30),
                  // Submit Button with animation
                  Obx(() => FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: AnimatedContainer(
                              duration: _animationDuration,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: LinearGradient(
                                  colors: controller.isUsernameValid.value
                                      ? [redCA0, redCA0.withOpacity(0.9)]
                                      : [Colors.grey[300]!, Colors.grey[400]!],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  if (controller.isUsernameValid.value)
                                    BoxShadow(
                                      color: redCA0.withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 4),
                                    ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: controller.isUsernameValid.value &&
                                          !controller.isLoading.value
                                      ? _handleSubmit
                                      : null,
                                  child: Center(
                                    child: controller.isLoading.value
                                        ? SizedBox(
                                            child: LoadingAnimationWidget.fourRotatingDots(
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          )
                                        : Text(
                                            'Continue',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16.5,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(height: 24),
                  // Footer Links
                  _buildFooterLink(
                    "Forgot Username?",
                    onTap: () {
                      // TODO: Implement forgot username functionality
                      HapticFeedback.lightImpact();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildFooterLink(
                    "Create New IRCTC Account",
                    onTap: () {
                      // TODO: Implement create account functionality
                      HapticFeedback.lightImpact();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
    );
}
