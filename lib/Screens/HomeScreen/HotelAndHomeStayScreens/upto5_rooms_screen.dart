import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';
import 'package:makeyourtripapp/main.dart';

class UpTo5RoomsScreen extends StatelessWidget {
  UpTo5RoomsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 35),
        ListView.builder(
          shrinkWrap: true,
          itemCount: Lists.upTo5RoomsList.length,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24),
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: InkWell(
              onTap: Lists.upTo5RoomsList[index]["onTap"],
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: grey9B9.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 1, color: greyE2E),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                  child: Row(
                    children: [
                      SvgPicture.asset(Lists.upTo5RoomsList[index]["image"]),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsMedium(
                            text: Lists.upTo5RoomsList[index]["text1"],
                            color: grey888,
                            fontSize: 14,
                          ),
                          Row(
                            children: [
                              CommonTextWidget.PoppinsSemiBold(
                                text: Lists.upTo5RoomsList[index]["text2"],
                                color: black2E2,
                                fontSize: 18,
                              ),
                              CommonTextWidget.PoppinsMedium(
                                text: Lists.upTo5RoomsList[index]["text3"],
                                color: grey888,
                                fontSize: 12,
                              ),
                            ],
                          ),
                         index == 0?CommonTextWidget.PoppinsRegular(
                            text: "India",
                            color: grey888,
                            fontSize: 12,
                          ):SizedBox.shrink(),
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
            text: "Improve Your Search",
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
              itemCount: Lists.improveYorSearchList.length,
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
                        text: Lists.improveYorSearchList[index],
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
      ],
    );
  }
}
