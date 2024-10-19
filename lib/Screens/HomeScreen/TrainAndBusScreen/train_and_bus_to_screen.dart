import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';

class TrainAndBusToScreen extends StatefulWidget {
  TrainAndBusToScreen({Key? key}) : super(key: key);

  @override
  _TrainAndBusToScreenState createState() => _TrainAndBusToScreenState();
}

class _TrainAndBusToScreenState extends State<TrainAndBusToScreen> {
  bool _isEditingTo = false; // To toggle between text and input field
  TextEditingController _toController =
      TextEditingController(); // Controller for 'To' input
  List<dynamic> stations = []; // List to hold fetched stations
  List<dynamic> filteredStations = []; // List to hold filtered stations
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    fetchStations(); // Fetch stations when the screen initializes
    _toController.addListener(
        _filterStations); // Add listener to filter stations based on input
  }

  @override
  void dispose() {
    _toController.dispose(); // Dispose controller to free resources
    super.dispose();
  }

  Future<void> fetchStations() async {
    final dio = Dio(); // Create a Dio instance
    final url =
        'https://tripadmin.onrender.com/api/trains/getStation'; // Your API endpoint

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        try {
          final jsonResponse = response.data;
          setState(() {
            stations = jsonResponse[
                'stations']; // Assuming the API response contains a 'stations' key
            filteredStations = stations; // Initialize filtered stations
            isLoading = false; // Update loading state
          });
        } catch (e) {
          print("Error parsing JSON: $e");
          setState(() {
            isLoading = false; // Update loading state on error
          });
        }
      } else {
        print("Error: ${response.statusCode} - ${response.data}");
        setState(() {
          isLoading = false; // Update loading state on error
        });
      }
    } catch (e) {
      print("Error fetching stations: $e");
      setState(() {
        isLoading = false; // Update loading state on error
      });
    }
  }

  void _filterStations() {
    String query =
        _toController.text.toLowerCase(); // Get user input in lower case
    setState(() {
      filteredStations = stations.where((station) {
        return (station["name"]?.toLowerCase().contains(query) ?? false) ||
            (station["code"]?.toLowerCase().contains(query) ?? false) ||
            (station["city"]?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  void _selectStation(String stationName, String stationId) {
    // Print the selected station details to verify the data
    print("Selected Station Name: $stationName");
    print("Selected Station ID: $stationId");

    // Pass the selected station name and ID back to the previous screen
    Get.back(result: {
      'stationName': stationName,
      'stationId': stationId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: redF8E,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: greyE8E, width: 1),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back, color: black2E2, size: 20),
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextWidget.PoppinsMedium(
                          text: "To",
                          color: redCA0,
                          fontSize: 14,
                        ),
                        SizedBox(height: 5),
                        _isEditingTo
                            ? SizedBox(
                                width: 200,
                                child: TextField(
                                  controller: _toController,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    hintText: "Enter any City/Airport Name",
                                    border: InputBorder.none,
                                  ),
                                  onSubmitted: (value) {
                                    setState(() {
                                      _isEditingTo =
                                          false; // Close input field on submit
                                    });
                                  },
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    _isEditingTo =
                                        true; // Open input field on tap
                                  });
                                },
                                child: CommonTextWidget.PoppinsMedium(
                                  text: _toController.text.isEmpty
                                      ? "Enter any City/Airport Name"
                                      : _toController.text,
                                  color: grey717,
                                  fontSize: 14,
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            CommonTextWidget.PoppinsMedium(
              text: "Popular Searches",
              color: grey717,
              fontSize: 12,
            ),
            Expanded(
              child: isLoading
                  ? Center(
                      child:
                          CircularProgressIndicator(), // Show loading indicator while fetching data
                    )
                  : filteredStations.isEmpty
                      ? Center(
                          child: Text(
                              "No stations found"), // Show message if no stations found
                        )
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: filteredStations
                              .length, // Use filtered stations count
                          itemBuilder: (context, index) {
                            final station =
                                filteredStations[index]; // Get filtered station
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: CommonTextWidget.PoppinsRegular(
                                text: station["name"] ??
                                    "Unknown Station", // Display station name
                                color: black2E2,
                                fontSize: 16,
                              ),
                              // subtitle: CommonTextWidget.PoppinsRegular(
                              //   text: station["code"] ??
                              //       "N/A", // Display station code
                              //   color: grey717,
                              //   fontSize: 12,
                              // ),
                              // trailing: CommonTextWidget.PoppinsMedium(
                              //   text: station["city"] ??
                              //       "Unknown City", // Display station city
                              //   color: grey717,
                              //   fontSize: 16,
                              // ),
                              onTap: () {
                                _selectStation(
                                    station["name"],
                                    station["id"]
                                        .toString()); // Pass name and ID to the previous screen
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
