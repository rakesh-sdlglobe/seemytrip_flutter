import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/features/shared/presentation/controllers/sort_and_filter_controller.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';
import 'package:seemytrip/main.dart';

class FilterScreen extends StatelessWidget {
  FilterScreen({Key? key}) : super(key: key);
  final FilterController filterController = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonTextWidget.PoppinsLight(
                text: "Stops From New Delhi",
                color: grey717,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 135,
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: GetBuilder<FilterController>(
                  init: FilterController(),
                  builder: (controller) => ListView.builder(
                    itemCount: Lists.filterList1.length,
                    padding: EdgeInsets.only(
                        left: 24, right: 24, top: 15, bottom: 25),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: InkWell(
                        onTap: () {
                          controller.onIndexChange(index);
                          filterController.isSelected.value = true;
                        },
                        child: Container(
                          height: 135,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: controller.selectedIndex == index
                                ? redCA0
                                : white,
                            boxShadow: [
                              BoxShadow(
                                color: grey7B7.withOpacity(0.25),
                                offset: Offset(0, 1),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 24, right: 24),
                            child: Column(
                              children: [
                                SizedBox(height: 5),
                                CommonTextWidget.PoppinsMedium(
                                  text: Lists.filterList1[index]["text1"],
                                  color: controller.selectedIndex == index
                                      ? white
                                      : black2E2,
                                  fontSize: 25,
                                ),
                                CommonTextWidget.PoppinsRegular(
                                  text: Lists.filterList1[index]["text2"],
                                  color: controller.selectedIndex == index
                                      ? white
                                      : black2E2,
                                  fontSize: 12,
                                ),
                                CommonTextWidget.PoppinsRegular(
                                  text: Lists.filterList1[index]["text3"],
                                  color: controller.selectedIndex == index
                                      ? white
                                      : grey717,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Divider(thickness: 1, color: greyEEE),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonTextWidget.PoppinsLight(
                text: "Departure From New Delhi",
                color: grey717,
                fontSize: 18,
              ),
            ),
            GetBuilder<FilterController>(
              init: FilterController(),
              builder: (controller) => GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio:
                      MediaQuery.of(context).size.aspectRatio * 2 / 0.3,
                ),
                shrinkWrap: true,
                primary: false,
                physics: NeverScrollableScrollPhysics(),
                padding:
                    EdgeInsets.only(left: 24, right: 24, top: 15, bottom: 20),
                itemCount: Lists.filterList2.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      controller.onIndexChange1(index);
                      filterController.isSelected.value = true;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color:
                            controller.selectedIndex1 == index ? redCA0 : white,
                        boxShadow: [
                          BoxShadow(
                            color: grey7B7.withOpacity(0.25),
                            offset: Offset(0, 1),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Center(
                        child: CommonTextWidget.PoppinsRegular(
                          text: Lists.filterList2[index],
                          color: controller.selectedIndex1 == index
                              ? white
                              : grey717,
                          fontSize: 12,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(thickness: 1, color: greyEEE),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonTextWidget.PoppinsLight(
                text: "Arrival at Mumbai",
                color: grey717,
                fontSize: 18,
              ),
            ),
            GetBuilder<FilterController>(
              init: FilterController(),
              builder: (controller) => GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio:
                      MediaQuery.of(context).size.aspectRatio * 2 / 0.3,
                ),
                shrinkWrap: true,
                primary: false,
                physics: NeverScrollableScrollPhysics(),
                padding:
                    EdgeInsets.only(left: 24, right: 24, top: 15, bottom: 20),
                itemCount: Lists.filterList2.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      controller.onIndexChange2(index);
                      filterController.isSelected.value = true;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color:
                            controller.selectedIndex2 == index ? redCA0 : white,
                        boxShadow: [
                          BoxShadow(
                            color: grey7B7.withOpacity(0.25),
                            offset: Offset(0, 1),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Center(
                        child: CommonTextWidget.PoppinsRegular(
                          text: Lists.filterList2[index],
                          color: controller.selectedIndex2 == index
                              ? white
                              : grey717,
                          fontSize: 12,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(thickness: 1, color: greyEEE),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonTextWidget.PoppinsLight(
                text: "Airline",
                color: grey717,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 15),
            GetBuilder<FilterController>(
              init: FilterController(),
              builder: (controller) => ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount: Lists.filterList3.length,
                itemBuilder: (context, index) => Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              Lists.filterList3[index]["image"],
                              height: 30,
                              width: 30,
                            ),
                            SizedBox(width: 15),
                            CommonTextWidget.PoppinsRegular(
                              text: Lists.filterList3[index]["text1"],
                              color: black2E2,
                              fontSize: 14,
                            ),
                          ],
                        ),
                        title: CommonTextWidget.PoppinsRegular(
                          text: Lists.filterList3[index]["text2"],
                          color: grey717,
                          fontSize: 14,
                        ),
                        trailing: InkWell(
                          onTap: () {
                            controller.onIndexChange3(index);
                            filterController.isSelected.value = true;
                          },
                          child: Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: controller.selectedIndex3 == index
                                  ? redCA0
                                  : white,
                              border: Border.all(
                                color: controller.selectedIndex3 == index
                                    ? redCA0
                                    : grey717,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                color: white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(thickness: 1, color: greyEEE),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonTextWidget.PoppinsLight(
                text: "Other filter",
                color: grey717,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 22),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonTextWidget.PoppinsRegular(
                    text: "Refundable Fares",
                    color: black2E2,
                    fontSize: 14,
                  ),
                  Obx(
                    () => InkWell(
                      onTap: () {
                        filterController.select.value =
                            !filterController.select.value;
                        filterController.isSelected.value = true;
                      },
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color:
                              filterController.select.isTrue ? redCA0 : white,
                          border: Border.all(
                            color: filterController.select.isTrue
                                ? redCA0
                                : grey717,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.check,
                            color: white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 18),
            Divider(thickness: 1, color: greyEEE),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
