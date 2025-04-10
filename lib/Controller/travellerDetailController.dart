import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TravellerDetailController extends GetxController {
  // Observable list to store traveller details
  var travellers = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  // Observable properties for selected items
  var selectedItems = <String>[].obs;

  // Base URL for API
  final String baseUrl = 'http://192.168.1.110:3002';

  // Update the selected items
  void updateSelectedItems(List<String> items) {
    selectedItems.value = items;
  }

  // Function to save traveller details
  Future<void> saveTravellerDetails({
    required String name,
    required String age,
    required String gender,
    required String nationality,
    required List<String> berthPreferences,
  }) async {
    try {
      isLoading.value = true;

      // Get the access token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null) {
        Get.snackbar(
          "Error",
          "Please login to add traveler",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Prepare the data
      final Map<String, dynamic> travellerData = {
        "passengerName": name,
        "passengerAge": age,
        "passengerGender": gender,
        "passengerBerthChoice": berthPreferences.join(', '),
        "country": "",
        "passengerBedrollChoice": "",
        "passengerNationality": "IN",
      };

    // Print the travellerData
    print('Traveller Data: $travellerData');
    Get.snackbar("Success", "Traveller Data: $travellerData");
      

      // Make API call
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/addTraveler'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(travellerData),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Add to local list
        travellers.add(travellerData);

        // Show success message
        Get.snackbar(
          "Success",
          "Traveller added successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        // Clear form or navigate back
        Get.back();
      } else {
        // Parse error message from response if available
        Map<String, dynamic> errorResponse = json.decode(response.body);
        String errorMessage = errorResponse['message'] ?? 'Failed to add traveler';
        
        Get.snackbar(
          "Error",
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (error) {
      print('Error adding traveler: $error');
      Get.snackbar(
        "Error",
        "An error occurred while adding traveler",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Function to fetch all travelers
  Future<void> fetchTravelers() async {
    try {
      isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null) {
        Get.snackbar("Error", "Please login to view travelers");
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/users/getTravelers'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        travellers.value = List<Map<String, dynamic>>.from(data);
      } else {
        Get.snackbar("Error", "Failed to fetch travelers");
      }
    } catch (error) {
      print('Error fetching travelers: $error');
      Get.snackbar("Error", "An error occurred while fetching travelers");
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle selection state for a traveller
  void toggleSelection(int index) {
    travellers[index]['selected'] = !(travellers[index]['selected'] as bool);
    travellers.refresh(); // Notify observers of the change
  }

  @override
  void onInit() {
    super.onInit();
    fetchTravelers(); // Fetch travelers when controller is initialized
  }
}
