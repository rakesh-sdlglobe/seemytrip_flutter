import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RefundPolicyTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'CANCELLATION'),
    Tab(text: 'DATE CHANGE'),
    Tab(text: 'BAGGAGE'),
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
