import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/font_family.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Controller/login_controller.dart';
import 'package:makeyourtripapp/Screens/AuthScreens/otp_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/home_screen.dart';
import 'package:makeyourtripapp/Screens/NavigationSCreen/navigation_screen.dart';
import 'package:makeyourtripapp/Screens/ReferralScreen/refferal_screen.dart';
import 'package:makeyourtripapp/Screens/SelectCountryScreen/select_country_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_textfeild_widget.dart';
import 'package:makeyourtripapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

    final String apiUrl = 'https://tripadmin.onrender.com/api/login';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
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
                              text: "SKIP",
                              color: white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsSemiBold(
                            text: "Join the club of 10 crore+ "
                                "happy travellers",
                            color: white,
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
                color: white,
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
                          text: "Use Google gmail to Login/Signup",
                          color: grey929,
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
                                ? greyD8D
                                : redCA0,
                            text: "CONTINUE",
                          ),
                        ),

                        SizedBox(height: 25),
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
                        SizedBox(height: 55),
                        Obx(
                          () => GestureDetector(
                            onTap: loginController.isSigningIn.value
                                ? null
                                : () => loginController.signInWithGoogle(),
                            child: Container(
                              height: 50,
                              width: Get.width,
                              decoration: BoxDecoration(
                                border: Border.all(color: greyD8D, width: 1),
                                color: white,
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
                                      "Continue with Google",
                                      style: TextStyle(
                                        color: grey717,
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
                        SizedBox(height: 25),
                        InkWell(
                          onTap: () {
                            Get.to(() => ReferralScreen());
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Have a ",
                              style: TextStyle(
                                fontFamily: FontFamily.PoppinsMedium,
                                fontSize: 14,
                                color: grey929,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Referral Code?",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: FontFamily.PoppinsSemiBold,
                                      color: redCA0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "By proceeding, you agree to MakeYourTrip’s ",
                            style: TextStyle(
                              fontFamily: FontFamily.PoppinsRegular,
                              fontSize: 10,
                              color: grey929,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Privacy Policy. User Agreement. T&Cs ",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: FontFamily.PoppinsMedium,
                                    color: redCA0),
                              ),
                              TextSpan(
                                text: "as well Mobile connect’s ",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: FontFamily.PoppinsRegular,
                                    color: grey929),
                              ),
                              TextSpan(
                                text: "T&Cs",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: FontFamily.PoppinsMedium,
                                    color: redCA0),
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
}
