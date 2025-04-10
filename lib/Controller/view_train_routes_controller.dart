import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewTrainRoutesController extends GetxController {
  var isLoading = false.obs;
  var trainSchedule = {}.obs;

  Future<void> fetchTrainSchedule(String trainNumber) async {
    print("Fetching train schedule for $trainNumber...");
    isLoading(true);

    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.1.110:3002/api/trains/getTrainSchedule/$trainNumber'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Data received: $data");

        if (data != null && data.containsKey('stationList')) {
          trainSchedule.value = data;
        } else {
          trainSchedule.clear();
          print("No station list found in the response.");
        }
      } else {
        print("Error: ${response.statusCode}, ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error fetching train schedule: $error");
    } finally {
      isLoading(false);
    }
  }
}
