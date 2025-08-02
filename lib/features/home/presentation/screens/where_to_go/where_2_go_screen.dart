import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';
import 'package:seemytrip/features/home/presentation/screens/where_to_go/where2go_search_screen.dart';
import 'package:seemytrip/main.dart';

class Where2GoScreen extends StatelessWidget {
  Where2GoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Get.width,
                color: redCA0,
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: 10, left: 24, right: 24, top: 60),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => Where2GoSearchScreen());
                    },
                    child: Container(
                      height: 44,
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.search, color: grey717),
                            SizedBox(width: 15),
                            CommonTextWidget.PoppinsRegular(
                              text: "Search City, Things to do...",
                              color: grey717,
                              fontSize: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 100,
                width: Get.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(where2GoImage),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(selectedRightArrow, color: white),
                    SizedBox(width: 5),
                    CommonTextWidget.PoppinsSemiBold(
                      text: "Where2Go",
                      color: white,
                      fontSize: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 24),
                physics: NeverScrollableScrollPhysics(),
                itemCount: Lists.where2GoList1.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: redCA0, width: 1),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 6, bottom: 6, left: 10, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(Lists.where2GoList1[index]["image"],
                              height: 35, width: 35),
                          CommonTextWidget.PoppinsRegular(
                            text: Lists.where2GoList1[index]["text"],
                            color: redCA0,
                            fontSize: 16,
                          ),
                          Icon(Icons.arrow_forward, color: redCA0, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Divider(color: greyE9E, thickness: 1),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonTextWidget.PoppinsSemiBold(
                  text: "Discover by interest",
                  color: black2E2,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 110,
                width: Get.width,
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView.builder(
                    itemCount: Lists.where2GoList2.length,
                    padding: EdgeInsets.only(left: 24),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(right: 32),
                      child: InkWell(
                        onTap: Lists.where2GoList2[index]["onTap"],
                        child: Column(
                          children: [
                            Image.asset(Lists.where2GoList2[index]["image"],
                                height: 75, width: 75),
                            SizedBox(height: 6),
                            CommonTextWidget.PoppinsRegular(
                              text: Lists.where2GoList2[index]["text"],
                              color: black2E2,
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(color: greyE9E, thickness: 1),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonTextWidget.PoppinsSemiBold(
                      text: "Searched for Mount Abu",
                      color: black2E2,
                      fontSize: 16,
                    ),
                    Row(
                      children: [
                        CommonTextWidget.PoppinsRegular(
                          text: "View All",
                          color: redCA0,
                          fontSize: 14,
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_ios, color: redCA0, size: 18),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 145,
                width: Get.width,
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView.builder(
                    itemCount: Lists.where2GoList3.length,
                    padding: EdgeInsets.only(left: 24, right: 9),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Container(
                        height: 145,
                        width: 120,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image:
                                AssetImage(Lists.where2GoList3[index]["image"]),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 7, bottom: 7),
                            child: CommonTextWidget.PoppinsSemiBold(
                              text: Lists.where2GoList3[index]["text"],
                              color: white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(color: greyE9E, thickness: 1),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonTextWidget.PoppinsSemiBold(
                  text: "Latest collections for you",
                  color: black2E2,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 175,
                width: Get.width,
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView.builder(
                    itemCount: Lists.where2GoList4.length,
                    padding: EdgeInsets.only(left: 24, right: 9),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 110,
                            width: 135,
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: AssetImage(
                                    Lists.where2GoList4[index]["image"]),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(height: 2),
                          CommonTextWidget.PoppinsRegular(
                            text: Lists.where2GoList4[index]["text"],
                            color: black2E2,
                            fontSize: 14,
                          ),
                          CommonTextWidget.PoppinsRegular(
                            text: "5 Places",
                            color: grey818,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Divider(color: greyE9E, thickness: 1),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
