import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../controllers/flight_controller.dart';

class FlightToScreen extends StatefulWidget {
  @override
  _FlightToScreenState createState() => _FlightToScreenState();
}

class _FlightToScreenState extends State<FlightToScreen> {
  final FlightController _flightController = Get.find<FlightController>();
  bool _isEditingTo = false;
  final TextEditingController _toController = TextEditingController();
  final RxList<Map<String, String>> airports = <Map<String, String>>[].obs;
  final RxList<Map<String, String>> filteredAirports = <Map<String, String>>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs; // This line is already correct.
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _toController.addListener(_onSearchChanged);
    _fetchAirports();
  }

  Future<void> _fetchAirports() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      final airportList = _flightController.airports;
      
      if (airportList.isEmpty) {
        await _flightController.fetchAirports();
        airports.assignAll(_flightController.airports);
      } else {    
        airports.assignAll(airportList);
      }
      
      filteredAirports.assignAll(airports);
      
      if (airports.isEmpty) {
        throw Exception('No airports available. Please try again later.');
      }
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      hasError.value = true;
      
      if (mounted) {
        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    _toController.dispose();
    _debounce?.cancel();
    super.dispose();
  }


  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 300), () {
      if (mounted) {
        _filterAirports(_toController.text);
      }
    });
  }

  void _filterAirports(String query) {
    if (query.isEmpty) {
      filteredAirports.assignAll(airports);
      return;
    }
    
    query = query.toLowerCase();
    setState(() {
      filteredAirports.assignAll(airports.where((airport) => 
      (airport['name']?.toLowerCase().contains(query) ?? false) ||
      (airport['code']?.toLowerCase().contains(query) ?? false) ||
      (airport['city']?.toLowerCase().contains(query) ?? false)
    ).toList());
    });
  }

  void _selectAirport(String airportName, String airportCode) {
    try {
      final searchParams = _flightController.getLastSearchParams();
      searchParams['toAirport'] = airportCode;
      searchParams['toAirport'] = airportCode; // correct
      Get.back(result: {
        'stationName': airportName,
        'stationCode': airportCode,
      });
    } catch (e) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
                          text: 'To',
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
                                    hintText: 'Enter any City/Airport Name',
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
                                      ? 'Enter any City/Airport Name'
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
              text: 'Popular Searches',
              color: grey717,
              fontSize: 12,
            ),
            Expanded(
              child: isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : hasError.value
                      ? Center(child: Text('Error fetching airports.'))
                      : filteredAirports.isEmpty
                          ? Center(child: Text('No airports found'))
                          : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: filteredAirports.length,
                            itemBuilder: (context, index) {
                              final airport = filteredAirports[index];
                              final city = airport['city'] ?? 'Unknown';
                              final code = airport['code'] ?? '';
                              final name = airport['name'] ?? 'Unknown Airport';
                              
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: black2E2,
                                      fontSize: 16,
                                    ),
                                    children: [
                                      TextSpan(text: '$city '),
                                      TextSpan(
                                        text: '($code)',
                                        style: TextStyle(
                                          color: grey717,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: CommonTextWidget.PoppinsRegular(
                                  text: name,
                                  color: grey717,
                                  fontSize: 12,
                                ),
                                onTap: () {
                                  _selectAirport(name, code);
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
