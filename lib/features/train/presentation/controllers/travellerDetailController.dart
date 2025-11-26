// ignore_for_file: always_specify_types

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/config/app_config.dart';

class TravellerDetailController extends GetxController {
  final travellers = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  final Map<String, String> _berthAbbreviations = {
    'Lower Berth': 'LB',
    'Middle Berth': 'MB',
    'Upper Berth': 'UB',
    'Side Lower Berth': 'SL',
    'Side Upper Berth': 'SU',
    'No Preference': 'NP',
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
    String? mobile,
    String? nationality,
    String? berthPreference,
    String? foodPreference,
    String? email,
    String? address,
    // Hotel-specific fields
    String? title,
    String? firstName,
    String? middleName,
    String? lastName,
    String? mobilePrefix,
    String? roomId,
    bool? leadPax,
    String? paxType,
    String? dob,
  }) async {
    print('🎯 [CONTROLLER] saveTravellerDetails called!');
    print('🎯 [CONTROLLER] Received parameters:');
    print('   - Name: $name');
    print('   - Age: $age');
    print('   - Gender: $gender');
    print('   - Mobile: $mobile');
    print('   - Nationality: $nationality');
    print('   - Berth Preference: $berthPreference');
    print('   - Food Preference: $foodPreference');
    print('   - Email: $email');
    print('   - Address: $address');
    
    try {
      isLoading.value = true;
      print('🔄 [CONTROLLER] Loading state set to true');

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('accessToken');

      if (token == null) {
        Get.snackbar(
          'Error',
          'Please login to add traveler',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      if (name.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Traveler name is required',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }
      
      // Convert gender to single character format (Male -> M, Female -> F, Other -> O)
      String genderCode = 'M'; // Default to Male
      if (gender != null && gender.isNotEmpty) {
        if (gender.toLowerCase() == 'male' || gender == 'M') {
          genderCode = 'M';
        } else if (gender.toLowerCase() == 'female' || gender == 'F') {
          genderCode = 'F';
        } else if (gender.toLowerCase() == 'other' || gender == 'O') {
          genderCode = 'O';
        }
      }

      // Prepare request data with default values to ensure no nulls
      final Map<String, dynamic> requestData = {
        'passengerName': name.trim().isNotEmpty ? name.trim() : 'Unknown',  // Ensure not null
        'passengerMobileNumber': mobile?.trim().isNotEmpty == true ? mobile!.trim() : '0000000000',  // Default phone number
        'passengerBerthChoice': _berthAbbreviations[berthPreference ?? ''] ?? 'LB',  // Default to LB
        'passengerAge': age != null && age.isNotEmpty ? (int.tryParse(age) ?? 18) : 18,  // Default age 18
        'passengerGender': genderCode,  // Gender code (M, F, O)
        'passengerNationality': nationality?.trim().isNotEmpty == true ? nationality!.trim() : 'IN',  // Default to India
        'pasenger_dob': '2000-01-01',  // Default date of birth
        'passengerFoodChoice': foodPreference ?? 'Veg',  // Default to Veg
      };
      
      // Add contact_email and address if provided
      if (email != null && email.trim().isNotEmpty) {
        requestData['contact_email'] = email.trim();
      }
      if (address != null && address.trim().isNotEmpty) {
        requestData['address'] = address.trim();
      }
      
      // Add hotel-specific fields if provided
      if (title != null && title.trim().isNotEmpty) {
        requestData['title'] = title.trim();
      }
      if (firstName != null && firstName.trim().isNotEmpty) {
        requestData['firstName'] = firstName.trim();
      }
      if (middleName != null && middleName.trim().isNotEmpty) {
        requestData['middleName'] = middleName.trim();
      }
      if (lastName != null && lastName.trim().isNotEmpty) {
        requestData['lastName'] = lastName.trim();
      }
      if (mobilePrefix != null && mobilePrefix.trim().isNotEmpty) {
        requestData['mobilePrefix'] = mobilePrefix.trim();
        requestData['mobile_prefix'] = mobilePrefix.trim();
      }
      if (roomId != null && roomId.trim().isNotEmpty) {
        requestData['roomId'] = roomId.trim();
        requestData['room_id'] = roomId.trim();
      }
      if (leadPax != null) {
        requestData['leadPax'] = leadPax;
        requestData['lead_pax'] = leadPax;
      }
      if (paxType != null && paxType.trim().isNotEmpty) {
        requestData['paxType'] = paxType.trim();
        requestData['pax_type'] = paxType.trim();
      }
      if (dob != null && dob.trim().isNotEmpty) {
        requestData['dob'] = dob.trim();
        requestData['dateOfBirth'] = dob.trim();
      }
      
      // Ensure all required fields have values
      requestData['passengerName'] = requestData['passengerName'] ?? 'Unknown';
      requestData['passengerMobileNumber'] = requestData['passengerMobileNumber'] ?? '0000000000';
      requestData['passengerBerthChoice'] = requestData['passengerBerthChoice'] ?? 'LB';
      requestData['passengerAge'] = requestData['passengerAge'] ?? 18;
      requestData['passengerGender'] = requestData['passengerGender'] ?? 'M';
      requestData['passengerNationality'] = requestData['passengerNationality'] ?? 'IN';
      requestData['pasenger_dob'] = requestData['pasenger_dob'] ?? '2000-01-01';
      requestData['passengerFoodChoice'] = requestData['passengerFoodChoice'] ?? 'Veg';

      // Add debug logging
      final url = Uri.parse(AppConfig.addTraveler);
      
      print('🌐 [CONTROLLER] Attempting to call API at: $url');
      print('🌐 [CONTROLLER] Request headers: ${{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }}');
      print('🌐 [CONTROLLER] Request body: ${json.encode(requestData)}');
      debugPrint('Attempting to call API at: $url');
      debugPrint('Request headers: ${{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }}');
      debugPrint('Request body: ${json.encode(requestData)}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: json.encode(requestData),
      ).timeout(
        Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Connection timed out. Please try again.');
        },
      );
      
      print('📥 [CONTROLLER] Response received!');
      print('📥 [CONTROLLER] Response status: ${response.statusCode}');
      print('📥 [CONTROLLER] Response body: ${response.body}');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 201) {
        print('✅ [CONTROLLER] Success response from backend!');
        try {
          final responseData = json.decode(response.body);
          
          // Add the new traveler to the local list with the ID from the server
          final newTraveler = {
            'id': responseData['passengerId'] ?? DateTime.now().millisecondsSinceEpoch,
            'firstname': name.trim(),
            'mobile': mobile?.trim() ?? '',
            'passengerMobileNumber': mobile?.trim() ?? '',
            'dob': null,
            'passengerBerthChoice': _berthAbbreviations[berthPreference ?? ''] ?? '',
            'passengerFoodChoice': foodPreference ?? 'Veg',
            'passengerNationality': nationality?.trim() ?? 'IN',
            'contact_email': email?.trim() ?? '',
            'address': address?.trim() ?? '',
          };
          
          travellers.add(newTraveler);
          travellers.refresh(); // Notify listeners
          
          Get.back();
          Get.snackbar(
            'Success',
            responseData['message'] ?? 'Traveller added successfully!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          
          // Refresh the list from the server
          await fetchTravelers();
        } on FormatException {
          // Fallback in case of parsing error but successful response
          travellers.add({
            'id': DateTime.now().millisecondsSinceEpoch,
            'firstname': name.trim(),
            'mobile': mobile?.trim() ?? '',
            'passengerMobileNumber': mobile?.trim() ?? '',
            'dob': null,
            'passengerBerthChoice': _berthAbbreviations[berthPreference ?? ''] ?? '',
            'passengerFoodChoice': foodPreference ?? 'Veg',
            'passengerNationality': nationality?.trim() ?? 'IN',
            'contact_email': email?.trim() ?? '',
            'address': address?.trim() ?? '',
          });
          travellers.refresh(); // Notify listeners
          
          Get.back();
          Get.snackbar(
            'Success',
            'Traveller added (response format unclear).',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          
          // Refresh the list from the server
          await fetchTravelers();
        }
      } else {
        print('❌ [CONTROLLER] Error response from backend!');
        print('❌ [CONTROLLER] Error response status: ${response.statusCode}');
        print('❌ [CONTROLLER] Error response headers: ${response.headers}');
        print('❌ [CONTROLLER] Error response body: ${response.body}');
        debugPrint('Error response status: ${response.statusCode}');
        debugPrint('Error response headers: ${response.headers}');
        debugPrint('Error response body: ${response.body}');
        
        String errorMessage = 'Failed to add traveler (Code: ${response.statusCode})';
        
        try {
          final errorResponse = json.decode(response.body);
          errorMessage = errorResponse['message'] ?? errorResponse['error'] ?? errorMessage;
          debugPrint('Parsed error message: $errorMessage');
        } catch (e) {
          debugPrint('Error parsing error response: $e');
        }
        
        throw Exception(errorMessage);
      }
    } on TimeoutException catch (e) {
      final errorMsg = 'Connection timed out. Please try again.';
      debugPrint('TimeoutException: $e');
      Get.snackbar(
        'Error',
        errorMsg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FormatException catch (e) {
      final errorMsg = 'Invalid response format from server';
      debugPrint('FormatException: $e');
      debugPrint('Response body: ${e.source}');
      Get.snackbar(
        'Error',
        errorMsg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
      );
    } on http.ClientException catch (e) {
      final errorMsg = 'Network error. Please check your connection.';
      debugPrint('ClientException: $e');
      debugPrint('URI: ${e.uri}');
      debugPrint('Message: ${e.message}');
      Get.snackbar(
        'Error',
        errorMsg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error, stackTrace) {
      print('❌ [CONTROLLER] Unexpected error caught!');
      print('❌ [CONTROLLER] Error: $error');
      print('❌ [CONTROLLER] Stack trace: $stackTrace');
      print('❌ [CONTROLLER] Error type: ${error.runtimeType}');
      debugPrint('Unexpected error: $error');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('Error type: ${error.runtimeType}');
      
      // Log the response if available
      if (error is http.Response) {
        debugPrint('Error response status: ${error.statusCode}');
        debugPrint('Error response body: ${error.body}');
      }
      
      Get.snackbar(
        'Error',
        error.toString().replaceFirst('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      print('🏁 [CONTROLLER] saveTravellerDetails completed. Loading set to false.');
    }
  }

  Future<void> editTraveller({
    required String passengerId,
    required String name,
    String? age,
    String? gender,
    String? mobile,
    String? nationality,
    String? berthPreference,
    String? foodPreference,
    String? email,
    String? address,
  }) async {
    print('🎯 [CONTROLLER] editTraveller called!');
    print('🎯 [CONTROLLER] Passenger ID: $passengerId');
    print('🎯 [CONTROLLER] Received parameters:');
    print('   - Name: $name');
    print('   - Age: $age');
    print('   - Gender: $gender');
    print('   - Mobile: $mobile');
    print('   - Nationality: $nationality');
    print('   - Berth Preference: $berthPreference');
    print('   - Food Preference: $foodPreference');
    print('   - Email: $email');
    print('   - Address: $address');
    
    try {
      isLoading.value = true;
      print('🔄 [CONTROLLER] Loading state set to true');

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('accessToken');

      if (token == null) {
        Get.snackbar(
          'Error',
          'Please login to edit traveler',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      if (name.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Traveler name is required',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      String berthChoiceCode = _berthAbbreviations[berthPreference ?? ''] ?? '';
      
      // Convert gender to single character format (Male -> M, Female -> F, Other -> O)
      String genderCode = 'M'; // Default to Male
      if (gender != null && gender.isNotEmpty) {
        if (gender.toLowerCase() == 'male' || gender == 'M') {
          genderCode = 'M';
        } else if (gender.toLowerCase() == 'female' || gender == 'F') {
          genderCode = 'F';
        } else if (gender.toLowerCase() == 'other' || gender == 'O') {
          genderCode = 'O';
        }
      }

      // Prepare request data with default values to ensure no nulls
      final Map<String, dynamic> requestData = {
        'passengerName': name.trim().isNotEmpty ? name.trim() : 'Unknown',
        'passengerMobileNumber': mobile?.trim().isNotEmpty == true ? mobile!.trim() : '0000000000',
        'passengerBerthChoice': _berthAbbreviations[berthPreference ?? ''] ?? 'LB',
        'passengerAge': age != null && age.isNotEmpty ? (int.tryParse(age) ?? 18) : 18,
        'passengerGender': genderCode,
        'passengerNationality': nationality?.trim().isNotEmpty == true ? nationality!.trim() : 'IN',
        'pasenger_dob': '2000-01-01',
        'passengerFoodChoice': foodPreference ?? 'Veg',
      };
      
      // Add contact_email and address if provided
      if (email != null && email.trim().isNotEmpty) {
        requestData['contact_email'] = email.trim();
      }
      if (address != null && address.trim().isNotEmpty) {
        requestData['address'] = address.trim();
      }
      
      // Ensure all required fields have values
      requestData['passengerName'] = requestData['passengerName'] ?? 'Unknown';
      requestData['passengerMobileNumber'] = requestData['passengerMobileNumber'] ?? '0000000000';
      requestData['passengerBerthChoice'] = requestData['passengerBerthChoice'] ?? 'LB';
      requestData['passengerAge'] = requestData['passengerAge'] ?? 18;
      requestData['passengerGender'] = requestData['passengerGender'] ?? 'M';
      requestData['passengerNationality'] = requestData['passengerNationality'] ?? 'IN';
      requestData['pasenger_dob'] = requestData['pasenger_dob'] ?? '2000-01-01';
      requestData['passengerFoodChoice'] = requestData['passengerFoodChoice'] ?? 'Veg';

      // Use the endpoint from AppConfig
      final url = Uri.parse(AppConfig.editTraveller(passengerId));
      
      print('🌐 [CONTROLLER] Attempting to call API at: $url');
      print('🌐 [CONTROLLER] Request headers: ${{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }}');
      print('🌐 [CONTROLLER] Request body: ${json.encode(requestData)}');
      debugPrint('Attempting to call API at: $url');
      debugPrint('Request headers: ${{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      }}');
      debugPrint('Request body: ${json.encode(requestData)}');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: json.encode(requestData),
      ).timeout(
        Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Connection timed out. Please try again.');
        },
      );
      
      print('📥 [CONTROLLER] Response received!');
      print('📥 [CONTROLLER] Response status: ${response.statusCode}');
      print('📥 [CONTROLLER] Response body: ${response.body}');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ [CONTROLLER] Success response from backend!');
        try {
          final responseData = json.decode(response.body);
          
          // Update the traveler in the local list
          final index = travellers.indexWhere((t) => 
            (t['id']?.toString() == passengerId) || 
            (t['passengerId']?.toString() == passengerId)
          );
          
          if (index != -1) {
            travellers[index] = {
              ...travellers[index],
              'id': passengerId,
              'firstname': name.trim(),
              'passengerName': name.trim(),
              'mobile': mobile?.trim() ?? '',
              'passengerMobileNumber': mobile?.trim() ?? '',
              'age': age != null && age.isNotEmpty ? age : null,
              'passengerAge': age != null && age.isNotEmpty ? int.tryParse(age) : null,
              'passengerGender': genderCode,
              'passengerBerthChoice': berthChoiceCode.isNotEmpty ? berthChoiceCode : 'LB',
              'passengerFoodChoice': foodPreference ?? 'Veg',
              'passengerNationality': nationality?.trim() ?? 'IN',
              'contact_email': email?.trim() ?? '',
              'address': address?.trim() ?? '',
            };
            travellers.refresh();
          }
          
          Get.back();
          Get.snackbar(
            'Success',
            responseData['message'] ?? 'Traveller updated successfully!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          
          // Refresh the list from the server
          await fetchTravelers();
        } on FormatException {
          // Fallback in case of parsing error but successful response
          Get.back();
          Get.snackbar(
            'Success',
            'Traveller updated (response format unclear).',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          
          // Refresh the list from the server
          await fetchTravelers();
        }
      } else {
        print('❌ [CONTROLLER] Error response from backend!');
        print('❌ [CONTROLLER] Error response status: ${response.statusCode}');
        print('❌ [CONTROLLER] Error response headers: ${response.headers}');
        print('❌ [CONTROLLER] Error response body: ${response.body}');
        debugPrint('Error response status: ${response.statusCode}');
        debugPrint('Error response headers: ${response.headers}');
        debugPrint('Error response body: ${response.body}');
        
        String errorMessage = 'Failed to update traveler (Code: ${response.statusCode})';
        
        try {
          final errorResponse = json.decode(response.body);
          errorMessage = errorResponse['message'] ?? errorResponse['error'] ?? errorMessage;
          debugPrint('Parsed error message: $errorMessage');
        } catch (e) {
          debugPrint('Error parsing error response: $e');
        }
        
        throw Exception(errorMessage);
      }
    } on TimeoutException catch (e) {
      final errorMsg = 'Connection timed out. Please try again.';
      debugPrint('TimeoutException: $e');
      Get.snackbar(
        'Error',
        errorMsg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FormatException catch (e) {
      final errorMsg = 'Invalid response format from server';
      debugPrint('FormatException: $e');
      debugPrint('Response body: ${e.source}');
      Get.snackbar(
        'Error',
        errorMsg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
      );
    } on http.ClientException catch (e) {
      final errorMsg = 'Network error. Please check your connection.';
      debugPrint('ClientException: $e');
      debugPrint('URI: ${e.uri}');
      debugPrint('Message: ${e.message}');
      Get.snackbar(
        'Error',
        errorMsg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error, stackTrace) {
      print('❌ [CONTROLLER] Unexpected error caught!');
      print('❌ [CONTROLLER] Error: $error');
      print('❌ [CONTROLLER] Stack trace: $stackTrace');
      print('❌ [CONTROLLER] Error type: ${error.runtimeType}');
      debugPrint('Unexpected error: $error');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('Error type: ${error.runtimeType}');
      
      // Log the response if available
      if (error is http.Response) {
        debugPrint('Error response status: ${error.statusCode}');
        debugPrint('Error response body: ${error.body}');
      }
      
      Get.snackbar(
        'Error',
        error.toString().replaceFirst('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      print('🏁 [CONTROLLER] editTraveller completed. Loading set to false.');
    }
  }

  Future<void> fetchTravelers() async {
    try {
      isLoading.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('accessToken');
      
      if (token == null) {
        Get.snackbar('Error', 'Please login to view travelers');
        return;
      }

      debugPrint('Fetching travelers from: ${AppConfig.getTravelers}');
      
      final response = await http.get(
        Uri.parse(AppConfig.getTravelers),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Fetch travelers response: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        travellers.value = data.map((item) {
          final passengerAge = item['passengerAge'] ?? item['age'];
          return {
            'id': item['passengerId'] ?? item['id'],
            'firstname': item['passengerName'] ?? item['firstname'] ?? 'Unknown',
            'passengerName': item['passengerName'] ?? 'Unknown',
            'mobile': item['passengerMobileNumber'] ?? item['mobile'] ?? '',
            'passengerMobileNumber': item['passengerMobileNumber'] ?? item['mobile'] ?? '',
            'age': passengerAge != null ? passengerAge.toString() : null,
            'passengerAge': passengerAge,
            'passengerGender': item['passengerGender'] ?? item['gender'] ?? 'M',
            'passengerBerthChoice': item['passengerBerthChoice'] ?? 'LB',
            'passengerFoodChoice': item['passengerFoodChoice'] ?? 'Veg',
            'passengerNationality': item['passengerNationality'] ?? item['nationality'] ?? 'IN',
            'dob': item['dob'],
            'contact_email': item['contact_email'] ?? '',
            'address': item['address'] ?? '',
          };
        }).toList();
        
        debugPrint('Successfully loaded ${travellers.length} travelers');
      } else {
        Get.snackbar('Error', 'Failed to load travelers');
      }
    } on TimeoutException catch (e) {
      debugPrint('Timeout while fetching travelers: $e');
      Get.snackbar('Error', 'Request timed out. Please try again.');
    } on http.ClientException catch (e) {
      debugPrint('Network error while fetching travelers: $e');
      Get.snackbar('Error', 'Network error. Please check your connection.');
    } catch (e) {
      debugPrint('Error in fetchTravelers: $e');
      Get.snackbar('Error', 'An error occurred while fetching travelers');
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

  Future<void> deleteTraveler(int? travellerId) async {
    if (travellerId == null) {
      Get.snackbar(
        'Error',
        'Cannot delete: Traveller ID is missing',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('accessToken');

      if (token == null) {
        Get.snackbar(
          'Error',
          'Please login to delete traveler',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      debugPrint('Deleting traveler with ID: $travellerId');
      
      final response = await http.delete(
        Uri.parse(AppConfig.deleteTraveler(travellerId.toString())),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Connection timed out. Please try again.');
        },
      );

      debugPrint('Delete traveler response: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Remove from local list
        travellers.removeWhere((t) => t['id'] == travellerId);
        travellers.refresh();
        
        Get.snackbar(
          'Success',
          'Traveller deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        String errorMessage = 'Failed to delete traveler';
        try {
          final errorResponse = json.decode(response.body);
          errorMessage = errorResponse['message'] ?? errorResponse['error'] ?? errorMessage;
        } catch (e) {
          debugPrint('Error parsing error response: $e');
        }
        
        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on TimeoutException catch (e) {
      debugPrint('Timeout while deleting traveler: $e');
      Get.snackbar(
        'Error',
        'Connection timed out. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } on http.ClientException catch (e) {
      debugPrint('Network error while deleting traveler: $e');
      Get.snackbar(
        'Error',
        'Network error. Please check your connection.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Error in deleteTraveler: $e');
      Get.snackbar(
        'Error',
        'An error occurred while deleting traveler',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void printTravelers() {
    if (travellers.isEmpty) {
      debugPrint('No travelers added yet.');
      return;
    }

    debugPrint('\n===== TRAVELER LIST =====');
    for (int i = 0; i < travellers.length; i++) {
      final traveler = travellers[i];
      debugPrint('Traveler #${i + 1} (ID: ${traveler['id'] ?? 'N/A'}):');
      debugPrint('  Name: ${traveler['firstname'] ?? traveler['passengerName'] ?? 'N/A'}');
      debugPrint('  Mobile: ${traveler['mobile'] ?? 'N/A'}');
      debugPrint('  DOB: ${traveler['dob'] ?? 'N/A'}');
      debugPrint('  Berth Preference: ${traveler['passengerBerthChoice'] ?? 'N/A'}');
      debugPrint('  Selected: ${traveler['selected'] ?? false}');
      debugPrint('----------------------');
    }
    debugPrint('Total travelers: ${travellers.length}');
    debugPrint('===========================\n');
  }
}
