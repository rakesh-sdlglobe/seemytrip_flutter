import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/common_textfeild_widget.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../core/widgets/lists_widget.dart';
import '../../../../../main.dart';
import '../../../../../shared/constants/images.dart';

class Where2GoSearchScreen extends StatelessWidget {
  Where2GoSearchScreen({Key? key}) : super(key: key);
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Container(
            width: Get.width,
            color: AppColors.redCA0,
            child: Padding(
              padding:
                  EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back, color: AppColors.white, size: 20),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: CommonTextFieldWidget(
                      prefixIcon: Icon(CupertinoIcons.search, color: AppColors.grey717),
                      keyboardType: TextInputType.text,
                      controller: searchController,
                      hintText: 'Search City, Things to do',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: Get.width,
            color: AppColors.greyEEE,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: CommonTextWidget.PoppinsSemiBold(
                text: 'Trending Search',
                color: AppColors.black2E2,
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
                            color: AppColors.grey717,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Divider(thickness: 1, color: AppColors.greyDED),
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
