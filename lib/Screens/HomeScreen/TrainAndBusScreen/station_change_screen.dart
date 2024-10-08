import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/TrainAndBusScreen/train_and_bus_search_screen2.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';

class StationChangeScreen extends StatelessWidget {
  StationChangeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 300),
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: redCA0,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: CommonTextWidget.PoppinsMedium(
                    text: "Station Change",
                    color: white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextWidget.PoppinsMedium(
                    text: "You searched for trains between NDLS and HWH",
                    color: grey888,
                    fontSize: 12,
                  ),
                  SizedBox(height: 5),
                  CommonTextWidget.PoppinsMedium(
                    text:
                        "But this train travels between ANDI (Adrsh Ngr Delhi) "
                        "and HWH (Howrah Jn)",
                    color: black2E2,
                    fontSize: 12,
                  ),
                  SizedBox(height: 30),
                  Image.asset(stationChangeImage),
                  SizedBox(height: 30),
                  Image.asset(stationChangeImage2),
                  SizedBox(height: 45),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: CommonTextWidget.PoppinsMedium(
                          text: "Back",
                          color: redCA0,
                          fontSize: 16,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => TrainAndBusSearchScreen2());
                        },
                        child: CommonTextWidget.PoppinsMedium(
                          text: "OK, Go AHEAD",
                          color: redCA0,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
