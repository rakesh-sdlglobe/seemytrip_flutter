import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/utils/colors.dart';
import '../../../../core/widgets/common_text_widget.dart';
import '../../../../core/widgets/lists_widget.dart';
import '../../../../main.dart';
import '../../../../shared/constants/images.dart';
import '../../../airport_cab/presentation/screens/cab_search_screen.dart';
import '../../../bus/presentation/screens/bus_home_screen.dart';
import '../../../flights/presentation/screens/FlightSearchScreen/flight_search_screen.dart';
import '../../../hotels/presentation/screens/hotel_and_home_stay_tab_screen.dart';
import '../../../profile/presentation/screens/notifications/notification_screen.dart';
import '../../../train/presentation/screens/train_screen.dart';
import 'OutStationCabsScreen/out_station_cab_screen.dart';
import 'home_search_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: white,
      key: _key,
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 250,
                width: Get.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(homeTopBgImage),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 24, right: 24, top: 60, bottom: 75),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          // InkWell(
                          //   onTap: () {
                          //     _key.currentState!.openDrawer();
                          //   },
                          //   child: Image.asset(menuIcon, height: 42, width: 42),
                          // ),
                          // Column(
                          //   children: [
                          //     CommonTextWidget.PoppinsRegular(
                          //       text: "Good Morning",
                          //       color: white,
                          //       fontSize: 14,
                          //     ),
                          //     CommonTextWidget.PoppinsMedium(
                          //       text: "Andrew Smith",
                          //       color: white,
                          //       fontSize: 16,
                          //     ),
                          //   ],
                          // ),
                          InkWell(
                            onTap: () {
                              Get.to(() => NotificationScreen());
                              //  Get.to(()=>OtpScreen());
                            },
                            child: Image.asset(notificationIcon,
                                height: 42, width: 42),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Get.to(() => HomeSearchSCreen());
                        },
                        child: Container(
                          height: 44,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.search, color: grey717),
                                SizedBox(width: 15),
                                CommonTextWidget.PoppinsRegular(
                                  text: "Try Mumbai to Pune Bus....  ",
                                  color: grey717,
                                  fontSize: 15,
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
              Padding(
                padding: EdgeInsets.only(top: 250),
                child: Container(
                  width: Get.width,
                  color: white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(() => CabSearchScreen());
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 70),
                                  Image.asset(airportAndCabs,
                                      height: 55, width: 55),
                                  SizedBox(height: 8),
                                  CommonTextWidget.PoppinsMedium(
                                    text: "airportCabs".tr,
                                    color: black2E2,
                                    fontSize: 12,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => HotelAndHomeStayTabScreen());
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 70),
                                  Image.asset(homeStays, height: 55, width: 55),
                                  SizedBox(height: 8),
                                  CommonTextWidget.PoppinsMedium(
                                    text: "homeStays".tr,
                                    color: black2E2,
                                    fontSize: 12,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => OutStationCabScreen());
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 70),
                                  Image.asset(outstationCabs,
                                      height: 55, width: 55),
                                  SizedBox(height: 8),
                                  CommonTextWidget.PoppinsMedium(
                                    text: "outstationCabs".tr,
                                    color: black2E2,
                                    fontSize: 12,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => OutStationCabScreen());
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 70),
                                  Image.asset(hourlyStays,
                                      height: 55, width: 55),
                                  SizedBox(height: 8),
                                  CommonTextWidget.PoppinsMedium(
                                    text: "hourlyStays".tr,
                                    color: black2E2,
                                    fontSize: 12,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: 50,
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: white,
                          boxShadow: [
                            BoxShadow(
                              color: grey656.withOpacity(0.25),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: ListView.builder(
                            padding: EdgeInsets.only(left: 35, right: 15),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: Lists.homeList1.length,
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.only(right: 9),
                              child: InkWell(
                                onTap: Lists.homeList1[index]["onTap"],
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        Lists.homeList1[index]["image"]),
                                    SizedBox(width: 6),
                                    CommonTextWidget.PoppinsMedium(
                                      text: Lists.homeList1[index]["text"],
                                      color: black2E2,
                                      fontSize: 12,
                                    ),
                                    SizedBox(width: 9),
                                    index == 3
                                        ? SizedBox.shrink()
                                        : SizedBox(
                                            height: 30,
                                            child: VerticalDivider(
                                              color: greyD9D,
                                              thickness: 1,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 18),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: CommonTextWidget.PoppinsSemiBold(
                          text: "Welcome Offers for you!".tr,
                          color: black2E2,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          height: 170,
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: AssetImage(welcomeOfferImage),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10, right: 10),
                              child: Image.asset(arrowButtonImage,
                                  height: 32, width: 32),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: CommonTextWidget.PoppinsSemiBold(
                          text: "Tourism Flagship stores".tr,
                          color: black2E2,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          height: 140,
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
                                height: 140,
                                width: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                  ),
                                  image: DecorationImage(
                                    image:
                                        AssetImage(tourismFlagshipStoreImage),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              SizedBox(width: 18),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(saudiaImage,
                                      height: 50, width: 85),
                                  CommonTextWidget.PoppinsBold(
                                    text: "Saudi Arabia, \nHere We Come!",
                                    color: black2E2,
                                    fontSize: 14,
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    height: 30,
                                    width: 95,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: redCA0,
                                    ),
                                    child: Center(
                                      child: CommonTextWidget.PoppinsMedium(
                                        text: "Explore Now!",
                                        color: white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonTextWidget.PoppinsSemiBold(
                              text: "Latest Collections for you",
                              color: black2E2,
                              fontSize: 16,
                            ),
                            Row(
                              children: [
                                CommonTextWidget.PoppinsRegular(
                                  text: "View All",
                                  color: redCA0,
                                  fontSize: 14,
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_ios,
                                    color: redCA0, size: 18),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: Lists.homeList2.length,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Container(
                            height: 120,
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
                                  height: 120,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        Lists.homeList2[index]["image"],
                                      ),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.location_on,
                                              color: redCA0, size: 18),
                                          SizedBox(width: 7),
                                          CommonTextWidget.PoppinsSemiBold(
                                            text: Lists.homeList2[index]
                                                ["text1"],
                                            color: redCA0,
                                            fontSize: 10,
                                          ),
                                        ],
                                      ),
                                      CommonTextWidget.PoppinsMedium(
                                        text: Lists.homeList2[index]["text2"],
                                        color: black2E2,
                                        fontSize: 10,
                                      ),
                                      CommonTextWidget.PoppinsMedium(
                                        text: "5-8 Working Days",
                                        color: blue1F9,
                                        fontSize: 12,
                                      ),
                                      Row(
                                        children: [
                                          CommonTextWidget.PoppinsMedium(
                                            text: Lists.homeList2[index]
                                                ["text3"],
                                            color: black2E2,
                                            fontSize: 12,
                                          ),
                                          SizedBox(width: 10),
                                          CommonTextWidget.PoppinsRegular(
                                            text: "Per Person",
                                            color: grey717,
                                            fontSize: 10,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 24, right: 24, top: 215),
                    child: Container(
                      height: 88,
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: grey757.withOpacity(0.25),
                            blurRadius: 6,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 39, right: 39, top: 193),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => FlightSearchScreen());
                          },
                          child: Column(
                            children: [
                              Image.asset(flight, height: 55, width: 55),
                              SizedBox(height: 8),
                              CommonTextWidget.PoppinsMedium(
                                text: 'flight'.tr,
                                color: black2E2,
                                fontSize: 12,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => TrainScreen());
                          },
                          child: Column(
                            children: [
                              Image.asset(train, height: 55, width: 55),
                              SizedBox(height: 8),
                              CommonTextWidget.PoppinsMedium(
                                text: "train".tr,
                                color: black2E2,
                                fontSize: 12,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => HotelAndHomeStayTabScreen());
                          },
                          child: Column(
                            children: [
                              Image.asset(hotel, height: 55, width: 55),
                              SizedBox(height: 8),
                              CommonTextWidget.PoppinsMedium(
                                text: "hotel".tr,
                                color: black2E2,
                                fontSize: 12,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     Get.to(() => HolidayPackagesScreen());
                        //   },
                        //   child: Column(
                        //     children: [
                        //       Image.asset(holidayPakages,
                        //           height: 55, width: 55),
                        //       SizedBox(height: 8),
                        //       CommonTextWidget.PoppinsMedium(
                        //         text: "holidayPackages".tr,
                        //         color: black2E2,
                        //         fontSize: 12,
                        //         textAlign: TextAlign.center,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                         InkWell(
                          onTap: () {
                            Get.to(() => BusHomeScreen());
                          },
                          child: Column(
                            children: [
                              Image.asset(trainsAndBus,
                                  height: 55, width: 55),
                              SizedBox(height: 8),
                              CommonTextWidget.PoppinsMedium(
                                text: "Bus".tr,
                                color: black2E2,
                                fontSize: 12,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
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
    );
}
