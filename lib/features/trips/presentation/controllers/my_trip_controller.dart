import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTripTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'All'),
    Tab(text: 'upcoming'.tr),
    Tab(text: 'cancelled'.tr),
    Tab(text: 'completed'.tr),
    Tab(text: 'unsuccessful'.tr),
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
}
