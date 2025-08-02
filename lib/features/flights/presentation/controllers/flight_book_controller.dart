import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';

class FlightBookController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // ignore: prefer_typing_uninitialized_variables
  var selectedIndex;

  onIndexChange(index) {
    selectedIndex = index;
    update();
  }

  final List<Tab> myTabs = <Tab>[
    Tab(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonTextWidget.PoppinsMedium(
            text: "Cheapest",
            fontSize: 10,
            textAlign: TextAlign.center,
          ),
          CommonTextWidget.PoppinsMedium(
            text: "₹ 5,956 | 2 h 15m",
            fontSize: 9,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
    Tab(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonTextWidget.PoppinsMedium(
            text: "Fastest",
            fontSize: 10,
            textAlign: TextAlign.center,
          ),
          CommonTextWidget.PoppinsMedium(
            text: "₹ 11,956 | 1 h 15m",
            fontSize: 9,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
    Tab(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonTextWidget.PoppinsMedium(
            text: "You May Prefer",
            fontSize: 10,
            textAlign: TextAlign.center,
          ),
          CommonTextWidget.PoppinsMedium(
            text: "₹ 8,956 | 2 h",
            fontSize: 9,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  ];

  late TabController controller;

  @override
  void onInit() {
    super.onInit();
    controller = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  var click = false.obs;
}
