import 'dart:async';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TrainFromSearchController extends GetxController {
  var isEditingFrom = false.obs;
  var fromController = TextEditingController();
  var stations = <String>[].obs;
  var filteredStations = <String>[].obs;
  var isLoading = true.obs;
  var hasError = false.obs;
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    fetchStations();
    fromController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    fromController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  Future<void> fetchStations() async {
    final dio = Dio();
    final url = 'http://192.168.1.110:3002/api/trains/getStation';

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        stations.value = List<String>.from(response.data['stations'] ?? []);
        filteredStations.value = stations;
        isLoading.value = false;
      } else {
        isLoading.value = false;
        hasError.value = true;
      }
    } catch (e) {
      isLoading.value = false;
      hasError.value = true;
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 300), () {
      _filterStations(fromController.text);
    });
  }

  void _filterStations(String query) {
    query = query.toLowerCase();
    filteredStations.value = stations.where((station) {
      return station.toLowerCase().contains(query);
    }).toList();
  }

  void selectStation(String stationName) {
    Get.back(result: {
      'stationName': stationName,
    });
  }
}
