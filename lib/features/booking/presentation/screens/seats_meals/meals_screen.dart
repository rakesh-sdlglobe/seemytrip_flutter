import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../core/widgets/lists_widget.dart';
import '../../../../../main.dart';
import '../../../../../shared/constants/images.dart';

class MealsScreen extends StatelessWidget {
  MealsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Get.width,
              color: AppColors.redF9E.withOpacity(0.75),
              child: Padding(
                padding: EdgeInsets.only(top: 38, left: 24, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextWidget.PoppinsRegular(
                      text: 'Pre book your meals',
                      color: AppColors.black2E2,
                      fontSize: 18,
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 40,
                      width: 122,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppColors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Image.asset(spicejet),
                            SizedBox(width: 10),
                            CommonTextWidget.PoppinsSemiBold(
                              text: 'DEL - BOM',
                              color: AppColors.black2E2,
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Container(
                          height: 35,
                          width: 75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 22, vertical: 7),
                            child: CommonTextWidget.PoppinsRegular(
                              text: 'Veg',
                              color: AppColors.black2E2,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          height: 35,
                          width: 105,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 22, vertical: 7),
                            child: CommonTextWidget.PoppinsRegular(
                              text: 'Non Veg',
                              color: AppColors.black2E2,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Image.asset(diet, height: 35, width: 35),
                  SizedBox(width: 15),
                  Expanded(
                    child: CommonTextWidget.PoppinsRegular(
                      text: 'Pre-book Your Meals NOW! Select From '
                          'These Options.',
                      color: AppColors.redCA0,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonTextWidget.PoppinsSemiBold(
                text: 'In-flight Meals',
                color: AppColors.black2E2,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonTextWidget.PoppinsRegular(
                text: 'Prebook your Inflight meal',
                color: AppColors.black2E2,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 25),
            ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 24),
              physics: NeverScrollableScrollPhysics(),
              itemCount: Lists.mealsList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Image.asset(Lists.mealsList[index]['image'],
                        height: 52, width: 52),
                    title: CommonTextWidget.PoppinsMedium(
                      text: Lists.mealsList[index]['text1'],
                      color: AppColors.grey717,
                      fontSize: 12,
                    ),
                    subtitle: CommonTextWidget.PoppinsMedium(
                      text: Lists.mealsList[index]['text2'],
                      color: AppColors.black2E2,
                      fontSize: 14,
                    ),
                    trailing: Container(
                      height: 30,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppColors.white,
                        border: Border.all(color: AppColors.greyDED, width: 1),
                      ),
                      child: Center(
                        child: CommonTextWidget.PoppinsMedium(
                          text: Lists.mealsList[index]['text2'],
                          color: AppColors.black2E2,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Divider(color: AppColors.greyE8E, thickness: 1),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
}
