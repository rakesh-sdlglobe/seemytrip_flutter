import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Controller/login_controller.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add shared_preferences
import 'package:intl/intl.dart'; // Add intl package for DateFormat
import 'dart:convert'; // For decoding JSON
import 'package:http/http.dart' as http;
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_textfeild_widget.dart';
import 'package:makeyourtripapp/main.dart';

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

  bool isLoading = true;
  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    formattedDate = DateFormat('yyyy-MM-dd').format(now);
  }

  DateTime now = DateTime.now(); // Current date and time
  late String formattedDate;

  Future<void> fetchUserProfile() async {
    try {
      loginController.isLoading.value = true;
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

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        loginController.userData.value = responseData;
        print("User Profile: $responseData");

        fullNameController.text = responseData['firstName'] ?? '';
        genderController.text = responseData['gender'] ?? '';
        dateOfBirthController.text = responseData['dob'] ?? '';
        nationalityController.text = responseData['nationality'] ?? '';
        emailIdController.text = responseData['email'] ?? '';
        mobileNumberController.text = responseData['phoneNumber'] ?? '';

      } else {
        Get.snackbar("Error", "Failed to fetch user profile.");
      }
    } catch (error) {
      Get.snackbar("Error", "An error occurred: $error");
    } finally {
      loginController.isLoading.value = false;
    }
  }

  Future<void> editProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    if (accessToken != null) {
      final String serverEndpoint =
          'http://192.168.1.103:3002/api/users/editProfile';
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final Map<String, dynamic> body = {
        'name': fullNameController.text,
        'gender': genderController.text,
        'dob': dateOfBirthController.text,
        'email': emailIdController.text,
        'mobile': mobileNumberController.text,
      };

      final response = await http.post(
        Uri.parse(serverEndpoint),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully');
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to update profile');
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print('Access token not found');
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
          text: "Edit Profile",
          color: white,
          fontSize: 18,
        ),
        actions: [
          InkWell(
            onTap: () {
              editProfile();
              Get.back();
            },
            child: Padding(
              padding: EdgeInsets.only(right: 24, top: 20),
              child: CommonTextWidget.PoppinsMedium(
                text: "Save",
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
        } else {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 25),
                    InkWell(
                      onTap: () {
                        Get.defaultDialog(
                          radius: 4,
                          backgroundColor: white,
                          title: "",
                          contentPadding: EdgeInsets.zero,
                          titlePadding: EdgeInsets.zero,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 15, top: 13),
                                child: CommonTextWidget.PoppinsMedium(
                                  text: "Select Photo",
                                  color: black2E2,
                                  fontSize: 14,
                                ),
                              ),
                              Divider(color: greyE2E, thickness: 1),
                              ListTile(
                                horizontalTitleGap: 16,
                                leading: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: SvgPicture.asset(cameraIcon),
                                ),
                                title: CommonTextWidget.PoppinsMedium(
                                  text: "Camera",
                                  color: grey717,
                                  fontSize: 14,
                                ),
                                subtitle: CommonTextWidget.PoppinsRegular(
                                  text: "Take a beautiful picture",
                                  color: greyAFA,
                                  fontSize: 12,
                                ),
                              ),
                              Divider(color: greyE2E, thickness: 1),
                              ListTile(
                                horizontalTitleGap: 16,
                                leading: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: SvgPicture.asset(galleryIcon),
                                ),
                                title: CommonTextWidget.PoppinsMedium(
                                  text: "Gallery",
                                  color: grey717,
                                  fontSize: 14,
                                ),
                                subtitle: CommonTextWidget.PoppinsRegular(
                                  text: "Choose an existing photo",
                                  color: greyAFA,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            // Image.asset(myAccountImage, height: 90, width: 90),
                            Icon(Icons.account_circle, size: 130, color: redCA0),
                            // SvgPicture.asset(editIcon),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 22),
                    CommonTextWidget.PoppinsMedium(
                      text: "Name",
                      color: black2E2,
                      fontSize: 14,
                    ),
                    SizedBox(height: 10),
                    CommonTextFieldWidget.TextFormField8(
                      keyboardType: TextInputType.name,
                      controller: fullNameController,
                      hintText: "Unkonwn",
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(16),
                        child: SvgPicture.asset(profileIcon),
                      ),
                    ),
                    SizedBox(height: 22),
                    CommonTextWidget.PoppinsMedium(
                      text: "Gender",
                      color: black2E2,
                      fontSize: 14,
                    ),
                    SizedBox(height: 10),
                    CommonTextFieldWidget.TextFormField8(
                      keyboardType: TextInputType.text,
                      controller: genderController,
                      hintText: "Male",
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(16),
                        child: SvgPicture.asset(genderIcon),
                      ),
                    ),
                    // SizedBox(height: 22),
                    // CommonTextWidget.PoppinsMedium(
                    //   text: "Date Of Birth",
                    //   color: black2E2,
                    //   fontSize: 14,
                    // ),
                    // SizedBox(height: 10),
                    // CommonTextFieldWidget.TextFormField8(
                    //   keyboardType: TextInputType.text,
                    //   controller:
                    //       dateOfBirthController, // Just use the controller directly
                    //   hintText: "25 Oct 2022",
                    //   suffixIcon: Padding(
                    //     padding: EdgeInsets.all(16),
                    //     child: SvgPicture.asset(calendarIcon),
                    //   ),
                    // ),
                    SizedBox(height: 22),
                    CommonTextWidget.PoppinsMedium(
                      text: "Nationality",
                      color: black2E2,
                      fontSize: 14,
                    ),
                    SizedBox(height: 10),
                    CommonTextFieldWidget.TextFormField8(
                      keyboardType: TextInputType.text,
                      controller: nationalityController,
                      hintText: "India",
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(16),
                        child: Image.asset(india, height: 16, width: 22),
                      ),
                    ),
                    SizedBox(height: 22),
                    CommonTextWidget.PoppinsMedium(
                      text: "Email ID",
                      color: black2E2,
                      fontSize: 14,
                    ),
                    SizedBox(height: 10),
                    CommonTextFieldWidget.TextFormField8(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailIdController,
                      hintText: "ellisonperry@123",
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(16),
                        child: SvgPicture.asset(emailIcon),
                      ),
                    ),
                    SizedBox(height: 22),
                    CommonTextWidget.PoppinsMedium(
                      text: "Mobile No.",
                      color: black2E2,
                      fontSize: 14,
                    ),
                    SizedBox(height: 10),
                    CommonTextFieldWidget.TextFormField8(
                      keyboardType: TextInputType.number,
                      controller: mobileNumberController,
                      hintText: "84XXX XXXXX",
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(16),
                        child: SvgPicture.asset(smartphoneIcon),
                      ),
                    ),
                    SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
