import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/lists_widget.dart';
import '../../../../auth/presentation/controllers/login_controller.dart';

class DrawerScreen extends StatefulWidget {
  DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final LoginController loginController = Get.find<LoginController>();

  String fullName = '';
  String gender = '';
  String dateOfBirth = '';
  String emailId = '';

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      loginController.isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null) {
        print('⚠️ No access token found. Please log in again.');
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
        final responseData = json.decode(response.body);
        // loginController.userData.value = responseData; // userData is not defined in LoginController
        print('✅ User Profile: $responseData');

        setState(() {
          fullName =
              "${responseData['firstName'] ?? ''} ${responseData['lastName'] ?? ''}"
                  .trim();
          gender = responseData['gender'] ?? '';
          dateOfBirth = responseData['dob'] ?? '';
          emailId = responseData['email'] ?? '';
        });
      } else {
        print('❌ Failed to fetch profile. Status: ${response.statusCode}');
      }
    } catch (error) {
      print('❌ Exception while fetching profile: $error');
    } finally {
      loginController.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) => Obx(() {
      if (loginController.isLoading.value) {
        return Center(
          child: LoadingAnimationWidget.dotsTriangle(
            color: AppColors.redCA0,
            size: 24,
          ),
        );
      }

      return Container(
        width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.redCA0,
              ),
              accountName: Text(
                fullName.isNotEmpty ? fullName : 'guestUser'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                emailId.isNotEmpty ? emailId : 'guestEmail'.tr,
                style: const TextStyle(fontSize: 14),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: AppColors.white,
                child: Icon(Icons.person, size: 40, color: AppColors.redCA0),
              ),
            ),
            ...Lists.homeDrawerList.map((item) => ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.redCA0.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset(
                      item['image'],
                      color: AppColors.redCA0,
                      width: 24,
                      height: 24,
                    ),
                  ),
                  title: Text(
                    item['text'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: item['onTap'],
                )).toList(),
          ],
        ),
      );
    });
}
