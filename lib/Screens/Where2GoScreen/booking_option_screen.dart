import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Screens/Where2GoScreen/select_timing_screen.dart';
import 'package:seemytrip/main.dart';

import '../Utills/lists_widget.dart';

class BookingOptionScreen extends StatefulWidget {
  BookingOptionScreen({Key? key}) : super(key: key);

  @override
  State<BookingOptionScreen> createState() => _BookingOptionScreenState();
}

class _BookingOptionScreenState extends State<BookingOptionScreen> {
  int indexSelected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "Booking Options",
          color: white,
          fontSize: 18,
        ),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonTextWidget.PoppinsMedium(
                      text: "Selected Date : 13 OCT, 2022",
                      color: black2E2,
                      fontSize: 14,
                    ),
                    CommonTextWidget.PoppinsRegular(
                      text: "Full Calendar",
                      color: redCA0,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 63,
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 24, right: 14),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 8,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          indexSelected = index;
                        });
                      },
                      child: Container(
                        height: 63,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6),
                            topLeft: Radius.circular(6),
                          ),
                          border: Border.all(
                            color: indexSelected == index ? redCA0 : greyAFA,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 70,
                              height: 25,
                              decoration: BoxDecoration(
                                color:
                                    indexSelected == index ? redCA0 : greyAFA,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                ),
                              ),
                              child: Center(
                                child: CommonTextWidget.PoppinsMedium(
                                  text: "OCT",
                                  color: white,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            CommonTextWidget.PoppinsRegular(
                              text: Lists.dayList[index],
                            ),
                            SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Divider(color: greyE8E, thickness: 1),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: () {
                    Get.bottomSheet(
                      SelectTimingScreen(),
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                    );
                  },
                  child: Image.asset(
                    bookingOptionImage9,
                    // width: 365,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
