import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/MyAccountScreen/edit_profile_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';
import 'package:makeyourtripapp/main.dart';

class DrawerScreen extends StatelessWidget {
  DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
            text: "View/Edit Profile",
            color: redCA0,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 10),
        Divider(color: greyE8E, thickness: 1),
        SizedBox(height: 15),
        ListView.builder(
          itemCount: Lists.homeDrawerList.length,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 24),
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: InkWell(
              onTap: Lists.homeDrawerList[index]["onTap"],
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
                        Lists.homeDrawerList[index]["image"],
                        color: redCA0,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  CommonTextWidget.PoppinsRegular(
                    text: Lists.homeDrawerList[index]["text"],
                    color: black2E2,
                    fontSize: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
