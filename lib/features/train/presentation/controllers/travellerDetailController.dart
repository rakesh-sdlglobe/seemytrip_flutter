import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TravellerDetailController extends GetxController {
  final travellers = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final String baseUrl = 'https://tripadmin.seemytrip.com';

  final Map<String, String> _berthAbbreviations = {
    "Lower Berth": "LB",
    "Middle Berth": "MB",
    "Upper Berth": "UB",
    "Side Lower Berth": "SL",
    "Side Upper Berth": "SU",
    "No Preference": "NP",
  };

  @override
  void onInit() {
    super.onInit();
    fetchTravelers();
  }

  Future<void> saveTravellerDetails({
    required String name,
    String? age,
    String? gender,
    String? nationality,
    String? berthPreference,
  }) async {
    try {
      isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null) {
        Get.snackbar(
          "Error",
          "Please login to add traveler",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      if (name.trim().isEmpty) {
        Get.snackbar(
          "Error",
          "Traveler name is required",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      String berthChoiceCode = _berthAbbreviations[berthPreference ?? ''] ?? '';

      final Map<String, dynamic> travellerData = {
        "passengerName": name.trim(),
        "passengerAge": age?.trim() ?? '',
        "passengerGender": (gender == "Male" ? "M" : (gender == "Female" ? "F" : "O")),
        "passengerBerthChoice": berthChoiceCode,
        "country": 'IN',
        "passengerBedrollChoice": "",
        "passengerNationality": 'IN',
      };

      final response = await http.post(
        Uri.parse('$baseUrl/api/users/addTraveler'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(travellerData),
      ).timeout(
        Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Connection timed out. Please try again.');
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final responseData = json.decode(response.body);
          travellers.add({
            ...travellerData,
          });
          Get.back();
          Get.snackbar(
            "Success",
            "Traveller added successfully!",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        } catch (e) {
          travellers.add(travellerData);
          Get.back();
          Get.snackbar(
            "Success",
            "Traveller added (response format unclear).",
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        try {
          final errorResponse = json.decode(response.body);
          throw Exception(errorResponse['message'] ?? 'Failed to add traveler (Code: ${response.statusCode})');
        } catch (e) {
          throw Exception('Failed to add traveler (Code: ${response.statusCode})');
        }
      }
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } on FormatException {
      throw Exception('Invalid response format from server');
    } on http.ClientException {
      throw Exception('Network error. Please check your connection.');
    } catch (error) {
      Get.snackbar(
        "Error",
        error.toString().replaceFirst('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTravelers() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null) {
        isLoading.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/users/getTravelers'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        travellers.value = List<Map<String, dynamic>>.from(data.map((item) => item is Map<String, dynamic> ? item : {}));
      } else {
        Get.snackbar("Error", "Failed to fetch travelers (Code: ${response.statusCode})");
      }
    } catch (error) {
      Get.snackbar("Error", "An error occurred while fetching travelers");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSelection(int index) {
    if (travellers[index].containsKey('selected') && travellers[index]['selected'] is bool) {
      travellers[index]['selected'] = !travellers[index]['selected'];
    } else {
      travellers[index]['selected'] = true;
    }
    travellers.refresh();
  }
}
