import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SortAndFilterTabController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Sort by'),
    Tab(text: 'Filters'),
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

class FilterController extends GetxController{
  // ignore: prefer_typing_uninitialized_variables
  var selectedIndex;

  onIndexChange(index){
    selectedIndex=index;
    update();
  }

  // ignore: prefer_typing_uninitialized_variables
  var selectedIndex1;

  onIndexChange1(index){
    selectedIndex1=index;
    update();
  }

  // ignore: prefer_typing_uninitialized_variables
  var selectedIndex2;

  onIndexChange2(index){
    selectedIndex2=index;
    update();
  }

  // ignore: prefer_typing_uninitialized_variables
  var selectedIndex3;

  onIndexChange3(index){
    selectedIndex3=index;
    update();
  }

  var select = false.obs;
  var isSelected = false.obs;
}