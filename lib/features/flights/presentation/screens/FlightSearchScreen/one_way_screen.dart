import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/widgets/common_button_widget.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../core/widgets/lists_widget.dart';
import '../../../../../main.dart';
import '../../../../../shared/constants/images.dart';
import '../../controllers/flight_controller.dart';
import '../../controllers/flight_search_controller.dart';
import 'custom_dialogbox.dart';
import 'datepicker.dart';
import 'flight_from_screen.dart';
import 'flight_to_screen.dart';
import 'from_station_selector.dart';
import 'offer_make_your_trip_screen.dart';
import 'to_station_selector.dart';

class OneWayScreen extends StatefulWidget {
  const OneWayScreen({Key? key}) : super(key: key);

  @override
  State<OneWayScreen> createState() => _OneWayScreenState();
}

class _OneWayScreenState extends State<OneWayScreen> {
  // Add the controller
  final FlightSearchController flightSearchController = Get.put(FlightSearchController());
  final FlightController flightController = Get.put(FlightController());
  
  @override
  void initState() {
    super.initState();
    // Initialize the travelers value in the controller
    flightSearchController.travelers.value = 1;
  }
  String? selectedFromStation; // To store the selected "From" station name
  String? selectedFromCode;    // To store the selected "From" station code
  String? selectedToStation;   // To store the selected "To" station name
  String? selectedToCode;      // To store the selected "To" station code
  String formattedDate = 'Select Date'; // Placeholder for selected date
  String dayOfWeek = ''; // Placeholder for day of the week
  DateTime selectedDate = DateTime.now();
  // Return date related variables - commented out as per requirement
  // DateTime? returnDate; // To store the return date
  // bool isReturnDateVisible = false;
  int? selectedFareIndex; // Add this variable to track the selected fare index
  String travelClass = 'Economy'; // Default travel class
  int travelers = 1; // Default number of travelers

