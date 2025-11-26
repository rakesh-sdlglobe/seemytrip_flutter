import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
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
  final RxList<Map<String, String>> filteredAirports =
      <Map<String, String>>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
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
          backgroundColor: AppColors.redCA0,
          colorText: AppColors.white,
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
      filteredAirports.assignAll(airports
          .where((airport) =>
              (airport['name']?.toLowerCase().contains(query) ?? false) ||
              (airport['code']?.toLowerCase().contains(query) ?? false) ||
              (airport['city']?.toLowerCase().contains(query) ?? false))
          .toList());
    });
  }

  void _selectAirport(String airportName, String airportCode) {
    try {
      final searchParams = _flightController.getLastSearchParams();
      searchParams['toAirport'] = airportCode;
      Get.back(result: {
        'stationName': airportName,
        'stationCode': airportCode,
      });
    } catch (e) {
      Get.back();
    }
  }

  // Helper methods for theme-aware colors
  Color _getBackgroundColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.cardBackground
          : AppColors.white;

  Color _getTextColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.white
          : AppColors.black2E2;

  Color _getHintColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? AppColors.greyB8B
          : AppColors.grey717;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: _getBackgroundColor(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar style top bar
              Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.grey363.withOpacity(0.3)
                            : AppColors.greyEEE.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withOpacity(0.1)
                                : Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: isDark ? AppColors.white : AppColors.grey717,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Choose Destination',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _getTextColor(context),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Search Box Card
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.grey363.withOpacity(0.3)
                      : AppColors.greyEEE.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? AppColors.grey363.withOpacity(0.1)
                          : AppColors.greyEEE.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.flight_land_rounded,
                      color: isDark
                          ? AppColors.redCA0.withOpacity(0.8)
                          : AppColors.redCA0,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _toController,
                        autofocus: true,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: _getTextColor(context),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search city or airport name',
                          hintStyle: TextStyle(
                            color: isDark
                                ? AppColors.white.withOpacity(0.7)
                                : AppColors.grey2E2,
                          ),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) => _filterAirports(value),
                      ),
                    ),
                    if (_toController.text.isNotEmpty)
                      IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: isDark
                              ? AppColors.white.withOpacity(0.7)
                              : AppColors.grey717,
                        ),
                        onPressed: () {
                          _toController.clear();
                          _filterAirports('');
                        },
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Popular Airports',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: _getHintColor(context),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: Obx(() {
                  if (isLoading.value) {
                    return Center(
                      child: LoadingAnimationWidget.dotsTriangle(
                        color: AppColors.redCA0,
                        size: 50,
                      ),
                    );
                  } else if (hasError.value) {
                    return Center(
                      child: Text(
                        'Error loading airports.',
                        style: GoogleFonts.poppins(
                          color: _getHintColor(context),
                          fontSize: 14,
                        ),
                      ),
                    );
                  } else if (filteredAirports.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.airplanemode_inactive,
                            size: 50,
                            color: _getHintColor(context).withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No airports found',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: _getHintColor(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try searching for a different location',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: _getHintColor(context).withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: filteredAirports.length,
                    separatorBuilder: (_, __) => Divider(
                      color: isDark ? Colors.grey[800] : AppColors.greyE8E,
                      height: 0,
                    ),
                    itemBuilder: (context, index) {
                      final airport = filteredAirports[index];
                      final city = airport['city'] ?? 'Unknown';
                      final code = airport['code'] ?? '';
                      final name = airport['name'] ?? 'Unknown Airport';
                      final country = airport['country'] ?? '';

                      return InkWell(
                        onTap: () => _selectAirport(name, code),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                    AppColors.redCA0.withOpacity(0.1),
                                child: Icon(
                                  Icons.flight_land_rounded,
                                  color: isDark
                                      ? AppColors.redCA0.withOpacity(0.8)
                                      : AppColors.redCA0,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: _getTextColor(context),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        children: [
                                          TextSpan(text: '$city '),
                                          TextSpan(
                                            text: '($code)',
                                            style: GoogleFonts.poppins(
                                              color: _getHintColor(context),
                                              fontSize: 13,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: _getHintColor(context),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              if (country.isNotEmpty)
                                Text(
                                  country,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: _getHintColor(context),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
