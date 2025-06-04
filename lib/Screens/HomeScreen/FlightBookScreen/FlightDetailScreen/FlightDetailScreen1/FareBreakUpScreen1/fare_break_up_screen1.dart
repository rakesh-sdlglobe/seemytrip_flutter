import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Screens/Utills/lists_widget.dart';

class FareBreakUpScreen1 extends StatelessWidget {
   FareBreakUpScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redF9E,
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
          text: "Fare Breakup",
          color: white,
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.only(top: 15,left: 24,right: 24,bottom: 30),
        child: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: white,
          ),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: Lists.fareBreakList.length,
                padding: EdgeInsets.only(top: 20),
                itemBuilder: (context, index) => Column(
                  children: [
                    ListTile(
                      title: CommonTextWidget.PoppinsMedium(
                        text: Lists.fareBreakList[index]["text1"],
                        color: black2E2,
                        fontSize: 12,
                      ),
                      subtitle: CommonTextWidget.PoppinsMedium(
                        text: Lists.fareBreakList[index]["text2"],
                        color: black2E2,
                        fontSize: 12,
                      ),
                      trailing: CommonTextWidget.PoppinsMedium(
                        text: Lists.fareBreakList[index]["text3"],
                        color: black2E2,
                        fontSize: 12,
                      ),
                      horizontalTitleGap: -3,
                    ),
                    index == 2
                        ? SizedBox.shrink()
                        : Divider(color: greyE8E, thickness: 1),
                  ],
                ),
              ),
              Spacer(),
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                  border: Border.all(color: greyE8E,width: 1),
                  color: white,
                ),
                child: Padding(
                  padding:  EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonTextWidget.PoppinsSemiBold(
                        text: "Total Amount",
                        color: black2E2,
                        fontSize: 12,
                      ),
                      CommonTextWidget.PoppinsSemiBold(
                        text: "₹ 8,623",
                        color: black2E2,
                        fontSize: 16,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
