import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../components/otp_screen.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/presentation/screens/navigation/navigation_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common_text_widget.dart';
import '../../../../shared/constants/font_family.dart';
import '../../../../shared/constants/images.dart';
import '../../../profile/presentation/screens/referral/refferal_screen.dart';
import '../controllers/login_controller.dart';
import 'Login_bottom_sheet.dart';
import 'mobile_bottom_sheet.dart';

// ignore: must_be_immutable
class LogInScreen extends StatelessWidget {
  LogInScreen({Key? key}) : super(key: key);
  final TextEditingController numberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginController loginController = Get.put(LoginController());
  bool isLoading = false;

  Future<void> loginUser() async {
    if (isLoading) {
      return;
    }

    isLoading = true;

    final String apiUrl = AppConfig.login;

    final Map<String, dynamic> data = {
      'email': numberController.text,
      'password': passwordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['token'] != null) {
          print('Login successful!');

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('accessToken', responseData['token']);
          
          // Print the token after successful login
          print('User Token: ${responseData['token']}');
          
          Get.to(NavigationScreen());
        } else {
          print('Invalid credentials');
        }
      } else {
        print('Failed to login. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during user login: $error');
    } finally {
      isLoading = false;
    }
  }

  // To show this bottom sheet using GetX:
  void showAuthBottomSheet() {
    Get.bottomSheet(
      LoginSignupBottomSheet(),
      isScrollControlled:
          true, // Allows the bottom sheet to be fully scrollable.
    );
  }

  // To show this bottom sheet using GetX:
  void showMobileAuthBottomSheet() {
    Get.bottomSheet(
      MobileOtpBottomSheet(),
      isScrollControlled:
          true, // Allows the bottom sheet to be fully scrollable.
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark 
          ? AppColors.backgroundDark 
          : AppColors.white,
      body: Stack(
        children: [
          // Background Image
          Container(
            height: Get.height * 0.6,
            width: Get.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(logInImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Theme.of(context).brightness == Brightness.dark 
                        ? Colors.black.withOpacity(0.5)
                        : Colors.black.withOpacity(0.4),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    children: [
                      // Skip Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () => Get.to(() => NavigationScreen()),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.white.withOpacity(0.18)
                                    : Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Theme.of(context).brightness == Brightness.dark 
                                      ? Colors.white.withOpacity(0.35)
                                      : Colors.white.withOpacity(0.3)
                                ),
                              ),
                              child: CommonTextWidget.PoppinsMedium(
                                text: 'SKIP',
                                color: AppColors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      // Welcome Text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CommonTextWidget.PoppinsBold(
                            text: 'Welcome to',
                            color: AppColors.white,
                            fontSize: 24,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          CommonTextWidget.PoppinsBold(
                            text: 'SeeMyTrip',
                            color: AppColors.white,
                            fontSize: 36,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          CommonTextWidget.PoppinsMedium(
                            text: 'Join 10 crore+ happy travellers',
                            color: Theme.of(context).brightness == Brightness.dark 
                                ? AppColors.white.withOpacity(0.95)
                                : AppColors.white.withOpacity(0.9),
                            fontSize: 16,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Main Content - Moved to bottom
          Positioned.fill(
            child: Column(
              children: [
                // Top Spacer to push content down
                Spacer(),
                // Content Container
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark 
                        ? AppColors.surfaceDark 
                        : AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? AppColors.black262.withOpacity(0.2)
                            : AppColors.black262.withOpacity(0.08),
                        blurRadius: 15,
                        spreadRadius: 0,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        CommonTextWidget.PoppinsBold(
                          text: 'Get Started',
                          color: Theme.of(context).brightness == Brightness.dark 
                              ? AppColors.textPrimaryDark 
                              : AppColors.black2E2,
                          fontSize: 24,
                        ),
                        SizedBox(height: 8),
                        CommonTextWidget.PoppinsMedium(
                          text: 'Choose your preferred login method',
                          color: Theme.of(context).brightness == Brightness.dark 
                              ? AppColors.textSecondaryDark 
                              : AppColors.grey929,
                          fontSize: 15,
                        ),
                        SizedBox(height: 30),
                    
                        // Google Login Button
                        Obx(() => _buildLoginButton(
                          context: context,
                          onTap: loginController.isSigningIn.value
                              ? null
                              : () => loginController.signInWithGoogle(),
                          icon: Image.asset(googleImage, height: 20, width: 20),
                          text: 'Continue with Google',
                          isLoading: loginController.isSigningIn.value,
                          isPrimary: true,
                        )),
                        
                        SizedBox(height: 16),
                        
                        // Email OTP Button
                        _buildLoginButton(
                          context: context,
                          onTap: () => Get.to(() => OtpScreen2()),
                          icon: Icon(
                            Icons.email_outlined,
                            color: Theme.of(context).brightness == Brightness.dark 
                                ? AppColors.textPrimaryDark 
                                : AppColors.grey717,
                            size: 20,
                          ),
                          text: 'Continue with Email OTP',
                          isPrimary: false,
                        ),
                        
                        SizedBox(height: 24),
                    
                        // Referral Code
                        Center(
                          child: InkWell(
                            onTap: () => Get.to(() => ReferralScreen()),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Have a ',
                                style: TextStyle(
                                  fontFamily: FontFamily.PoppinsMedium,
                                  fontSize: 14,
                                  color: Theme.of(context).brightness == Brightness.dark 
                                      ? AppColors.textSecondaryDark 
                                      : AppColors.grey929,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Referral Code?',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: FontFamily.PoppinsSemiBold,
                                      color: AppColors.redCA0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Terms and Conditions
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'By continuing, you agree to our ',
                              style: TextStyle(
                                fontFamily: FontFamily.PoppinsRegular,
                                fontSize: 12,
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? AppColors.textSecondaryDark 
                                    : AppColors.grey929,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: FontFamily.PoppinsMedium,
                                    color: AppColors.redCA0,
                                  ),
                                ),
                                TextSpan(
                                  text: ' and ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: FontFamily.PoppinsRegular,
                                    color: Theme.of(context).brightness == Brightness.dark 
                                        ? AppColors.textSecondaryDark 
                                        : AppColors.grey929,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: FontFamily.PoppinsMedium,
                                    color: AppColors.redCA0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  Widget _buildLoginButton({
    required BuildContext context,
    required VoidCallback? onTap,
    required Widget icon,
    required String text,
    bool isPrimary = false,
    bool isLoading = false,
  }) => GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: Get.width,
        decoration: BoxDecoration(
          color: isPrimary 
              ? AppColors.redCA0 
              : (Theme.of(context).brightness == Brightness.dark 
                  ? AppColors.cardDark 
                  : AppColors.white),
          borderRadius: BorderRadius.circular(12),
          border: isPrimary 
              ? null 
              : Border.all(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? AppColors.borderDark 
                      : AppColors.greyE8E,
                  width: 1,
                ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? AppColors.black262.withOpacity(0.1)
                  : AppColors.black262.withOpacity(0.04),
              blurRadius: 6,
              spreadRadius: 0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    color: isPrimary 
                        ? AppColors.white 
                        : (Theme.of(context).brightness == Brightness.dark 
                            ? AppColors.textPrimaryDark 
                            : AppColors.grey717),
                    strokeWidth: 2,
                  ),
                )
              else
                icon,
              SizedBox(width: 12),
              CommonTextWidget.PoppinsMedium(
                text: text,
                color: isPrimary 
                    ? AppColors.white 
                    : (Theme.of(context).brightness == Brightness.dark 
                        ? AppColors.textPrimaryDark 
                        : AppColors.grey717),
                fontSize: 16,
              ),
            ],
          ),
        ),
      ),
    );
}