import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/utils/common_textfeild_widget.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../main.dart';
import '../../../../../shared/constants/images.dart';
import '../../../../auth/presentation/controllers/login_controller.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final LoginController loginController = Get.find<LoginController>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController emailIdController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();

  DateTime now = DateTime.now();
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('yyyy-MM-dd').format(now);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUserProfile();
    });
  }

  Future<void> fetchUserProfile() async {
    try {
      loginController.isLoading.value = true;
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

        fullNameController.text = data['firstName'] ?? '';
        genderController.text = data['gender'] ?? '';
        dateOfBirthController.text = data['dob'] ?? '';
        nationalityController.text = data['nationality'] ?? '';
        emailIdController.text = data['email'] ?? '';
        mobileNumberController.text = data['phoneNumber'] ?? '';
      } else {
        Get.snackbar('Error', 'Failed to fetch user profile.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      loginController.isLoading.value = false;
    }
  }

  Future<void> editProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      Get.snackbar('Error', 'Access token not found.');
      return;
    }

    final body = {
      'name': fullNameController.text,
      'gender': genderController.text,
      'dob': dateOfBirthController.text,
      'email': emailIdController.text,
      'mobile': mobileNumberController.text,
    };

    final response = await http.post(
      Uri.parse('https://tripadmin.seemytrip.com/api/users/editProfile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      Get..back()
      ..snackbar('Success', 'Profile updated successfully');
    } else {
      Get.snackbar('Error', 'Failed to update profile');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: redCA0,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: 'Edit Profile',
          color: white,
          fontSize: 18,
        ),
        actions: [
          InkWell(
            onTap: editProfile,
            child: Padding(
              padding: EdgeInsets.only(right: 24, top: 20),
              child: CommonTextWidget.PoppinsMedium(
                text: 'Save',
                color: white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (loginController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25),
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Icon(Icons.account_circle, size: 130, color: redCA0),
                      // Optionally add an edit icon here
                    ],
                  ),
                ),
                SizedBox(height: 22),
                _buildLabel('Name'),
                _buildField(fullNameController, 'Unknown', profileIcon),
                _buildLabel('Gender'),
                _buildField(genderController, 'Male', genderIcon),
                _buildLabel('Nationality'),
                _buildField(nationalityController, 'India', null, isImage: true),
                _buildLabel('Email ID'),
                _buildField(emailIdController, 'example@email.com', emailIcon),
                _buildLabel('Mobile No.'),
                _buildField(mobileNumberController, '84XXX XXXXX', smartphoneIcon),
                SizedBox(height: 60),
              ],
            ),
          ),
        );
      }),
    );

  Widget _buildLabel(String text) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget.PoppinsMedium(
          text: text,
          color: black2E2,
          fontSize: 14,
        ),
        SizedBox(height: 10),
      ],
    );

  Widget _buildField(
    TextEditingController controller,
    String hint,
    String? iconPath, {
    bool isImage = false,
  }) => CommonTextFieldWidget(
      controller: controller,
      hintText: hint,
      keyboardType: TextInputType.text,
      prefixIcon: Padding(
        padding: EdgeInsets.all(10),
        child: isImage
            ? Image.asset(india, height: 20, width: 20)
            : iconPath != null
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: SvgPicture.asset(iconPath),
                  )
                : null,
      ),
    );
}
