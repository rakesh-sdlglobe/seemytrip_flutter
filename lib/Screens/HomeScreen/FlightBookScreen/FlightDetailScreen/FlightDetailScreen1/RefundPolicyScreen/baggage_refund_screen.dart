import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';

class BaggageRefundSCreen extends StatelessWidget {
  BaggageRefundSCreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Table(
              border: TableBorder(
                bottom: BorderSide(color: greyE2E, width: 1),
                top: BorderSide(color: greyE2E, width: 1),
                left: BorderSide(color: greyE2E, width: 1),
                right: BorderSide(color: greyE2E, width: 1),
                verticalInside: BorderSide(color: greyE2E, width: 1),
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: grey9B9.withOpacity(0.15),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8, left: 8, bottom: 8),
                      child: CommonTextWidget.PoppinsMedium(
                        text: "Cabin",
                        color: black2E2,
                        fontSize: 14,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, right: 8, left: 8),
                      child: CommonTextWidget.PoppinsMedium(
                        text: "Check-in",
                        color: black2E2,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: CommonTextWidget.PoppinsMedium(
                        text: "ADULT",
                        color: black2E2,
                        fontSize: 14,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: CommonTextWidget.PoppinsRegular(
                        text: "7 Kgs (1 piece only)",
                        color: black2E2,
                        fontSize: 11,
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.all(10),
                    //   child: CommonTextWidget.PoppinsRegular(
                    //     text: "15 Kgs (1 piece only)",
                    //     color: black2E2,
                    //     fontSize: 11,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: orangeEB9.withOpacity(0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: CommonTextWidget.PoppinsMedium(
                text:
                    "Important: The Baggage info is indicative. MakeMyTrip does "
                    "not guarantee the accuracy of the information. Kindly check "
                    "with airline website for accurate cancellation information. "
                    "The baggage allowance may vary according to stop-overs "
                    "connecting flights and charges in airline rules.",
                color: black2E2,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
