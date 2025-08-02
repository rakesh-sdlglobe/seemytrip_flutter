import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/features/shared/presentation/controllers/sort_and_filter_controller.dart';
import 'package:seemytrip/features/booking/presentation/screens/sort_filter/filter_screen.dart';
import 'package:seemytrip/features/booking/presentation/screens/sort_filter/sort_by_screen.dart';
import 'package:seemytrip/core/widgets/common_button_widget.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';

class SortAndFilterScreen extends StatelessWidget {
  SortAndFilterScreen({Key? key}) : super(key: key);
  final SortAndFilterTabController sortAndFilterTabController =
      Get.put(SortAndFilterTabController());
  final FilterController filterController = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
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
                        child: Icon(Icons.close, color: white, size: 20),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonTextWidget.PoppinsSemiBold(
                            text: "Sort & Filters",
                            color: white,
                            fontSize: 18,
                          ),
                          CommonTextWidget.PoppinsMedium(
                            text: "85 out 82 result",
                            color: white,
                            fontSize: 12,
                          ),
                        ],
                      ),
                      Obx(() => filterController.isSelected.value == true
                          ? CommonTextWidget.PoppinsMedium(
                              text: "Clear",
                              color: white,
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
                color: white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: grey757.withOpacity(0.25),
                    blurRadius: 6,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                padding: EdgeInsets.only(left: 50, bottom: 7, right: 50),
                tabs: sortAndFilterTabController.myTabs,
                unselectedLabelColor: grey5F5,
                labelStyle:
                    TextStyle(fontFamily: "PoppinsSemiBold", fontSize: 14),
                unselectedLabelStyle:
                    TextStyle(fontFamily: "PoppinsMedium", fontSize: 14),
                labelColor: redCA0,
                controller: sortAndFilterTabController.controller,
                indicatorColor: redCA0,
                indicatorWeight: 2.5,
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: CommonButtonWidget.button(
              text: "Apply",
              onTap: () {},
              buttonColor: redCA0,
            ),
          ),
        ],
      ),
    );
  }
}
