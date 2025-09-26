import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../components/otp_screen.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/presentation/screens/navigation/navigation_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common_button_widget.dart';
import '../../../../core/widgets/common_text_widget.dart';
import '../../../../main.dart';
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
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Container(
            height: 280,
            width: Get.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(logInImage),
                fit: BoxFit.fill,
              ),
            ),
            child: Stack(
              children: [
                Image.asset(welcome2Canvas,
                    width: Get.width, fit: BoxFit.cover),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 40),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              Get.to(() => NavigationScreen());
                            },
                            child: CommonTextWidget.PoppinsSemiBold(
                              text: 'SKIP',
                              color: AppColors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsSemiBold(
                            text: 'Join the club of 10 crore+ happy travellers',
                            color: AppColors.white,
                            fontSize: 22,
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 245),
            child: Container(
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
                color: AppColors.white,
              ),
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        CommonTextWidget.PoppinsMedium(
                          // text: "Use Mobile Number or Email to Login/Signup",
                          text: 'Use Google gmail to Login/Signup',
                          color: AppColors.grey929,
                          fontSize: 14,
                        ),
                        // SizedBox(height: 35),
                        // CommonTextFieldWidget.TextFormField1(
                        //   hintText: "Enter Mobile No./Email",
                        //   keyboardType: TextInputType.text,
                        //   controller: numberController,
                        //   prefixIcon: Padding(
                        //     padding: EdgeInsets.only(left: 15),
                        //     child: InkWell(
                        //       onTap: () {
                        //         Get.to(() => SelectCountryScreen());
                        //       },
                        //       child: Row(
                        //         mainAxisSize: MainAxisSize.min,
                        //         children: [
                        //           Image.asset(indianFlagImage,
                        //               height: 23, width: 23),
                        //           SizedBox(width: 4),
                        //           CommonTextWidget.PoppinsMedium(
                        //             text: "+91",
                        //             color: grey929,
                        //             fontSize: 16,
                        //           ),
                        //           SizedBox(width: 8),
                        //           SizedBox(
                        //             height: 30,
                        //             child: VerticalDivider(
                        //               color: grey929,
                        //               thickness: 1.5,
                        //             ),
                        //           ),
                        //           SizedBox(width: 12),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        //   onChange: (value) {
                        //     loginController.isTextEmpty.value =
                        //         value.isNotEmpty;
                        //   },
                        // ),
                        // SizedBox(height: 35),
                        // // Password field
                        // CommonTextFieldWidget.TextFormField1(
                        //   hintText: "Enter Password",
                        //   keyboardType: TextInputType.visiblePassword,
                        //   controller: passwordController,
                        // ),
                        // SizedBox(height: 35),
                        Obx(
                          () => CommonButtonWidget.button(
                            onTap: loginController.isTextEmpty.isFalse
                                ? null
                                : () {
                                    loginUser();
                                  },
                            buttonColor: loginController.isTextEmpty.isFalse
                                ? AppColors.greyD8D
                                : AppColors.redCA0,
                            text: 'CONTINUE',
                          ),
                        ),

                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Expanded(
                              //   child: Container(
                              //     height: 1.5,
                              //     width: Get.width,
                              //     color: greyD8D,
                              //   ),
                              // ),
                              // SizedBox(width: 15),
                              // CommonTextWidget.PoppinsMedium(
                              //   text: "or Login / Signup with",
                              //   color: grey929,
                              //   fontSize: 12,
                              // ),
                              // SizedBox(width: 15),
                              // Expanded(
                              //   child: Container(
                              //     height: 1.5,
                              //     width: Get.width,
                              //     color: greyD8D,
                              //   ),
                              // ),
                            ],
                          ),
                        ),

                        // SizedBox(height: 55),
                        // GestureDetector(
                        //   onTap: showMobileAuthBottomSheet,
                        //   child: Container(
                        //     height: 50,
                        //     width: Get.width,
                        //     decoration: BoxDecoration(
                        //       border: Border.all(color: greyD8D, width: 1),
                        //       color: white,
                        //       borderRadius: BorderRadius.circular(30),
                        //     ),
                        //     child: Padding(
                        //       padding: const EdgeInsets.symmetric(
                        //           horizontal: 20, vertical: 12),
                        //       child: Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           // Image.asset(
                        //           //   emailIcon,
                        //           //   height: 24,
                        //           //   width: 24,
                        //           // ),
                        //           Icon(Icons.phone),
                        //           Text(
                        //             "Continue with mobile No.",
                        //             style: TextStyle(
                        //               color: grey717,
                        //               fontSize: 16,
                        //               fontWeight: FontWeight.w500,
                        //             ),
                        //           ),
                        //           Opacity(
                        //             opacity:
                        //                 0, // Invisible placeholder for alignment
                        //             // child: Image.asset(
                        //             //   emailIcon,
                        //             //   height: 24,
                        //             //   width: 24,
                        //             // ),
                        //             child: Icon(Icons.phone),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: 10.0),
                        // GestureDetector(
                        //   onTap: showAuthBottomSheet,
                        //   child: Container(
                        //     height: 50,
                        //     width: Get.width,
                        //     decoration: BoxDecoration(
                        //       border: Border.all(color: greyD8D, width: 1),
                        //       color: white,
                        //       borderRadius: BorderRadius.circular(30),
                        //     ),
                        //     child: Padding(
                        //       padding: const EdgeInsets.symmetric(
                        //           horizontal: 20, vertical: 12),
                        //       child: Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           // Image.asset(
                        //           //   emailIcon,
                        //           //   height: 24,
                        //           //   width: 24,
                        //           // ),
                        //           Icon(Icons.email),
                        //           Text(
                        //             "Continue with email&Pass",
                        //             style: TextStyle(
                        //               color: grey717,
                        //               fontSize: 16,
                        //               fontWeight: FontWeight.w500,
                        //             ),
                        //           ),
                        //           Opacity(
                        //             opacity:
                        //                 0, // Invisible placeholder for alignment
                        //             // child: Image.asset(
                        //             //   emailIcon,
                        //             //   height: 24,
                        //             //   width: 24,
                        //             // ),
                        //             child: Icon(Icons.email),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 10.0),
                        Obx(
                          () => GestureDetector(
                            onTap: loginController.isSigningIn.value
                                ? null
                                : () => loginController.signInWithGoogle(),
                            child: Container(
                              height: 50,
                              width: Get.width,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.greyD8D, width: 1),
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      googleImage,
                                      height: 24,
                                      width: 24,
                                    ),
                                    Text(
                                      'Continue with Google',
                                      style: TextStyle(
                                        color: AppColors.grey717,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Opacity(
                                      opacity:
                                          0, // Invisible placeholder for alignment
                                      child: Image.asset(
                                        googleImage,
                                        height: 24,
                                        width: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => OtpScreen2());
                          },
                          child: Container(
                            height: 50,
                            width: Get.width,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.greyD8D, width: 1),
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Image.asset(
                                  //   emailIcon,
                                  //   height: 24,
                                  //   width: 24,
                                  // ),
                                  Icon(Icons.email),
                                  Text(
                                    'Continue with email otp',
                                    style: TextStyle(
                                      color: AppColors.grey717,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Opacity(
                                    opacity:
                                        0, // Invisible placeholder for alignment
                                    // child: Image.asset(
                                    //   emailIcon,
                                    //   height: 24,
                                    //   width: 24,
                                    // ),
                                    child: Icon(Icons.email),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        SizedBox(height: 25),
                        InkWell(
                          onTap: () {
                            Get.to(() => ReferralScreen());
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Have a ',
                              style: TextStyle(
                                fontFamily: FontFamily.PoppinsMedium,
                                fontSize: 14,
                                color: AppColors.grey929,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Referral Code?',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: FontFamily.PoppinsSemiBold,
                                      color: AppColors.redCA0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'By proceeding, you agree to SeeMyTrip’s ',
                            style: TextStyle(
                              fontFamily: FontFamily.PoppinsRegular,
                              fontSize: 10,
                              color: AppColors.grey929,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Privacy Policy. User Agreement. T&Cs ',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: FontFamily.PoppinsMedium,
                                    color: AppColors.redCA0),
                              ),
                              TextSpan(
                                text: 'as well Mobile connect’s ',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: FontFamily.PoppinsRegular,
                                    color: AppColors.grey929),
                              ),
                              TextSpan(
                                text: 'T&Cs',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: FontFamily.PoppinsMedium,
                                    color: AppColors.redCA0),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
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
