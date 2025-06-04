import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Controller/seats_meals_addone_controller.dart';
import 'package:seemytrip/Screens/SeatsMealsAddOneTabScreen/add_one_screen.dart';
import 'package:seemytrip/Screens/SeatsMealsAddOneTabScreen/meals_screen.dart';
import 'package:seemytrip/Screens/SeatsMealsAddOneTabScreen/seats.dart';
import 'package:seemytrip/Screens/SeatsMealsAddOneTabScreen/seats_screen.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import '../SelectPaymentMethodScreen/select_payment_method_screen.dart';

class SeatsMealsAddOneTabScreen extends StatelessWidget {
  SeatsMealsAddOneTabScreen({Key? key}) : super(key: key);
  final SeatsMealsAddOneTabController seatsMealsAddOneTabController =
      Get.put(SeatsMealsAddOneTabController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 130,
                width: Get.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(flightSearch2TopImage),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                              seatSelected.value = false;
                            },
                            child:
                                Icon(Icons.arrow_back, color: white, size: 20),
                          ),
                          SizedBox(width: 25),
                          CommonTextWidget.PoppinsSemiBold(
                            text: "Add-ons",
                            color: white,
                            fontSize: 18,
                          ),
                        ],
                      ),
                      CommonTextWidget.PoppinsMedium(
                        text: "Skip To Payment",
                        color: white,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: seatsMealsAddOneTabController.controller,
                  children: [
                    SeatsScreen(),
                    MealsScreen(),
                    AddOneScreen(),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 110, left: 24, right: 24),
            child: Container(
              height: 45,
              width: Get.width,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: grey757.withOpacity(0.25),
                    blurRadius: 6,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                padding: EdgeInsets.only(left: 0, bottom: 7, right: 0),
                tabs: seatsMealsAddOneTabController.myTabs,
                unselectedLabelColor: grey5F5,
                labelStyle:
                    TextStyle(fontFamily: "PoppinsSemiBold", fontSize: 14),
                unselectedLabelStyle:
                    TextStyle(fontFamily: "PoppinsMedium", fontSize: 14),
                labelColor: redCA0,
                controller: seatsMealsAddOneTabController.controller,
                indicatorColor: redCA0,
                indicatorWeight: 2.5,
              ),
            ),
          ),
          Positioned(
            bottom: 42,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              width: Get.width,
              color: black2E2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonTextWidget.PoppinsSemiBold(
                              text: "₹ 5,950",
                              color: white,
                              fontSize: 16,
                            ),
                            CommonTextWidget.PoppinsMedium(
                              text: "FOR 1 ADULT",
                              color: white,
                              fontSize: 10,
                            ),
                          ],
                        ),
                        SizedBox(width: 15),
                        SvgPicture.asset(info),
                      ],
                    ),
                    MaterialButton(
                      onPressed: () {
                        // log(Lists.seatsList2.length.toString());
                        Get.to(() => SelectPaymentMethodScreen());
                      },
                      height: 40,
                      minWidth: 140,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      color: redCA0,
                      child: CommonTextWidget.PoppinsSemiBold(
                        fontSize: 16,
                        text: "CONTINUE",
                        color: white,
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
