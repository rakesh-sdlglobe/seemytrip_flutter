import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/TrainAndBusScreen/train_and_bus_detail_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';
import 'package:makeyourtripapp/main.dart';

class TrainAndBusSearchScreen extends StatefulWidget {
  TrainAndBusSearchScreen({Key? key}) : super(key: key);

  @override
  State<TrainAndBusSearchScreen> createState() =>
      _TrainAndBusSearchScreenState();
}

class _TrainAndBusSearchScreenState extends State<TrainAndBusSearchScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: Get.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(busAndTrainImage),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 24, right: 24, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back, color: white, size: 20),
                  ),
                  CommonTextWidget.PoppinsSemiBold(
                    text: "Train Search",
                    color: white,
                    fontSize: 18,
                  ),
                  Container(),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 24),
            itemCount: Lists.trainAndBusFromToList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: InkWell(
                onTap: Lists.trainAndBusFromToList[index]["onTap"],
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: grey9B9.withOpacity(0.15),
                    border: Border.all(color: greyE2E, width: 1),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Row(
                      children: [
                        SvgPicture.asset(trainAndBusFromToIcon),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonTextWidget.PoppinsMedium(
                              text: Lists.trainAndBusFromToList[index]["text1"],
                              color: grey888,
                              fontSize: 14,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CommonTextWidget.PoppinsSemiBold(
                                  text: Lists.trainAndBusFromToList[index]
                                      ["text2"],
                                  color: black2E2,
                                  fontSize: 16,
                                ),
                                SizedBox(width: 5),
                                CommonTextWidget.PoppinsRegular(
                                  text: Lists.trainAndBusFromToList[index]
                                      ["text3"],
                                  color: grey888,
                                  fontSize: 14,
                                ),
                              ],
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: grey9B9.withOpacity(0.15),
                border: Border.all(color: greyE2E, width: 1),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SvgPicture.asset(calendarPlus),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTextWidget.PoppinsMedium(
                                text: "DATE",
                                color: grey888,
                                fontSize: 14,
                              ),
                              CommonTextWidget.PoppinsSemiBold(
                                text: "03 Oct",
                                color: black2E2,
                                fontSize: 14,
                              ),
                              CommonTextWidget.PoppinsRegular(
                                text: "Today, Monday",
                                color: black2E2,
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 30,
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: redFAE.withOpacity(0.8),
                                border: Border.all(color: redCA0, width: 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: CommonTextWidget.PoppinsMedium(
                                  text: "Tomorrow",
                                  color: redCA0,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Container(
                              height: 30,
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: white,
                                boxShadow: [
                                  BoxShadow(
                                    color: grey515.withOpacity(0.25),
                                    blurRadius: 6,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: CommonTextWidget.PoppinsMedium(
                                  text: "Day After",
                                  color: redCA0,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 18),
          SizedBox(
            height: 45,
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Lists.trainAndBusSearchList.length,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 24, right: 9, top: 5, bottom: 5),
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      height: 45,
                      width: 68,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: index == selectedIndex
                                ? Color(0xffCA0F2E)
                                : white),
                        color:
                            index == selectedIndex ? Color(0xffF8EAED) : white,
                        boxShadow: [
                          BoxShadow(
                            color: grey515.withOpacity(0.25),
                            offset: Offset(0, 1),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Center(
                        child: CommonTextWidget.PoppinsMedium(
                          text: Lists.trainAndBusSearchList[index],
                          color: redCA0,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: CommonButtonWidget.button(
              text: "SEARCH",
              buttonColor: redCA0,
              onTap: () {
                Get.to(() => TrainAndBusDetailScreen());
              },
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
