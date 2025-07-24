import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:seemytrip/Screens/HomeScreen/BusScreen/bus_home_screen.dart';

class BusController extends GetxController {
  var tokenId = ''.obs;
  var endUserIp = ''.obs;
  var busCities = <BusCity>[].obs;
  var cityList = [].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    authenticateBusAPI();
  }

  Future<void> authenticateBusAPI() async {
    isLoading(true);
    try {
      final response = await http.post(
        Uri.parse("http://192.168.137.150:3002/api/bus/authenticateBusAPI"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        tokenId.value = data["TokenId"] ?? '';
        endUserIp.value = data["EndUserIp"] ?? '';
        print("TOKEN ID: ${tokenId.value}, END USER IP: ${endUserIp.value}");

        if (tokenId.value.isNotEmpty && endUserIp.value.isNotEmpty) {
          await fetchCities(tokenId.value, endUserIp.value);
        } else {
          print("Token or IP is empty!");
        }
      }
    } catch (e) {
      print("Error: $e");
    }
    isLoading(false);
  }

  Future<void> fetchCities(String tokenId, String endUserIp) async {
    isLoading.value = true;

    final url = Uri.parse('http://192.168.137.150:3002/api/bus/getBusCityList');

    final headers = {
      'Content-Type': 'application/json',
    };

    // Use exact key names as expected by backend
    final body = jsonEncode({
      "TokenId": tokenId,
      "IpAddress": endUserIp,
    });

    print("Sending body: $body");

    try {
      final response = await http.post(url, headers: headers, body: body);

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        cityList.value = data['BusCities'] ?? [];
      } else {
        throw Exception("Failed to fetch bus cities");
      }
    } catch (e) {
      print("Error occurred while fetching cities: $e");
    } finally {
      isLoading.value = false;
    }
  }

  
}
