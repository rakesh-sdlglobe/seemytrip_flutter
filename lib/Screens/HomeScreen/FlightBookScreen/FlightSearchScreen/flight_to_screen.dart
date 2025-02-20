import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/font_family.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';
import 'package:makeyourtripapp/main.dart';

class FlightToScreen extends StatefulWidget {
  @override
  _FlightToScreenState createState() => _FlightToScreenState();
}

class _FlightToScreenState extends State<FlightToScreen> {
  bool _isEditingTo = false;
  TextEditingController _toController = TextEditingController();
  List<dynamic> airports = [];
  List<dynamic> filteredAirports = [];
  bool isLoading = true;
  bool hasError = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    fetchAirports();
    _toController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _toController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> fetchAirports() async {
    final dio = Dio();
    final url =
        'http://192.168.1.103:3002/api/trains/getStation'; // Replace with your API

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        setState(() {
          airports = response.data['airports'] ?? [];
          filteredAirports = airports;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 300), () {
      _filterAirports(_toController.text);
    });
  }

  void _filterAirports(String query) {
    query = query.toLowerCase();
    setState(() {
      filteredAirports = airports.where((airport) {
        return (airport["name"]?.toLowerCase().contains(query) ?? false) ||
            (airport["code"]?.toLowerCase().contains(query) ?? false) ||
            (airport["city"]?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  void _selectAirport(String airportName, String airportCode) {
    Get.back(result: {
      'airportName': airportName,
      'airportCode': airportCode,
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
                          color: black2E2,
                          fontSize: 14,
                        ),
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
                                      _isEditingTo = false;
                                    });
                                  },
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    _isEditingTo = true;
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
                  ? Center(child: CircularProgressIndicator())
                  : hasError
                      ? Center(child: Text("Error fetching airports."))
                      : filteredAirports.isEmpty
                          ? Center(child: Text("No airports found"))
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: filteredAirports.length,
                              itemBuilder: (context, index) {
                                final airport = filteredAirports[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: CommonTextWidget.PoppinsRegular(
                                    text: airport["name"] ?? "Unknown Airport",
                                    color: black2E2,
                                    fontSize: 16,
                                  ),
                                  subtitle: CommonTextWidget.PoppinsRegular(
                                    text: airport["city"] ?? "Unknown City",
                                    color: grey717,
                                    fontSize: 12,
                                  ),
                                  onTap: () {
                                    _selectAirport(
                                        airport["name"], airport["code"]);
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
