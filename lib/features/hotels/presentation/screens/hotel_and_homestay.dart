import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/common_button_widget.dart';
import '../../../../core/widgets/common_text_widget.dart';
import '../../../../core/widgets/lists_widget.dart';
import '../../../../core/utils/colors.dart';

class HotelAndHomeStay extends StatelessWidget {
  HotelAndHomeStay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.close, color: white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "Hotels & Homestays",
          color: white,
          fontSize: 18,
        ),
      ),
      backgroundColor: white,
      body: Column(
        children: [
          SizedBox(height: 15),
          ListView.builder(
            shrinkWrap: true,
            itemCount: Lists.upTo5RoomsList.length,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24),
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: InkWell(
                onTap: Lists.upTo5RoomsList[index]["onTap"],
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: grey9B9.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 1, color: greyE2E),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                    child: Row(
                      children: [
                        SvgPicture.asset(Lists.upTo5RoomsList[index]["image"]),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonTextWidget.PoppinsMedium(
                              text: Lists.upTo5RoomsList[index]["text1"],
                              color: grey888,
                              fontSize: 14,
                            ),
                            Row(
                              children: [
                                CommonTextWidget.PoppinsSemiBold(
                                  text: Lists.upTo5RoomsList[index]["text2"],
                                  color: black2E2,
                                  fontSize: 18,
                                ),
                                CommonTextWidget.PoppinsMedium(
                                  text: Lists.upTo5RoomsList[index]["text3"],
                                  color: grey888,
                                  fontSize: 12,
                                ),
                              ],
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
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: CommonButtonWidget.button(
              buttonColor: redCA0,
              onTap: () {},
              text: "SEARCH HOTELS",
            ),
          ),
          SizedBox(height: 60),
        ],
      ),
    );
}
