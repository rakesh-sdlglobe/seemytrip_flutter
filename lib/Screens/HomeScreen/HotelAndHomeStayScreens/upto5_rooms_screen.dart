import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Controller/search_city_controller.dart';
import 'package:seemytrip/Controller/roomsGuest_controller.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/rooms_and_guest_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/search_city_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/select_checkin_date_screen.dart';
import 'package:seemytrip/Screens/Utills/common_button_widget.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Screens/Utills/lists_widget.dart';
import 'package:seemytrip/main.dart';

class UpTo5RoomsScreen extends StatelessWidget {
  UpTo5RoomsScreen({Key? key}) : super(key: key);

  // find the shared controller
  final SearchCityController _searchCtrl = Get.find();
  final RoomsGuestController _rgCtrl = Get.put(RoomsGuestController());

  @override
  Widget build(BuildContext context) {
    // Post‐frame prints for debug
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final city = _searchCtrl.selectedCity.value;
    //   print('>>>> Current selection:');
    //   print('   City ID: ${city?.id ?? "none"}');
    //   print('   City Name: ${city?.name ?? "none"}');
    //   print('   Check-in: ${_searchCtrl.checkInDate.value}');
    //   print('   Check-out: ${_searchCtrl.checkOutDate.value}');
    //   // print('   Nights: ${_searchCtrl.numberOfNights.value}');
    // });

    return Scaffold(
      body: Obx(() {
        // Wrap entire scroll view so it rebuilds when any Rx changes
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              // 1) City selector card
              _buildCard(
                onTap: () => Get.to(() => SearchCityScreen()),
                icon: mapPin,
                title: "Add City/Area/Landmark",
                subtitle: _searchCtrl.selectedCity.value?.name
                          ?? "Choose your destination",
                extraText: "India",
              ),

              const SizedBox(height: 16),

              // 2) Check-in card
              _buildCard(
                onTap: () async {
                  final result = await Get.to(() => SelectCheckInDateScreen());
                  if (result is Map<String, dynamic>) {
                    _searchCtrl.checkInDate.value = result['startDate'];
                    _searchCtrl.checkOutDate.value = result['endDate'];
                    // _searchCtrl.numberOfNights.value = result['numberOfNights'];
                  }
                },
                icon: calendarPlus,
                title: "Check-In Date",
                subtitle: _searchCtrl.checkInDate.value == null
                    ? "Date & Month"
                    : DateFormat('dd MMM yyyy')
                        .format(_searchCtrl.checkInDate.value!),
              ),

              const SizedBox(height: 16),

              // 3) Check-out card
              _buildCard(
                onTap: () async {
                  final result = await Get.to(() => SelectCheckInDateScreen());
                  if (result is Map<String, dynamic>) {
                    _searchCtrl.checkInDate.value = result['startDate'];
                    _searchCtrl.checkOutDate.value = result['endDate'];
                    // _searchCtrl.numberOfNights.value = result['numberOfNights'];
                  }
                },
                icon: calendarPlus,
                title: "Check-Out Date",
                subtitle: _searchCtrl.checkOutDate.value == null
                    ? "Date & Month"
                    : DateFormat('dd MMM yyyy')
                        .format(_searchCtrl.checkOutDate.value!),
              ),

              const SizedBox(height: 16),

              // 4) Rooms & Guests card
              Obx(() => _buildCard(
                    onTap: () async {
                      final result = await Get.bottomSheet(
                        RoomsAndGuestScreen(
                          roomGuestData: _rgCtrl.roomGuestData,
                        ),
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                      );
                      if (result is List<Map<String, dynamic>>) {
                        _rgCtrl.onDone(result);
                      }
                    },
                    icon: user,
                    title: "Add Rooms & Guests",
                    subtitle: _rgCtrl.subtitleSummary,
                  )),

              const SizedBox(height: 25),
              CommonTextWidget.PoppinsMedium(
                text: "Improve Your Search",
                color: grey888,
                fontSize: 14,
              ),

              const SizedBox(height: 12),
              SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: Lists.improveYorSearchList.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, i) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: greyE2E),
                        borderRadius: BorderRadius.circular(5),
                        color: white,
                      ),
                      alignment: Alignment.center,
                      child: CommonTextWidget.PoppinsMedium(
                        text: Lists.improveYorSearchList[i],
                        color: grey5F5,
                        fontSize: 14,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: _buildSearchButton(),
        ),
      ),
    );
  }

  Widget _buildCard({
    required VoidCallback onTap,
    required String icon,
    required String title,
    required String subtitle,
    String? extraText,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: grey9B9.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: greyE2E),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // <-- add this line
          children: [
            SvgPicture.asset(icon),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextWidget.PoppinsMedium(
                    text: title,
                    color: grey888,
                    fontSize: 14,
                  ),
                  const SizedBox(height: 2),
                  CommonTextWidget.PoppinsSemiBold(
                    text: subtitle,
                    color: black2E2,
                    fontSize: 18,
                  ),
                  if (extraText != null) ...[
                    const SizedBox(height: 2),
                    CommonTextWidget.PoppinsRegular(
                      text: extraText,
                      color: grey888,
                      fontSize: 12,
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Obx(() => Stack(
      alignment: Alignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            final city = _searchCtrl.selectedCity.value;
            final checkIn = _searchCtrl.checkInDate.value;
            final checkOut = _searchCtrl.checkOutDate.value;

            // Validation checks
            if (city == null || city.id.isEmpty) {
              Get.snackbar(
                'Error',
                'Please select a city first',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }

            if (checkIn == null || checkOut == null) {
              Get.snackbar(
                'Error',
                'Please select check-in and check-out dates',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }

            if (_rgCtrl.roomGuestData.isEmpty) {
              Get.snackbar(
                'Error',
                'Please select rooms and guests',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
              return;
            }

            // Build dynamic rooms list for API
            final List<Map<String, dynamic>> roomsList = _rgCtrl.roomGuestData.map((room) {
              return {
                "RoomNo": room["RoomNo"],
                "Adults": room["Adults"],
                "Children": room["Children"],
              };
            }).toList();

            final totalAdults = roomsList.fold<int>(0, (sum, r) => sum + ((r["Adults"] as int? ?? 0)));
            final totalChildren = roomsList.fold<int>(0, (sum, r) => sum + ((r["Children"] as int? ?? 0)));

            try {
              _searchCtrl.fetchHotelDetails(
                cityId: city.id,
                cityName: city.name,
                checkIn: checkIn,
                checkOut: checkOut,
                rooms: roomsList.length,
                adults: totalAdults,
                children: totalChildren,
                roomsList: roomsList,
              );
            } catch (e) {
              _searchCtrl.isLoading.value = false;
              print('Error calling fetchHotelDetails: $e');
              Get.snackbar(
                'Error',
                'Something went wrong. Please try again.',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: redCA0,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 104),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _searchCtrl.isLoading.value
              ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text(
                  'SEARCH HOTELS',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
        ),
        if (_searchCtrl.isLoading.value)
          Positioned.fill(
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.center,
            ),
          ),
      ],
    ));
  }
}

