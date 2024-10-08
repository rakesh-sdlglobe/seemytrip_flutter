import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_textfeild_widget.dart';
import 'package:makeyourtripapp/main.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController emailIdController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();

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
      body: ScrollConfiguration(
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
                        Image.asset(myAccountImage, height: 90, width: 90),
                        SvgPicture.asset(editIcon),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 22),
                CommonTextWidget.PoppinsMedium(
                  text: "Full Name",
                  color: black2E2,
                  fontSize: 14,
                ),
                SizedBox(height: 10),
                CommonTextFieldWidget.TextFormField8(
                  keyboardType: TextInputType.name,
                  controller: fullNameController,
                  hintText: "Ellison Perry",
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
                SizedBox(height: 22),
                CommonTextWidget.PoppinsMedium(
                  text: "Date of Birth",
                  color: black2E2,
                  fontSize: 14,
                ),
                SizedBox(height: 10),
                CommonTextFieldWidget.TextFormField8(
                  keyboardType: TextInputType.text,
                  controller: fullNameController,
                  hintText: "25 Oct 2022",
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(16),
                    child: SvgPicture.asset(calendarIcon),
                  ),
                ),
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
                  hintText: "84520 25360",
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
      ),
    );
  }
}
