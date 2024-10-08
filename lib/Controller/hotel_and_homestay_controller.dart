import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HotelAndHomeStayTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'UPTO 5 ROOMS'),
    Tab(text: '5+ROOMS'),
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
