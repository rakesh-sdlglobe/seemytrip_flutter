import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/Utills/common_button_widget.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';

class SelectRoomAndGustScreen extends StatelessWidget {
  SelectRoomAndGustScreen({Key? key}) : super(key: key);

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
          text: "Select Room & Guests",
          color: white,
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: white,
                boxShadow: [
                  BoxShadow(
                    color: grey515.withOpacity(0.25),
                    blurRadius: 6,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                      color: yellowF7C.withOpacity(0.3),
                    ),
                    child: Center(
                      child: CommonTextWidget.PoppinsMedium(
                        text: "Maximum 4 Guests are allowed in this room",
                        color: yellowCE8,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextWidget.PoppinsMedium(
                          text: "ROOM 1",
                          color: grey888,
                          fontSize: 12,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: CommonTextWidget.PoppinsMedium(
                            text: "Adults",
                            color: black2E2,
                            fontSize: 16,
                          ),
                          subtitle: CommonTextWidget.PoppinsMedium(
                            text: "Above 12 Years",
                            color: grey888,
                            fontSize: 12,
                          ),
                          trailing: Container(
                            height: 37,
                            width: 98,
                            decoration: BoxDecoration(
                              color: white,
                              border: Border.all(color: greyB3B, width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.remove, color: grey717, size: 10),
                                  CommonTextWidget.PoppinsMedium(
                                    text: "01",
                                    color: black2E2,
                                    fontSize: 18,
                                  ),
                                  Icon(Icons.add, color: grey717, size: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: CommonTextWidget.PoppinsMedium(
                            text: "Children",
                            color: black2E2,
                            fontSize: 16,
                          ),
                          subtitle: CommonTextWidget.PoppinsMedium(
                            text: "Below 12 Years",
                            color: grey888,
                            fontSize: 12,
                          ),
                          trailing: Container(
                            height: 37,
                            width: 98,
                            decoration: BoxDecoration(
                              color: white,
                              border: Border.all(color: greyB3B, width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.remove, color: grey717, size: 10),
                                  CommonTextWidget.PoppinsMedium(
                                    text: "00",
                                    color: black2E2,
                                    fontSize: 18,
                                  ),
                                  Icon(Icons.add, color: grey717, size: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            CommonButtonWidget.button(
              onTap: () {},
              buttonColor: redCA0,
              text: "APPLY",
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
