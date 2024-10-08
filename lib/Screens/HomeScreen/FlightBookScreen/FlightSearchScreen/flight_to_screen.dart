import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/font_family.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';
import 'package:makeyourtripapp/main.dart';

class FlightToScreen extends StatelessWidget {
  FlightToScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: greyE8E, width: 1),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back, color: black2E2, size: 20),
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextWidget.PoppinsMedium(
                          text: "From",
                          color: grey717,
                          fontSize: 14,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Ahmedabad ",
                            style: TextStyle(
                              fontFamily: FontFamily.PoppinsMedium,
                              fontSize: 12,
                              color: black2E2,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: "AMD Sardar Vallabhai...",
                                style: TextStyle(
                                    fontSize: 10.5,
                                    fontFamily: FontFamily.PoppinsMedium,
                                    color: grey717),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: redF8E,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: greyE8E, width: 1),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      toFlightImage,
                      width: 22.94,
                      fit: BoxFit.scaleDown,
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextWidget.PoppinsMedium(
                          text: "To",
                          color: black2E2,
                          fontSize: 14,
                        ),
                        CommonTextWidget.PoppinsMedium(
                          text: "Enter any City/Airport Name",
                          color: grey717,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            CommonTextWidget.PoppinsMedium(
              text: "Popular Searches",
              color: grey717,
              fontSize: 12,
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: Lists.fromToList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: CommonTextWidget.PoppinsRegular(
                      text: Lists.fromToList[index]["text1"],
                      color: black2E2,
                      fontSize: 16,
                    ),
                    subtitle: CommonTextWidget.PoppinsRegular(
                      text: Lists.fromToList[index]["text2"],
                      color: grey717,
                      fontSize: 12,
                    ),
                    trailing: CommonTextWidget.PoppinsMedium(
                      text: Lists.fromToList[index]["text3"],
                      color: grey717,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
