import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Controller/login_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/MyAccountScreen/edit_profile_screen.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Screens/Utills/lists_widget.dart';
import 'package:seemytrip/main.dart';

class MyAccountScreen extends StatefulWidget {
  MyAccountScreen({Key? key}) : super(key: key);

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  final LoginController loginController = Get.find<LoginController>();

  String fullName = "";
  String gender = "";
  String dateOfBirth = "";
  String emailId = "";
  String phoneNumber = "";

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null) {
        Get.snackbar("Error", "No access token found. Please log in again.");
        return;
      }

      final response = await http.get(
        Uri.parse(loginController.userProfileUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

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
        Get.snackbar("Error", "Failed to fetch user profile.");
      }
    } catch (error) {
      print("Error: $error");
      Get.snackbar("Error", "An error occurred: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "My Account",
          color: white,
          fontSize: 18,
        ),
      ),
      body: Obx(() => loginController.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          color: redCA0.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: redCA0,
                        ),
                      ),
                      title: CommonTextWidget.PoppinsMedium(
                        text: fullName.isNotEmpty ? fullName : "Guest User",
                        color: black2E2,
                        fontSize: 18,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (emailId.isNotEmpty)
                            Text(
                              emailId,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          CommonTextWidget.PoppinsMedium(
                            text: "Edit Profile",
                            color: redCA0,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18),
                    Divider(color: greyE8E, thickness: 1),
                    SizedBox(height: 20),
                    ListView.builder(
                      itemCount: Lists.myAccountList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(bottom: 30),
                        child: InkWell(
                          onTap: Lists.myAccountList[index]["onTap"],
                          child: Row(
                            children: [
                              Container(
                                height: 52,
                                width: 52,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 4,
                                      color: black262.withOpacity(0.25),
                                    ),
                                  ],
                                  color: white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    Lists.myAccountList[index]["image"],
                                    color: redCA0,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              CommonTextWidget.PoppinsRegular(
                                text: Lists.myAccountList[index]["text"],
                                color: black2E2,
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
}
