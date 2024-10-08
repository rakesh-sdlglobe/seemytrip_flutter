import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlightModifySearchController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'ONE WAY'),
    Tab(text: 'ROUNDTRIP'),
    Tab(text: 'MULTICITY'),
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
