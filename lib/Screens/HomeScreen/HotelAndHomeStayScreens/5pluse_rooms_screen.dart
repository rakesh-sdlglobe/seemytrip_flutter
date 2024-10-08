import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';
import 'package:makeyourtripapp/main.dart';

class FivePlusRoomsScreen extends StatelessWidget {
  FivePlusRoomsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Get.width,
              color: redF9E.withOpacity(0.75),
              child: ListTile(
                contentPadding:
                    EdgeInsets.only(top: 35, left: 24, right: 24, bottom: 15),
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
            SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              itemCount: Lists.fivePlusRoomsList.length,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24),
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: InkWell(
                  onTap: Lists.fivePlusRoomsList[index]["onTap"],
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: grey9B9.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: greyE2E),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                              Lists.fivePlusRoomsList[index]["image"]),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTextWidget.PoppinsMedium(
                                text: Lists.fivePlusRoomsList[index]["text1"],
                                color: redCA0,
                                fontSize: 14,
                              ),
                              CommonTextWidget.PoppinsMedium(
                                text: Lists.fivePlusRoomsList[index]["text2"],
                                color: grey888,
                                fontSize: 14,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonTextWidget.PoppinsMedium(
                text: "Purpose Of Booking",
                color: grey888,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 70,
              width: Get.width,
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView.builder(
                  itemCount: Lists.purposeOfBookingList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding:
                      EdgeInsets.only(top: 13, bottom: 13, left: 24, right: 12),
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: white,
                        border: Border.all(color: greyE2E, width: 1),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: CommonTextWidget.PoppinsMedium(
                            text: Lists.purposeOfBookingList[index],
                            color: grey5F5,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
