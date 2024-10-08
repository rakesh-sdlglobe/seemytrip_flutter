import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/AirportCabsScreens/cab_terminal_screen2.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';
import 'package:makeyourtripapp/main.dart';

class CabTerminalScreen1 extends StatelessWidget {
  CabTerminalScreen1({Key? key}) : super(key: key);

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
                image: AssetImage(cabTerminalImage1),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 24, right: 24, top: 55),
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
                    text: "Terminal 1C to Delhi...",
                    color: white,
                    fontSize: 18,
                  ),
                  Container(),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Image.asset(cabTerminalImage2),
          ),
          SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              height: 25,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: grey9B9.withOpacity(0.15),
                border: Border.all(color: greyE2E, width: 1),
              ),
              child: Center(
                child: CommonTextWidget.PoppinsMedium(
                  text:
                      "Distance for selected route is 9kms | Approx 0.5 hr(s)",
                  color: grey575,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Divider(color: greyE8E, thickness: 5),
          SizedBox(height: 15),
          Expanded(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView.builder(
                itemCount: Lists.cabTerminalList.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Get.to(() => CabTerminalScreen2());
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Image.asset(
                          Lists.cabTerminalList[index],
                        ),
                      ),
                      SizedBox(height: 15),
                      Divider(color: greyE8E, thickness: 5),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