  Future<void> _navigateToFromScreen() async {
    try {
      final result = await Get.to(() => FlightFromScreen());
      print('Returned from FlightFromScreen with result: $result');
      
      if (result != null && result is Map) {
        setState(() {
          selectedFromStation = result['stationName'] ?? result['airportName'];
          selectedFromCode = result['stationCode'] ?? result['airportCode'];
          // Also update the controller
          final flightController = Get.find<FlightController>();
          var params = flightController.getLastSearchParams();
          params['fromAirport'] = selectedFromCode;
        });
        print('Updated selectedFromStation to: $selectedFromStation');
      }
    } catch (e) {
      print('Error in _navigateToFromScreen: $e');
      Get.snackbar(
        'Error',
        'Failed to select departure airport',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _navigateToToScreen() async {
    try {
      final result = await Get.to(() => FlightToScreen());
      
      if (result != null && result is Map) {
        setState(() {
          selectedToStation = result['stationName'] ?? result['airportName'];
          selectedToCode = result['stationCode'] ?? result['airportCode'];
          // Also update the controller
          final flightController = Get.find<FlightController>();
          var params = flightController.getLastSearchParams();
          params['toAirport'] = selectedToCode;
        });
      }
    } catch (e) {
      print('Error in _navigateToToScreen: $e');
      Get.snackbar(
        'Error',
        'Failed to select arrival airport',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _selectDate(BuildContext context, {bool isReturnDate = false}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _selectTravelersAndClass() {
    showDialog(
      context: context,
      builder: (BuildContext context) => TravelClassAndTravelerSelector(
          travelClass: travelClass,
          travelers: travelers,
          onClassChanged: (String newClass) {
            setState(() {
              travelClass = newClass;
            });
          },
          onTravelerCountChanged: (int newCount) {
            setState(() {
              travelers = newCount;
            });
          },
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDepartureDate = DateFormat('dd MMM').format(selectedDate);
    // final String formattedReturnDate = returnDate != null
    //     ? DateFormat('dd MMM').format(returnDate!)
    //     : 'Select Return Date';
    final String dayOfWeekDeparture = DateFormat('EEEE').format(selectedDate);
    // final String dayOfWeekReturn =
    //     returnDate != null ? DateFormat('EEEE').format(returnDate!) : '';
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FromStationSelector(
              selectedFromStation: selectedFromStation,
              onTap: _navigateToFromScreen,
            ),
            SizedBox(height: 15),
            ToStationSelector(
              selectedToStation: selectedToStation,
              onTap: _navigateToToScreen,
            ),
            SizedBox(height: 15),
            DatePickerWidget(
              title: 'DATE',
              formattedDate: formattedDepartureDate,
              dayOfWeek: dayOfWeekDeparture,
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 18),
            // Return Date Button - Commented out as per requirement
            // GestureDetector(
            //   onTap: () {
            //     setState(() {
            //       isReturnDateVisible = !isReturnDateVisible;
            //     });
            //   },
            //   child: Container(
            //     width: Get.width,
            //     margin: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            //     padding: EdgeInsets.all(15),
            //     decoration: BoxDecoration(
            //       color: white,
            //       borderRadius: BorderRadius.circular(10),
            //       border: Border.all(color: Colors.grey.shade300),
            //     ),
            //     child: Row(
            //       children: [
            //         Container(
            //           height: 24,
            //           width: 24,
            //           decoration: BoxDecoration(
            //             color: isReturnDateVisible ? redCA0 : Colors.transparent,
            //             borderRadius: BorderRadius.circular(4),
            //             border: Border.all(
            //               color: isReturnDateVisible ? redCA0 : Colors.grey,
            //             ),
            //           ),
            //           child: isReturnDateVisible
            //               ? Icon(Icons.check, color: white, size: 16)
            //               : null,
            //         ),
            //         SizedBox(width: 15),
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             CommonTextWidget.PoppinsMedium(
            //               text: '+ ADD RETURN DATE',
            //               color: redCA0,
            //               fontSize: 14,
            //             ),
            //             CommonTextWidget.PoppinsMedium(
            //               text: 'Save more on round trips!',
            //               color: grey888,
            //               fontSize: 14,
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(height: 15),

            // Return Date Picker - Commented out as per requirement
            // if (isReturnDateVisible)
            //   DatePickerWidget(
            //     title: 'RETURN DATE',
            //     formattedDate: formattedReturnDate,
            //     dayOfWeek: dayOfWeekReturn,
            //     onTap: () => _selectDate(context, isReturnDate: true),
            //   ),

            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: _selectTravelersAndClass,
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: grey9B9.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 1, color: greyE2E),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                    child: Row(
                      children: [
                        SvgPicture.asset(user),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonTextWidget.PoppinsMedium(
                              text: 'TRAVELLERS & CLASS',
                              color: grey888,
                              fontSize: 14,
                            ),
                            Row(
                              children: [
                                CommonTextWidget.PoppinsSemiBold(
                                  text: '${flightSearchController.travelers.value} ,',
                                  color: black2E2,
                                  fontSize: 18,
                                ),
                                SizedBox(width: 10.0),
                                CommonTextWidget.PoppinsMedium(
                                  text: travelClass,
                                  color: grey888,
                                  fontSize: 14,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonTextWidget.PoppinsMedium(
                text: 'SPECIAL FARES (OPTIONAL)',
                color: grey888,
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 70,
              width: Get.width,
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView.builder(
                  itemCount: Lists.flightSearchList2.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding:
                      EdgeInsets.only(top: 13, bottom: 13, left: 24, right: 12),
                  itemBuilder: (BuildContext context, int index) => Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFareIndex =
                              index; // Update the selected fare index
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: selectedFareIndex == index
                              ? redCA0 // Highlight the selected fare
                              : white,
                          border: Border.all(
                            color:
                                selectedFareIndex == index ? redCA0 : greyE2E,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: CommonTextWidget.PoppinsMedium(
                              text: Lists.flightSearchList2[index],
                              color: selectedFareIndex == index
                                  ? white // Change text color for selected fare
                                  : grey5F5,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Obx(() {
                final FlightController flightController = Get.find<FlightController>();
                return CommonButtonWidget.button(
                  buttonColor: redCA0,
                  onTap: () async {
                    if (selectedFromStation == null || selectedToStation == null) {
                      Get.snackbar(
                        'Error',
                        'Please select both departure and arrival airports',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }
                    
                    try {
                      // Format date as YYYY-MM-DD
                      final String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
                      
                      await flightController.searchAndShowFlights(
                        fromAirportCode: selectedFromCode!,
                        toAirportCode: selectedToCode!,
                        departDate: formattedDate,
                        adults: travelers,
                        travelClass: travelClass == 'Economy' ? 'E' : 
                                    travelClass == 'Business' ? 'B' : 'F',
                        flightType: 'O', // One-way
                      );
                      
                      // The searchAndShowFlights method will handle navigation
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Failed to search flights: ${e.toString()}',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  text: flightController.isLoading.value ? 'SEARCHING...' : 'SEARCH FLIGHTS',
                );
              }),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonTextWidget.PoppinsSemiBold(
                    text: 'OFFERS',
                    color: black2E2,
                    fontSize: 16,
                  ),
                  Row(
                    children: [
                      CommonTextWidget.PoppinsRegular(
                        text: 'View All',
                        color: redCA0,
                        fontSize: 14,
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_ios, color: redCA0, size: 18),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: greyDED, thickness: 1),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                onTap: () {
                  Get.to(() => OfferMakeYourTripScreen());
                },
                child: CarouselSlider.builder(
                  itemCount: 4,
                  itemBuilder: (context, index, realIndex) => Container(
                    height: 170,
                    width: Get.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: AssetImage(flightSearchImage),
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.high)),
                  ),
                  options: CarouselOptions(
                      autoPlay: true,
                      height: 170,
                      enableInfiniteScroll: true,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        // realStateController.sliderIndex.value = index;
                      }),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: Get.width,
              color: redF9E,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextWidget.PoppinsRegular(
                      text:
                          'Explore the cheapest flight from New Delhi to Mumbai',
                      color: black2E2,
                      fontSize: 14,
                    ),
                    Row(
                      children: [
                        CommonTextWidget.PoppinsMedium(
                          text: 'EXPLORE FARE CALENDAR',
                          color: redCA0,
                          fontSize: 14,
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward, color: redCA0, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
