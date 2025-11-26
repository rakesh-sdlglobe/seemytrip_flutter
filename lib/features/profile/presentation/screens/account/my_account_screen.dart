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
  const MyAccountScreen({Key? key}) : super(key: key);

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
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        Get.snackbar('Error', 'No access token found. Please log in again.');
        return;
      }

      final response = await http.get(
        Uri.parse(loginController.userProfileUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        loginController.userData.value = data;

        setState(() {
          fullName =
              '${data['firstName'] ?? ''} ${data['middleName'] ?? ''}${data['lastName'] ?? ''}';
          gender = data['gender'] ?? '';
          dateOfBirth = data['dob'] ?? '';
          emailId = data['email'] ?? '';
          phoneNumber = data['phoneNumber'] ?? '';
        });
      } else {
        Get.snackbar('Error', 'Failed to fetch user profile.');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.redCA0,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: 'My Account',
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      body: Obx(
        () => loginController.isLoading.value
            ? Center(
                child: LoadingAnimationWidget.dotsTriangle(
                  color: AppColors.redCA0,
                  size: 32,
                ),
              )
            : RefreshIndicator(
                onRefresh: fetchUserProfile,
                color: AppColors.redCA0,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: isDark ? AppColors.cardDark : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.redCA0.withOpacity(0.1),
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 40,
                                color: Color(0xFFCA0000),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonTextWidget.PoppinsMedium(
                                    text: fullName.isNotEmpty
                                        ? fullName
                                        : 'Guest User',
                                    color: isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.black2E2,
                                    fontSize: 18,
                                  ),
                                  const SizedBox(height: 4),
                                  if (emailId.isNotEmpty)
                                    Text(
                                      emailId,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isDark
                                            ? AppColors.textSecondaryDark
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  const SizedBox(height: 6),
                                  GestureDetector(
                                    onTap: () =>
                                        Get.to(() => EditProfileScreen()),
                                    child: CommonTextWidget.PoppinsMedium(
                                      text: 'Edit Profile',
                                      color: AppColors.redCA0,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Account Options
                      ...Lists.myAccountList.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: InkWell(
                            onTap: item['onTap'],
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color:
                                    isDark ? AppColors.cardDark : Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 5,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.redCA0.withOpacity(0.08),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        item['image'],
                                        color: AppColors.redCA0,
                                        height: 22,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: CommonTextWidget.PoppinsRegular(
                                      text: item['text'],
                                      color: isDark
                                          ? AppColors.textPrimaryDark
                                          : AppColors.black2E2,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios_rounded,
                                      color: Colors.grey[400], size: 16),
                                ],
                              ),
                            ),
                          ),
                        )).toList(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
