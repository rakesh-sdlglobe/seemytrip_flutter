import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/features/flights/presentation/screens/price_alert_screen.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/main.dart';

class KeepTrackPriceScreen extends StatelessWidget {
  KeepTrackPriceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 400),
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 22, bottom: 45),
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextWidget.PoppinsSemiBold(
                    text: "Keep track of the prices!",
                    color: black2E2,
                    fontSize: 18,
                  ),
                  SizedBox(height: 6),
                  Container(
                    height: 4,
                    width: 30,
                    color: redCA0,
                  ),
                  SizedBox(height: 20),
                  CommonTextWidget.PoppinsRegular(
                    text: "Create an alert for this sector to receive "
                        "notification whenever the flight prices "
                        "increase or decrease.",
                    color: grey888,
                    fontSize: 16,
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: CommonTextWidget.PoppinsSemiBold(
                          text: "NO,THANKS!",
                          color: redCA0,
                          fontSize: 16,
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Get.bottomSheet(
                            PriceAlertScreen(),
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                          );
                        },
                        height: 40,
                        minWidth: 140,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        color: redCA0,
                        child: CommonTextWidget.PoppinsSemiBold(
                          fontSize: 16,
                          text: "YES, I’M IN",
                          color: white,
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
    );
  }
}
