import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTripTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'UPCOMING'),
    Tab(text: 'CANCELLED'),
    Tab(text: 'COMPLETED'),
    Tab(text: 'UNSUCCESSFUL'),
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
