import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/Utills/common_button_widget.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Screens/Utills/lists_widget.dart';

class RoomsAndGuestScreen extends StatelessWidget {
  RoomsAndGuestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 503,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 65,
              width: Get.width,
              decoration: BoxDecoration(
                color: redCA0,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.close, color: white, size: 20),
                    ),
                    CommonTextWidget.PoppinsMedium(
                      text: "Rooms & Guests",
                      color: white,
                      fontSize: 18,
                    ),
                    SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            Container(
              height: 89,
              width: Get.width,
              color: redF9E.withOpacity(0.75),
              child: ListTile(
                contentPadding:
                    EdgeInsets.only(top: 15, left: 24, right: 24, bottom: 15),
                leading: Image.asset(manager, height: 35, width: 35),
                title: CommonTextWidget.PoppinsSemiBold(
                  text: "Group booking made easy!",
                  color: black2E2,
                  fontSize: 15,
                ),
                subtitle: CommonTextWidget.PoppinsRegular(
                  text:
                      "Save More! Get excting group booking deals for 5+ rooms.",
                  color: grey717,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: Lists.roomsAndGuestsList.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 24, right: 24, top: 0),
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTextWidget.PoppinsMedium(
                                text: Lists.roomsAndGuestsList[index]["text1"],
                                color: black2E2,
                                fontSize: 14,
                              ),
                              CommonTextWidget.PoppinsRegular(
                                text: Lists.roomsAndGuestsList[index]["text2"],
                                color: grey717,
                                fontSize: 12,
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: white,
                              boxShadow: [
                                BoxShadow(
                                  color: grey515.withOpacity(0.25),
                                  blurRadius: 6,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 7),
                              child: Row(
                                children: [
                                  CommonTextWidget.PoppinsSemiBold(
                                    text: Lists.roomsAndGuestsList[index]
                                        ["text3"],
                                    color: black2E2,
                                    fontSize: 17,
                                  ),
                                  SizedBox(width: 30),
                                  SvgPicture.asset(arrowDownIcon),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 28),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CommonButtonWidget.button(
                      text: "DONE",
                      onTap: () {},
                      buttonColor: redCA0,
                    ),
                  ),
                  SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
