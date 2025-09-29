// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../core/widgets/lists_widget.dart';
import '../../../../../main.dart';
import '../../../../auth/presentation/controllers/login_controller.dart';
import 'edit_profile_screen.dart';

class MyAccountScreen extends StatefulWidget {
  MyAccountScreen({Key? key}) : super(key: key);

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  final LoginController loginController = Get.find<LoginController>();

  String fullName = '';
  String gender = '';
  String dateOfBirth = '';
  String emailId = '';
  String phoneNumber = '';

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('accessToken');

      if (token == null) {
        Get.snackbar('Error', 'No access token found. Please log in again.');
        return;
      }

      final http.Response response = await http.get(
        Uri.parse(loginController.userProfileUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        loginController.userData.value = responseData;

        setState(() {
          fullName =
              '${responseData['firstName'] ?? ''} ${responseData['middleName'] ?? ''}${responseData['lastName'] ?? ''}';
          gender = responseData['gender'] ?? '';
          dateOfBirth = responseData['dob'] ?? '';
          emailId = responseData['email'] ?? '';
          phoneNumber = responseData['phoneNumber'] ?? '';
        });
      } else {
        Get.snackbar('Error', 'Failed to fetch user profile.');
      }
    } catch (error) {
      print('Error: $error');
      Get.snackbar('Error', 'An error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark 
          ? AppColors.backgroundDark 
          : AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: 'myAccount'.tr,
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: Obx(() => loginController.isLoading.value
          ? Center(child: LoadingAnimationWidget.dotsTriangle(
            color: AppColors.redCA0,
            size: 24,
          ))
          : ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                    ListTile(
                      onTap: () {
                        Get.to(() => EditProfileScreen());
                      },
                      leading: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.redCA0.withValues(alpha:0.1),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: AppColors.redCA0,
                        ),
                      ),
                      title: CommonTextWidget.PoppinsMedium(
                        text: fullName.isNotEmpty ? fullName : 'guestUser'.tr,
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? AppColors.textPrimaryDark 
                            : AppColors.black2E2,
                        fontSize: 18,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (emailId.isNotEmpty)
                            Text(
                              emailId,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? AppColors.textSecondaryDark 
                                    : Colors.grey,
                              ),
                            ),
                          CommonTextWidget.PoppinsMedium(
                            text: 'Edit Profile',
                            color: AppColors.redCA0,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18),
                    Divider(
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? AppColors.dividerDark 
                          : AppColors.greyE8E, 
                      thickness: 1
                    ),
                    SizedBox(height: 20),
                    ListView.builder(
                      itemCount: Lists.myAccountList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) => Padding(
                        padding: EdgeInsets.only(bottom: 30),
                        child: InkWell(
                          onTap: Lists.myAccountList[index]['onTap'],
                          child: Row(
                            children: <Widget>[
                              Container(
                                height: 52,
                                width: 52,
                                decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 4,
                                      color: Theme.of(context).brightness == Brightness.dark 
                                          ? AppColors.black262.withValues(alpha: 0.4)
                                          : AppColors.black262.withValues(alpha: 0.25),
                                    ),
                                  ],
                                  color: Theme.of(context).brightness == Brightness.dark 
                                      ? AppColors.cardDark 
                                      : AppColors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    Lists.myAccountList[index]['image'],
                                    color: AppColors.redCA0,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              CommonTextWidget.PoppinsRegular(
                                text: Lists.myAccountList[index]['text'],
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? AppColors.textPrimaryDark 
                                    : AppColors.black2E2,
                                fontSize: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
    );
}
