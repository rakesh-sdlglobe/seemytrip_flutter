import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/features/flights/presentation/screens/FlightSearchScreen/custom_dialogbox.dart';
import 'package:seemytrip/features/flights/presentation/screens/FlightSearchScreen/datepicker.dart';
import 'package:seemytrip/features/flights/presentation/screens/FlightSearchScreen/flight_from_screen.dart';
import 'package:seemytrip/features/flights/presentation/screens/FlightSearchScreen/flight_to_screen.dart';
import 'package:seemytrip/features/flights/presentation/screens/FlightSearchScreen/from_station_selector.dart';
import 'package:seemytrip/features/flights/presentation/screens/FlightSearchScreen/offer_make_your_trip_screen.dart';
import 'package:seemytrip/features/flights/presentation/screens/FlightSearchScreen/to_station_selector.dart';
import 'package:seemytrip/features/flights/presentation/screens/flight_book_screen.dart';
import 'package:seemytrip/core/widgets/common_button_widget.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';
import 'package:seemytrip/main.dart';
import 'package:intl/intl.dart';

class RoundTripScreen extends StatefulWidget {
  RoundTripScreen({Key? key}) : super(key: key);

  @override
  State<RoundTripScreen> createState() => _RoundTripScreenState();
}

class _RoundTripScreenState extends State<RoundTripScreen> {
  String? selectedFromStation; // To store the selected "From" station
  String? selectedToStation; // To store the selected "To" station
  String formattedDate = "Select Date"; // Placeholder for selected date
  String dayOfWeek = ""; // Placeholder for day of the week
  DateTime selectedDate = DateTime.now();
  DateTime? returnDate; // To store the return date
  bool isReturnDateVisible = false;
  int? selectedFareIndex; // Add this variable to track the selected fare index
  String travelClass = "Economy"; // Default travel class
  int travelers = 1; // Default number of travelers

  Future<void> _navigateToFromScreen() async {
    final result = await Get.to(() => FlightFromScreen());
    if (result != null && result.containsKey('stationName')) {
      setState(() {
        selectedFromStation = result['stationName'];
      });
    }
  }

  Future<void> _navigateToToScreen() async {
    final result = await Get.to(() => FlightToScreen());
    if (result != null && result.containsKey('stationName')) {
      setState(() {
        selectedToStation = result['stationName'];
      });
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
              child: CommonButtonWidget.button(
                buttonColor: redCA0,
                onTap: () {
                  Get.to(() => FlightBookScreen());
                },
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
