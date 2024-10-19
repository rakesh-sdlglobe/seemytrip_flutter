import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';

class TrainAndBusFromScreen extends StatefulWidget {
  @override
  _TrainAndBusFromScreenState createState() => _TrainAndBusFromScreenState();
}

class _TrainAndBusFromScreenState extends State<TrainAndBusFromScreen> {
  bool _isEditingFrom = false; // Toggle between input and display mode
  TextEditingController _fromController = TextEditingController();
  List<dynamic> stations = [];
  List<dynamic> filteredStations = [];
  bool isLoading = true;
  bool hasError = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    fetchStations();
    _fromController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _fromController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> fetchStations() async {
    final dio = Dio();
    final url = 'https://tripadmin.onrender.com/api/trains/getStation';

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        setState(() {
          stations = response.data['stations'] ?? [];
          filteredStations = stations;
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
      _filterStations(_fromController.text);
    });
  }

  void _filterStations(String query) {
    query = query.toLowerCase();
    setState(() {
      filteredStations = stations.where((station) {
        return (station["name"]?.toLowerCase().contains(query) ?? false) ||
            (station["code"]?.toLowerCase().contains(query) ?? false) ||
            (station["city"]?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  void _selectStation(String stationName, String stationId) {
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
                          text: "From",
                          color: redCA0,
                          fontSize: 14,
                        ),
                        SizedBox(height: 5),
                        _isEditingFrom
                            ? SizedBox(
                                width: 200,
                                child: TextField(
                                  controller: _fromController,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    hintText: "Enter any City/Station Name",
                                    border: InputBorder.none,
                                  ),
                                  onSubmitted: (value) {
                                    setState(() {
                                      _isEditingFrom = false;
                                    });
                                  },
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    _isEditingFrom = true;
                                  });
                                },
                                child: CommonTextWidget.PoppinsMedium(
                                  text: _fromController.text.isEmpty
                                      ? "Enter any City/Station Name"
                                      : _fromController.text,
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
                      ? Center(child: Text("Error fetching stations."))
                      : filteredStations.isEmpty
                          ? Center(child: Text("No stations found"))
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: filteredStations.length,
                              itemBuilder: (context, index) {
                                final station = filteredStations[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: CommonTextWidget.PoppinsRegular(
                                    text: station["name"] ?? "Unknown Station",
                                    color: black2E2,
                                    fontSize: 16,
                                  ),
                                  onTap: () {
                                    _selectStation(station["name"],
                                        station["id"].toString());
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
