import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/features/booking/presentation/screens/seats_meals/seats_meals_addone_tab_screen.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/main.dart';

class ReviewDetailScreen extends StatelessWidget {
  ReviewDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 350),
      child: Container(
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 25, bottom: 60, left: 24, right: 24),
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextWidget.PoppinsSemiBold(
                    text: "Review Details",
                    color: black2E2,
                    fontSize: 18,
                  ),
                  SizedBox(height: 10),
                  CommonTextWidget.PoppinsRegular(
                    text: "Please ensure that the spelling of your name "
                        "and other details match with your travel "
                        "document govt. ID, as there cannot be "
                        "changed later errors might lead to cancel "
                        "penalties.",
                    color: grey717,
                    fontSize: 14,
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 4,
                    width: 30,
                    color: redCA0,
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: greyE2E, width: 1),
                      color: white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsMedium(
                            text: "ADULT 1",
                            color: black2E2,
                            fontSize: 14,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonTextWidget.PoppinsRegular(
                                    text: "Name :",
                                    color: grey717,
                                    fontSize: 14,
                                  ),
                                  CommonTextWidget.PoppinsRegular(
                                    text: "Last Name :",
                                    color: grey717,
                                    fontSize: 14,
                                  ),
                                  CommonTextWidget.PoppinsRegular(
                                    text: "Gender :",
                                    color: grey717,
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonTextWidget.PoppinsMedium(
                                    text: "John",
                                    color: black2E2,
                                    fontSize: 14,
                                  ),
                                  CommonTextWidget.PoppinsMedium(
                                    text: "Deo",
                                    color: black2E2,
                                    fontSize: 14,
                                  ),
                                  CommonTextWidget.PoppinsMedium(
                                    text: "Male",
                                    color: black2E2,
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                              SizedBox.shrink(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: CommonTextWidget.PoppinsMedium(
                          text: "EDIT",
                          color: redCA0,
                          fontSize: 16,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => SeatsMealsAddOneTabScreen());
                        },
                        child: CommonTextWidget.PoppinsMedium(
                          text: "CONFIRM",
                          color: redCA0,
                          fontSize: 16,
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
