import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_textfeild_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';
import 'package:makeyourtripapp/main.dart';

class HomeSearchSCreen extends StatelessWidget {
  HomeSearchSCreen({Key? key}) : super(key: key);
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
                      hintText: "Try ‘Delhi Actinites’",
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: Get.width,
                      color: greyEEE,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        child: CommonTextWidget.PoppinsSemiBold(
                          text: "TOP SERVICES",
                          color: black2E2,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                      width: Get.width,
                      child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: ListView.builder(
                          itemCount: Lists.homeSearchList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(
                              top: 13, bottom: 13, left: 24, right: 12),
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: white,
                                boxShadow: [
                                  BoxShadow(
                                    color: grey323.withOpacity(0.25),
                                    blurRadius: 6,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: CommonTextWidget.PoppinsMedium(
                                    text: Lists.homeSearchList[index],
                                    color: grey5F5,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: Get.width,
                      color: greyEEE,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        child: CommonTextWidget.PoppinsSemiBold(
                          text: "RECENT SEARCHES",
                          color: black2E2,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (context, index) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: -5,
                        leading: SvgPicture.asset(recentSearchesIcon),
                        title: CommonTextWidget.PoppinsRegular(
                          text: "New Delhi to Mumbai flights for 24th Sep",
                          color: grey717,
                          fontSize: 14,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, color: redCA0),
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      width: Get.width,
                      color: greyEEE,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        child: CommonTextWidget.PoppinsSemiBold(
                          text: "WHAT’S INDIA SEARCHING FOR",
                          color: black2E2,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 6,
                      itemBuilder: (context, index) => Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            horizontalTitleGap: -5,
                            leading:
                                SvgPicture.asset(trendArrow, color: grey969),
                            title: CommonTextWidget.PoppinsRegular(
                              text: "Cheapest flight from Delhi to Dharmsala",
                              color: grey717,
                              fontSize: 14,
                            ),
                            trailing:
                                Icon(Icons.arrow_forward_ios, color: redCA0),
                          ),
                          SizedBox(height: 12),
                          index == 5
                              ? SizedBox.shrink()
                              : Divider(thickness: 1, color: greyDED),
                          SizedBox(height: 12),
                        ],
                      ),
                    ),
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
