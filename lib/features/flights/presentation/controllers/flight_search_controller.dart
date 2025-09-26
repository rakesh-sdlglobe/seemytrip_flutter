import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum FlightSearchType { oneWay, roundTrip, multiCity }

class FlightSearchController extends GetxController {
  // Search Type
  Rx<FlightSearchType> searchType = FlightSearchType.oneWay.obs;

  // Stations
  RxString fromStation = ''.obs;
  RxString toStation = ''.obs;

  // Dates
  Rx<DateTime> departureDate = DateTime.now().obs;
  Rx<DateTime> returnDate = DateTime.now().add(Duration(days: 7)).obs;

  // Travelers and Class
  RxInt travelers = 1.obs;
  RxString travelClass = 'Economy'.obs;

  // Multi-city
  RxList<Map<String, String>> multiCityFlights = <Map<String, String>>[].obs;

  // For the UI
  late TabController tabController;
  bool isControllerInitialized = false;
  
  @override
  void onInit() {
    super.onInit();
    // Don't initialize here, wait for init() to be called with proper vsync
  }

  @override
  void onClose() {
    if (isControllerInitialized) {
      tabController.dispose();
    }
    super.onClose();
  }

  List<Tab> get myTabs => <Tab>[
    Tab(text: 'oneWay'.tr),
    Tab(text: 'roundTrip'.tr),
    Tab(text: 'multiCity'.tr),
  ];

  // This method should be called from the view's initState with a proper vsync
  void init(TickerProvider vsync) {
    // Dispose the old controller if it exists
    if (isControllerInitialized) {
      tabController.dispose();
    }
    
    // Create new controller with the provided vsync
    tabController = TabController(
      vsync: vsync,
      length: myTabs.length,
    );
    
    isControllerInitialized = true;
    
    tabController.addListener(() {
      switch (tabController.index) {
        case 0:
          searchType.value = FlightSearchType.oneWay;
          break;
        case 1:
          searchType.value = FlightSearchType.roundTrip;
          break;
        case 2:
          searchType.value = FlightSearchType.multiCity;
          break;
      }
    });
  }

  void setFromStation(String station) {
    fromStation.value = station;
  }

  void setToStation(String station) {
    toStation.value = station;
  }

  void setDepartureDate(DateTime date) {
    departureDate.value = date;
  }

  void setReturnDate(DateTime date) {
    returnDate.value = date;
  }

  void setTravelers(int count) {
    travelers.value = count;
  }

  void setTravelClass(String newClass) {
    travelClass.value = newClass;
  }

  void addMultiCityFlight() {
    multiCityFlights.add({'from': '', 'to': '', 'date': ''});
  }

  void removeMultiCityFlight(int index) {
    multiCityFlights.removeAt(index);
  }

  void searchFlights() {
    // In a real app, you would construct a request object and send it to your API
    // For now, we'll just print the values to the console.
    print('Search Type: ${searchType.value}');
    print('From: ${fromStation.value}');
    print('To: ${toStation.value}');
    print('Departure Date: ${DateFormat('yyyy-MM-dd').format(departureDate.value)}');
    if (searchType.value == FlightSearchType.roundTrip) {
      print('Return Date: ${DateFormat('yyyy-MM-dd').format(returnDate.value)}');
    }
    print('Travelers: ${travelers.value}');
    print('Class: ${travelClass.value}');

    if (searchType.value == FlightSearchType.multiCity) {
      print('Multi-city Flights:');
      for (var flight in multiCityFlights) {
        print(
            '  From: ${flight['from']}, To: ${flight['to']}, Date: ${flight['date']}');
      }
    }
    // Get.to(() => FlightBookScreen(searchController: this));
  }
}
