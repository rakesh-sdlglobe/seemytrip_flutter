import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Controller/flight_book_controller.dart';
import 'package:makeyourtripapp/Controller/train_and_bus_detail_controller.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/TrainAndBusScreen/station_change_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/TrainAndBusScreen/train_and_bus_modify_search_screen.dart';
import 'package:makeyourtripapp/Screens/SortAndFilterScreen/sort_and_filter_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';
import 'package:makeyourtripapp/main.dart';

import '../../../Constants/font_family.dart';

class TrainAndBusDetailScreen extends StatelessWidget {
  TrainAndBusDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redF9E,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 135,
                width: Get.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(busAndTrainImage),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 24, right: 24, top: 60, bottom: 10),
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ListTile(
                      horizontalTitleGap: -5,
                      leading: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.arrow_back, color: grey888, size: 20),
                      ),
                      title: CommonTextWidget.PoppinsRegular(
                        text: "Delhi To Kolkata",
                        color: black2E2,
                        fontSize: 15,
                      ),
                      subtitle: CommonTextWidget.PoppinsRegular(
                        text: "04 Oct, Tuesday",
                        color: grey717,
                        fontSize: 12,
                      ),
                      trailing: InkWell(
                        onTap: () {
                          Get.to(() => TrainAndBusModifySearchScreen());
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(draw),
                            SizedBox(height: 10),
                            CommonTextWidget.PoppinsMedium(
                              text: "Edit",
                              color: redCA0,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: Get.width,
                color: white,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 24),
                        child: Container(
                          decoration: BoxDecoration(
                            color: redCA0,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: CommonTextWidget.PoppinsMedium(
                                text: "OCT",
                                color: white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          width: Get.width,
                          child: GetBuilder<TrainAndBusDetailController>(
                            init: TrainAndBusDetailController(),
                            builder: (controller) => ListView.builder(
                              itemCount: Lists.trainAndBusDetailList1.length,
                              padding: EdgeInsets.only(left: 6),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => Padding(
                                padding: EdgeInsets.only(right: 6),
                                child: InkWell(
                                  onTap: () {
                                    controller.onIndexChange(index);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: controller.selectedIndex == index
                                          ? redCA0
                                          : white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color:
                                              controller.selectedIndex == index
                                                  ? redCA0
                                                  : greyE2E,
                                          width: 1),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Center(
                                        child: CommonTextWidget.PoppinsMedium(
                                          text: Lists
                                              .trainAndBusDetailList1[index],
                                          color:
                                              controller.selectedIndex == index
                                                  ? white
                                                  : grey717,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Expanded(
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: 4,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Container(
                        width: Get.width,
                        color: white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonTextWidget.PoppinsSemiBold(
                                    text: index == 0
                                        ? "Hwg Duronto Exp"
                                        : "Anvt Src Sf Exp",
                                    color: black2E2,
                                    fontSize: 14,
                                  ),
                                  CommonTextWidget.PoppinsMedium(
                                    text: "#12568",
                                    color: greyB8B,
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      CommonTextWidget.PoppinsSemiBold(
                                        text: "12:40 PM",
                                        color: black2E2,
                                        fontSize: 14,
                                      ),
                                      CommonTextWidget.PoppinsMedium(
                                        text: "4 Oct",
                                        color: greyB8B,
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 2,
                                        width: 30,
                                        color: greyDBD,
                                      ),
                                      SizedBox(width: 15),
                                      CommonTextWidget.PoppinsMedium(
                                        text: "21h 55m",
                                        color: grey717,
                                        fontSize: 12,
                                      ),
                                      SizedBox(width: 15),
                                      Container(
                                        height: 2,
                                        width: 30,
                                        color: greyDBD,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      CommonTextWidget.PoppinsSemiBold(
                                        text: "10:35 AM",
                                        color: black2E2,
                                        fontSize: 14,
                                      ),
                                      CommonTextWidget.PoppinsMedium(
                                        text: "5 Oct",
                                        color: greyB8B,
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Get.bottomSheet(
                                          StationChangeScreen(),
                                          backgroundColor: Colors.transparent,
                                          isScrollControlled: true,
                                        );
                                      },
                                      child: Container(
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
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  CommonTextWidget
                                                      .PoppinsMedium(
                                                    text: "SL",
                                                    color: black2E2,
                                                    fontSize: 14,
                                                  ),
                                                  Container(
                                                    height: 20,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      color: redCA0,
                                                    ),
                                                    child: Center(
                                                      child: CommonTextWidget
                                                          .PoppinsMedium(
                                                        text: "TATKAL",
                                                        color: white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  CommonTextWidget
                                                      .PoppinsMedium(
                                                    text: "₹ 855",
                                                    color: black2E2,
                                                    fontSize: 14,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              CommonTextWidget.PoppinsRegular(
                                                text: "TQWL 5",
                                                color: redCA0,
                                                fontSize: 12,
                                              ),
                                              CommonTextWidget.PoppinsRegular(
                                                text: "Free cancellation",
                                                color: grey717,
                                                fontSize: 12,
                                              ),
                                              SizedBox(height: 5),
                                              CommonTextWidget.PoppinsRegular(
                                                text: "Updated few mins ago",
                                                color: grey878,
                                                fontSize: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Container(
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
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                CommonTextWidget.PoppinsMedium(
                                                  text: "2S",
                                                  color: black2E2,
                                                  fontSize: 14,
                                                ),
                                                Container(
                                                  height: 20,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: redCA0,
                                                  ),
                                                  child: Center(
                                                    child: CommonTextWidget
                                                        .PoppinsMedium(
                                                      text: "TATKAL",
                                                      color: white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                CommonTextWidget.PoppinsMedium(
                                                  text: "₹ 720",
                                                  color: black2E2,
                                                  fontSize: 14,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            CommonTextWidget.PoppinsRegular(
                                              text: "TQWL 14",
                                              color: redCA0,
                                              fontSize: 12,
                                            ),
                                            CommonTextWidget.PoppinsRegular(
                                              text: "Free cancellation",
                                              color: grey717,
                                              fontSize: 12,
                                            ),
                                            SizedBox(height: 5),
                                            CommonTextWidget.PoppinsRegular(
                                              text: "Updated 2 hrs ago",
                                              color: grey878,
                                              fontSize: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
              ),
              SizedBox(height: 100),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 45, left: 24, right: 24),
              child: Container(
                height: 64,
                width: Get.width,
                decoration: BoxDecoration(
                  color: redCA0,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: ListView.builder(
                            itemCount: Lists.trainAndBusDetailList2.length,
                            padding: EdgeInsets.only(left: 10, right: 4),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.only(right: 6),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Center(
                                    child: Text(
                                      Lists.trainAndBusDetailList2[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        height: 1,
                                        color: grey717,
                                        fontFamily: FontFamily.PoppinsSemiBold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                      child: Column(
                        children: [
                          InkWell(
                              onTap: () {
                                Get.to(() => SortAndFilterScreen());
                              },
                              child: SvgPicture.asset(slidersHorizontal)),
                          SizedBox(height: 2),
                          CommonTextWidget.PoppinsMedium(
                            text: "Filter",
                            color: white,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
