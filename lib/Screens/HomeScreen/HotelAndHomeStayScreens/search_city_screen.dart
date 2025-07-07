import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Controller/search_city_controller.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/allow_location_access_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/hotel_and_home_stay_tab_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/upto5_rooms_screen.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';

class SearchCityScreen extends StatelessWidget {
  SearchCityScreen({Key? key}) : super(key: key);

  // 1) Get the existing controller (put it in main() or a parent)
  final SearchCityController controller = Get.find();
  final TextEditingController textController = TextEditingController();

  /// Show the bottom‐sheet search modal
  void _showSearchModal(BuildContext context) {
    // Make sure our text field is in sync
    textController.text = controller.searchText.value;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: white,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.9,
          minChildSize: 0.4,
          builder: (ctx, scrollCtrl) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Search input
                  TextField(
                    controller: textController,
                    autofocus: true, // Keep autofocus
                    onChanged: (value) {
                      controller.searchText.value = value; // Update the reactive searchText
                      controller.filterCities(value); // Call filterCities with the new value
                    },
                    decoration: InputDecoration(
                      hintText: 'Search cities…',
                      prefixIcon: Icon(Icons.search, color: redCA0),
                      suffixIcon: Obx(() {
                        return controller.searchText.value.isEmpty
                            ? const SizedBox.shrink()
                            : IconButton(
                                icon: Icon(Icons.clear, color: grey717),
                                onPressed: () {
                                  textController.clear();
                                  controller.searchText.value = '';
                                },
                              );
                      }),
                      filled: true,
                      fillColor: redFAE.withOpacity(0.1),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: redCA0.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: redCA0, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Loading or list
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final list = controller.filteredCities;
                    if (list.isEmpty) {
                      return Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 48,
                                color: grey717.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                controller.searchText.value.isEmpty
                                    ? 'Start typing to search cities'
                                    : 'No cities found',
                                style: TextStyle(
                                  color: grey717,
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        controller: scrollCtrl,
                        itemCount: list.length,
                        itemBuilder: (_, i) {
                          final city = list[i];
                          return Card(
                            elevation: 0,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: redFAE.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.location_city, color: redCA0),
                              ),
                              title: Text(
                                city.name,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Icon(Icons.hotel, size: 14, color: grey717),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Hotels available",
                                    style: TextStyle(
                                      color: grey717,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                              trailing:
                                  Icon(Icons.arrow_forward_ios, size: 16, color: grey717),
                              onTap: () {
                                // Debug print for selection
                                print('\n=== City Selected ===');
                                print('Name: ${city.name}');
                                print('ID: ${city.id}');
                                print('=====================\n');

                                controller.selectCity(city);
                                controller.searchText.value = '';
                                textController.clear();
                                Get.back();
                                Get.to(() => HotelAndHomeStayTabScreen());
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----- Header Bar -----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: redFAE.withOpacity(0.6),
                  border: Border.all(color: redCA0),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: black2E2),
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showSearchModal(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTextWidget.PoppinsMedium(
                                text:
                                    'City / Area / Landmark / Property / Name',
                                color: redCA0,
                                fontSize: 12,
                              ),
                              const SizedBox(height: 4),
                              CommonTextWidget.PoppinsRegular(
                                text: controller.selectedCity.value?.name ??
                                    'Tap to search',
                                color: grey717,
                                fontSize: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ----- Current Location -----
            ListTile(
              leading: SvgPicture.asset(crosshair),
              title: CommonTextWidget.PoppinsMedium(
                text: 'CURRENT LOCATION',
                color: grey717,
                fontSize: 14,
              ),
              subtitle: CommonTextWidget.PoppinsRegular(
                text: 'Use my current location',
                color: redCA0,
                fontSize: 14,
              ),
              onTap: () {
                Get.bottomSheet(
                  AllowLocationAccessScreen(),
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                );
              },
            ),

            const SizedBox(height: 16),

            // ----- Selected City -----
            Obx(() {
              final city = controller.selectedCity.value;
              return ListTile(
                leading: Icon(Icons.location_city, color: redCA0),
                title: CommonTextWidget.PoppinsMedium(
                  text: 'SELECTED CITY',
                  color: grey717,
                  fontSize: 14,
                ),
                subtitle: CommonTextWidget.PoppinsRegular(
                  text: city?.name ?? 'Choose your destination',
                  color: black2E2,
                  fontSize: 14,
                ),
                trailing: city == null
                    ? Icon(Icons.arrow_forward_ios,
                        size: 16, color: grey717)
                    : IconButton(
                        icon: Icon(Icons.close, color: grey717),
                        onPressed: () => controller.selectedCity.value = null,
                      ),
                onTap: () => _showSearchModal(context),
              );
            }),

            const SizedBox(height: 32),

            // ----- Trending Searches -----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  SvgPicture.asset(trendArrow, color: grey717),
                  const SizedBox(width: 8),
                  CommonTextWidget.PoppinsMedium(
                    text: 'Trending Searches',
                    color: grey717,
                    fontSize: 14,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Obx(() {
              final recents = controller.recentSearches;
              return SizedBox(
                height: 65,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  itemCount: recents.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, i) {
                    final city = recents[i];
                    return GestureDetector(
                      onTap: () {
                        controller.selectCity(city);
                        Get.back(); // if you’re still in a sheet
                        Get.to(() => UpTo5RoomsScreen());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: grey515.withOpacity(0.25),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonTextWidget.PoppinsRegular(
                              text: city.name,
                              color: black2E2,
                              fontSize: 14,
                            ),
                            CommonTextWidget.PoppinsRegular(
                              text: 'India',
                              color: grey717,
                              fontSize: 10,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
