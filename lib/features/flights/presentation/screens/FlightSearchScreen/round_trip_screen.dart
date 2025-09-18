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

class RoundTripScreen extends StatefulWidget {
  RoundTripScreen({Key? key}) : super(key: key);

  @override
  State<RoundTripScreen> createState() => _RoundTripScreenState();
}

class _RoundTripScreenState extends State<RoundTripScreen> {
  // Add the controller
  final FlightSearchController flightSearchController = Get.put(FlightSearchController());
  final FlightController flightController = Get.put(FlightController());
  bool _isLoading = false;
  
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
  DateTime? returnDate; // To store the return date
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

  Future<void> _selectDate(BuildContext context,
      {bool isReturnDate = false}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isReturnDate && returnDate != null ? returnDate! : selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isReturnDate) {
          returnDate = picked;
        } else {
          selectedDate = picked;
        }
      });
    }
  }

  String _getTravelClassCode(String travelClass) {
    switch (travelClass.toLowerCase()) {
      case 'economy':
        return 'E';
      case 'premium economy':
        return 'PE';
      case 'business':
        return 'B';
      case 'first class':
        return 'F';
      default:
        return 'E';
    }
  }

  bool get _isFormValid {
    if (selectedFromStation == null || selectedFromCode == null) return false;
    if (selectedToStation == null || selectedToCode == null) return false;
    if (selectedFromCode == selectedToCode) return false;
    if (returnDate == null) return false;
    if (!returnDate!.isAfter(selectedDate)) return false;
    return true;
  }

  void _selectTravelersAndClass() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TravelClassAndTravelerSelector(
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
        );
      },
    );
  }

  Future<void> _searchFlights() async {
    if (!_isFormValid) {
      Get.snackbar(
        'Incomplete Information',
        'Please fill in all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final formattedDepartDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      final formattedReturnDate = DateFormat('yyyy-MM-dd').format(returnDate!);

      await flightController.searchAndShowFlights(
        fromAirportCode: selectedFromCode!,
        toAirportCode: selectedToCode!,
        departDate: formattedDepartDate,
        returnDate: formattedReturnDate,
        adults: travelers, // Assuming travelers is the number of adults for now
        travelClass: _getTravelClassCode(travelClass),
        flightType: 'R', // R for Round Trip
      );

      // Data sent to flight controller successfully
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to search flights. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDepartureDate = DateFormat('dd MMM').format(selectedDate);
    String formattedReturnDate = returnDate != null
        ? DateFormat('dd MMM').format(returnDate!)
        : 'Select Return Date';
    String dayOfWeekDeparture = DateFormat('EEEE').format(selectedDate);
    String dayOfWeekReturn =
        returnDate != null ? DateFormat('EEEE').format(returnDate!) : '';
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
              title: "DATE",
              formattedDate: formattedDepartureDate,
              dayOfWeek: dayOfWeekDeparture,
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 18),
            DatePickerWidget(
              title: "RETURN DATE",
              formattedDate: formattedReturnDate,
              dayOfWeek: dayOfWeekReturn,
              onTap: () => _selectDate(context, isReturnDate: true),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: _selectTravelersAndClass,
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: grey9B9.withOpacity(0.15),
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
                              text: "TRAVELLERS & CLASS",
                              color: grey888,
                              fontSize: 14,
                            ),
                            Row(
                              children: [
                                CommonTextWidget.PoppinsSemiBold(
                                  text: "$travelers ,",
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
                text: "SPECIAL FARES (OPTIONAL)",
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
                  itemBuilder: (context, index) => Padding(
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
              child: _isLoading
                  ? SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: redCA0.withValues(alpha: 0.7),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2.0,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'SEARCHING...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : CommonButtonWidget.button(
                      buttonColor: redCA0,
                      onTap: _searchFlights,
                      text: "SEARCH FLIGHTS",
                    ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonTextWidget.PoppinsSemiBold(
                    text: "OFFERS",
                    color: black2E2,
                    fontSize: 16,
                  ),
                  Row(
                    children: [
                      CommonTextWidget.PoppinsRegular(
                        text: "View All",
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
                          "Explore the cheapest flight from New Delhi to Mumbai",
                      color: black2E2,
                      fontSize: 14,
                    ),
                    Row(
                      children: [
                        CommonTextWidget.PoppinsMedium(
                          text: "EXPLORE FARE CALENDAR",
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
