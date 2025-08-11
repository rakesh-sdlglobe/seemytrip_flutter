import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/features/auth/presentation/controllers/login_controller.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
        loginController.userData.value = responseData;
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
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        );
      }

      return Container(
        width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: redCA0,
              ),
              accountName: Text(
                fullName.isNotEmpty ? fullName : 'Guest User',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                emailId.isNotEmpty ? emailId : 'guest@example.com',
                style: const TextStyle(fontSize: 14),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: redCA0),
              ),
            ),
            ...Lists.homeDrawerList.map((item) => ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: redCA0.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset(
                      item['image'],
                      color: redCA0,
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
