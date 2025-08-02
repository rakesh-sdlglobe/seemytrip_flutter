import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeatsMealsAddOneTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'SEATS'),
    Tab(text: 'MEALS'),
    Tab(text: 'ADD ONS'),
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
