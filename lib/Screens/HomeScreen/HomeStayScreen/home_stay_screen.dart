import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/Utills/common_button_widget.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Screens/Utills/lists_widget.dart';
import 'package:seemytrip/main.dart';

class HomeStayScreen extends StatelessWidget {
  HomeStayScreen({Key? key}) : super(key: key);

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
          text: "Homestays",
          color: white,
          fontSize: 18,
        ),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                itemCount: Lists.homeStayList1.length,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24),
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InkWell(
                    onTap: Lists.homeStayList1[index]["onTap"],
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: grey9B9.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(width: 1, color: greyE2E),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                                Lists.homeStayList1[index]["image"]),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonTextWidget.PoppinsMedium(
                                  text: Lists.homeStayList1[index]["text1"],
                                  color: grey888,
                                  fontSize: 14,
                                ),
                                Row(
                                  children: [
                                    CommonTextWidget.PoppinsSemiBold(
                                      text: Lists.homeStayList1[index]["text2"],
                                      color: black2E2,
                                      fontSize: 18,
                                    ),
                                    CommonTextWidget.PoppinsMedium(
                                      text: Lists.homeStayList1[index]["text3"],
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
              ListView.builder(
                shrinkWrap: true,
                itemCount: Lists.homeStayList2.length,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24),
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: grey9B9.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: greyE2E),
                    ),
                    child: ListTile(
                      leading: SvgPicture.asset(user),
                      title: CommonTextWidget.PoppinsSemiBold(
                        text: Lists.homeStayList2[index]["text1"],
                        color: black2E2,
                        fontSize: 16,
                      ),
                      subtitle: CommonTextWidget.PoppinsRegular(
                        text: Lists.homeStayList2[index]["text2"],
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.remove, color: grey717, size: 10),
                              CommonTextWidget.PoppinsMedium(
                                text: Lists.homeStayList2[index]["text3"],
                                color: black2E2,
                                fontSize: 18,
                              ),
                              Icon(Icons.add, color: grey717, size: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonTextWidget.PoppinsMedium(
                  text: "Improve Your Search",
                  color: grey888,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Image.asset(homeStayList),
              ),
              SizedBox(height: 85),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonButtonWidget.button(
                  buttonColor: redCA0,
                  onTap: () {},
                  text: "SEARCH",
                ),
              ),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
