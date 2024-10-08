import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';
import 'package:makeyourtripapp/main.dart';

class UpComingTripScreen extends StatelessWidget {
  UpComingTripScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 20, left: 24, right: 24),
        itemCount: Lists.myTripList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Container(
            height: 100,
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: white,
              boxShadow: [
                BoxShadow(
                  color: grey656.withOpacity(0.25),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    ),
                    image: DecorationImage(
                      image: AssetImage(
                        Lists.myTripList[index],
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextWidget.PoppinsSemiBold(
                          text:
                              "Top 5 Indian Destinations for a Fun Family Trip ",
                          color: black2E2,
                          fontSize: 13,
                        ),
                        CommonTextWidget.PoppinsRegular(
                          text: "Explore Himachal Pradesh & 4 more places",
                          color: grey5F5,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
