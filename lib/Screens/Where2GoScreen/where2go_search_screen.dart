import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Screens/Utills/common_textfeild_widget.dart';
import 'package:seemytrip/Screens/Utills/lists_widget.dart';
import 'package:seemytrip/main.dart';

class Where2GoSearchScreen extends StatelessWidget {
  Where2GoSearchScreen({Key? key}) : super(key: key);
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        children: [
          Container(
            width: Get.width,
            color: redCA0,
            child: Padding(
              padding:
                  EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back, color: white, size: 20),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: CommonTextFieldWidget.TextFormField2(
                      prefixIcon: Icon(CupertinoIcons.search, color: grey717),
                      keyboardType: TextInputType.text,
                      controller: searchController,
                      hintText: "Search City, Things to do",
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: Get.width,
            color: greyEEE,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: CommonTextWidget.PoppinsSemiBold(
                text: "Trending Search",
                color: black2E2,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: Lists.whereGo2SearchList.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          SvgPicture.asset(trendArrow),
                          SizedBox(width: 12),
                          CommonTextWidget.PoppinsRegular(
                            text: Lists.whereGo2SearchList[index],
                            color: grey717,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Divider(thickness: 1, color: greyDED),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
