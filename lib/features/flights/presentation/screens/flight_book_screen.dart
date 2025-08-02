import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/features/booking/presentation/screens/sort_filter/sort_and_filter_screen.dart';
import 'package:seemytrip/features/flights/presentation/controllers/flight_book_controller.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/shared/constants/font_family.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/features/home/presentation/screens/CalendarScreen/calender_screen.dart';
import 'package:seemytrip/features/flights/presentation/screens/FlightModifySearch/flight_modify_search.dart';
import 'package:seemytrip/features/flights/presentation/screens/cheapest_list_screen.dart';
import 'package:seemytrip/features/flights/presentation/screens/keep_track_price_screen.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';
import 'package:seemytrip/main.dart';


class FlightBookScreen extends StatelessWidget {
  FlightBookScreen({Key? key}) : super(key: key);
  final FlightBookController flightBookController =
      Get.put(FlightBookController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redF9E,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 155,
                width: Get.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(flightSearch2TopImage),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 24, right: 24, top: 60, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 5,
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
                              child: Icon(Icons.arrow_back,
                                  color: grey888, size: 20),
                            ),
                            title: CommonTextWidget.PoppinsRegular(
                              text: "New Delhi to Mumbai",
                              color: black2E2,
                              fontSize: 15,
                            ),
                            subtitle: CommonTextWidget.PoppinsRegular(
                              text: "24 Sep | 1 Adult | Economy",
                              color: grey717,
                              fontSize: 12,
                            ),
                            trailing: InkWell(
                              onTap: () {
                                Get.to(() => FlightModifySearch());
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
                      SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.bottomSheet(
                              KeepTrackPriceScreen(),
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                            );
                          },
                          child: Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 7),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(notification),
                                  CommonTextWidget.PoppinsMedium(
                                    text: "Price Alert",
                                    color: redCA0,
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: Get.width,
                color: white,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: redCA0,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          ),
                        ),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: CommonTextWidget.PoppinsMedium(
                              text: "SEP",
                              color: white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          width: Get.width,
                          child: GetBuilder<FlightBookController>(
                            init: FlightBookController(),
                            builder: (controller) => ListView.builder(
                              itemCount: Lists.flightBookList1.length,
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 4),
                                      child: Column(
                                        children: [
                                          CommonTextWidget.PoppinsMedium(
                                            text: Lists.flightBookList1[index]
                                                ["text1"],
                                            color: controller.selectedIndex ==
                                                    index
                                                ? white
                                                : grey717,
                                            fontSize: 10,
                                          ),
                                          CommonTextWidget.PoppinsMedium(
                                            text: Lists.flightBookList1[index]
                                                ["text2"],
                                            color: controller.selectedIndex ==
                                                    index
                                                ? white
                                                : grey717,
                                            fontSize: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => CalenderScreen());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: redCA0,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: SvgPicture.asset(calendar),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  height: 55,
                  width: Get.width,
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TabBar(
                    tabs: flightBookController.myTabs,
                    unselectedLabelColor: black2E2,
                    labelStyle:
                        TextStyle(fontSize: 16, fontFamily: "PoppinsMedium"),
                    unselectedLabelStyle:
                        TextStyle(fontSize: 16, fontFamily: "PoppinsMedium"),
                    labelColor: white,
                    controller: flightBookController.controller,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(5), color: redCA0),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Expanded(
                child: TabBarView(
                  controller: flightBookController.controller,
                  children: [
                    CheapestListScreen(),
                    CheapestListScreen(),
                    CheapestListScreen(),
                  ],
                ),
              ),
              SizedBox(height: 120),
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
                            itemCount: Lists.flightBookList2.length,
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
                                      Lists.flightBookList2[index],
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
