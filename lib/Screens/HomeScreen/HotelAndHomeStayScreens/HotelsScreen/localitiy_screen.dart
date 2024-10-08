import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Controller/locality_controller.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_textfeild_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';
import 'package:makeyourtripapp/main.dart';

class LocalityScreen extends StatelessWidget {
  LocalityScreen({Key? key}) : super(key: key);

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 155,
                width: Get.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(hotelAndHomeStayTopImage),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
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
                        text: "Goa",
                        color: white,
                        fontSize: 18,
                      ),
                      Container(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonTextWidget.PoppinsMedium(
                  text: "PREFERRED BY TOURISTS",
                  color: black2E2,
                  fontSize: 14,
                ),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: GetBuilder<LocalityController>(
                    init: LocalityController(),
                    builder: (controller) => ListView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                      shrinkWrap: true,
                      itemCount: Lists.localityList.length,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            controller.onIndexChange(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: white,
                              border: Border.all(
                                color: controller.selectedIndex == index
                                    ? redCA0
                                    : grey515.withOpacity(0.25),
                              ),
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CommonTextWidget.PoppinsSemiBold(
                                        text: Lists.localityList[index],
                                        color: black2E2,
                                        fontSize: 14,
                                      ),
                                      Container(
                                        height: 24,
                                        width: 24,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color:
                                              controller.selectedIndex == index
                                                  ? redCA0
                                                  : white,
                                          border: Border.all(
                                            color: controller.selectedIndex ==
                                                    index
                                                ? redCA0
                                                : grey717,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.check,
                                            color: white,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  CommonTextWidget.PoppinsRegular(
                                    text: "Best for Couple, Family",
                                    color: redCA0,
                                    fontSize: 12,
                                  ),
                                  SizedBox(height: 8),
                                  CommonTextWidget.PoppinsMedium(
                                    text: "2,000 - 5,000 INR",
                                    color: black2E2,
                                    fontSize: 12,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CommonTextWidget.PoppinsRegular(
                                        text: "Avg cost room/Night",
                                        color: grey717,
                                        fontSize: 12,
                                      ),
                                      CommonTextWidget.PoppinsSemiBold(
                                        text: "KNOW MORE",
                                        color: redCA0,
                                        fontSize: 12,
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
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 130, left: 24, right: 24),
            child: Container(
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
              child: CommonTextFieldWidget.TextFormField2(
                keyboardType: TextInputType.text,
                controller: searchController,
                hintText: "Search for an Area,Address...",
                prefixIcon: Icon(CupertinoIcons.search),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: CommonButtonWidget.button(
              buttonColor: redCA0,
              onTap: () {},
              text: "DONE",
            ),
          ),
        ],
      ),
    );
  }
}
