import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TravellerDetailController extends GetxController {
  // Observable list to store traveller details
  var travellers = <Map<String, dynamic>>[].obs;

  // Observable properties for selected items
  var selectedItems = <String>[].obs;

  // Update the selected items
  void updateSelectedItems(List<String> items) {
    selectedItems.value = items;
  }

  // Function to save traveller details
  void saveTravellerDetails({
    required String name,
    required String age,
    required String gender,
    required String nationality,
    required List<String> berthPreferences,
  }) {
    // Add the traveller data to the list
    final travellerData = {
      "name": name,
      "age": age,
      "gender": gender,
      "nationality": nationality,
      "berthPreferences": berthPreferences,
    };

    travellers.add(travellerData);

    // Show success message
    Get.snackbar(
      "Success",
      "Traveller details saved successfully!",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Toggle selection state for a traveller
  void toggleSelection(int index) {
    travellers[index]['selected'] = !(travellers[index]['selected'] as bool);
    travellers.refresh(); // Notify observers of the change
  }
}
