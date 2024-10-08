import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/MyAccountScreen/edit_profile_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';
import 'package:makeyourtripapp/main.dart';

class MyAccountScreen extends StatelessWidget {
  MyAccountScreen({Key? key}) : super(key: key);

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
      body: ScrollConfiguration(
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
                leading: Image.asset(myAccountImage, height: 70, width: 70),
                title: CommonTextWidget.PoppinsMedium(
                  text: "Ellison Perry",
                  color: black2E2,
                  fontSize: 18,
                ),
                subtitle: CommonTextWidget.PoppinsMedium(
                  text: "Edit Profile",
                  color: redCA0,
                  fontSize: 12,
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
      ),
    );
  }
}
