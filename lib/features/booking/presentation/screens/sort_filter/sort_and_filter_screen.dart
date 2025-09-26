import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_button_widget.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../shared/constants/images.dart';
import '../../../../shared/presentation/controllers/sort_and_filter_controller.dart';
import 'filter_screen.dart';
import 'sort_by_screen.dart';

class SortAndFilterScreen extends StatelessWidget {
  SortAndFilterScreen({Key? key}) : super(key: key);
  final SortAndFilterTabController sortAndFilterTabController =
      Get.put(SortAndFilterTabController());
  final FilterController filterController = Get.put(FilterController());

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 155,
                width: Get.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(sortAndFilterTopImage),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.close, color: AppColors.white, size: 20),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonTextWidget.PoppinsSemiBold(
                            text: 'Sort & Filters',
                            color: AppColors.white,
                            fontSize: 18,
                          ),
                          CommonTextWidget.PoppinsMedium(
                            text: '85 out 82 result',
                            color: AppColors.white,
                            fontSize: 12,
                          ),
                        ],
                      ),
                      Obx(() => filterController.isSelected.value == true
                          ? CommonTextWidget.PoppinsMedium(
                              text: 'Clear',
                              color: AppColors.white,
                              fontSize: 12,
                            )
                          : SizedBox.shrink()),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: TabBarView(
                controller: sortAndFilterTabController.controller,
                children: [
                  SortByScreen(),
                  FilterScreen(),
                ],
              )),
              SizedBox(height: 110),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 130, left: 24, right: 24),
            child: Container(
              height: 45,
              width: Get.width,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey757.withOpacity(0.25),
                    blurRadius: 6,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                padding: EdgeInsets.only(left: 50, bottom: 7, right: 50),
                tabs: sortAndFilterTabController.myTabs,
                unselectedLabelColor: AppColors.grey5F5,
                labelStyle:
                    TextStyle(fontFamily: 'PoppinsSemiBold', fontSize: 14),
                unselectedLabelStyle:
                    TextStyle(fontFamily: 'PoppinsMedium', fontSize: 14),
                labelColor: AppColors.redCA0,
                controller: sortAndFilterTabController.controller,
                indicatorColor: AppColors.redCA0,
                indicatorWeight: 2.5,
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: CommonButtonWidget.button(
              text: 'Apply',
              onTap: () {},
              buttonColor: AppColors.redCA0,
            ),
          ),
        ],
      ),
    );
}
