import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../controllers/flight_controller.dart';

class FlightFromScreen extends StatefulWidget {
  @override
  _FlightFromScreenState createState() => _FlightFromScreenState();
}

class _FlightFromScreenState extends State<FlightFromScreen> {
  final FlightController _flightController = Get.find<FlightController>();
  final TextEditingController _fromController = TextEditingController();
  List<dynamic> airports = [];
  List<dynamic> filteredAirports = [];
  bool isLoading = true;
  bool hasError = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fromController.addListener(_onSearchChanged);
    _loadAirports();
  }

  Future<void> _loadAirports() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      final List<Map<String, String>> airportList =
          await _flightController.fetchAirports();

      if (airportList.isEmpty) {
        throw Exception('No airports found. Please try again later.');
      }

      setState(() {
        airports = airportList;
        filteredAirports = List.from(airportList);
        isLoading = false;
      });
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      if (mounted) {
        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: AppColors.redCA0,
          colorText: AppColors.white,
          duration: const Duration(seconds: 5),
        );
      }
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _fromController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _filterAirports(_fromController.text);
    });
  }

  void _filterAirports(String query) {
    query = query.toLowerCase();
    setState(() {
      filteredAirports = airports
          .where((airport) =>
              (airport['name']?.toLowerCase().contains(query) ?? false) ||
              (airport['code']?.toLowerCase().contains(query) ?? false) ||
              (airport['city']?.toLowerCase().contains(query) ?? false))
          .toList();
    });
  }

  void _selectAirport(String name, String code) {
    try {
      final flightController = Get.find<FlightController>();
      var params = flightController.getLastSearchParams();
      params['fromAirport'] = code;

      Get.back(result: {'stationName': name, 'stationCode': code});
    } catch (_) {
      Get.back(result: null);
    }
  }

  Color _getBackgroundColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark
        ? AppColors.cardBackground
        : AppColors.white;

  Color _getCardColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark
        ? AppColors.cardBackground
        : AppColors.white;

  Color _getTextColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark
        ? AppColors.white
        : AppColors.black2E2;

  Color _getHintColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark
        ? AppColors.greyB8B
        : AppColors.grey717;

  @override
  Widget build(BuildContext context) => Scaffold(
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
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.grey363.withOpacity(0.3)
                            : AppColors.greyEEE.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.black.withOpacity(0.1)
                                : Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.arrow_back, color: Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.grey717,),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Select Departure City',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Search Box Card
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.grey363.withOpacity(0.3)
                      : AppColors.greyEEE.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.grey363.withOpacity(0.1)
                          : AppColors.greyEEE.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.flight_takeoff_rounded,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.redCA0.withOpacity(0.8)
                          : AppColors.redCA0,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _fromController,
                        autofocus: true,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.white
                              : AppColors.black2E2,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search city or airport name',
                          hintStyle: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.white.withOpacity(0.7)
                                : AppColors.grey2E2,
                          ),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) => _filterAirports(value),
                      ),
                    ),
                    if (_fromController.text.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.clear,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.white.withOpacity(0.7)
                                : AppColors.grey717),
                        onPressed: () {
                          _fromController.clear();
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

              // Airport List
              Expanded(
                child: isLoading
                    ? Center(
                        child: LoadingAnimationWidget.dotsTriangle(
                          color: AppColors.redCA0,
                          size: 50,
                        ),
                      )
                    : hasError
                        ? Center(
                            child: Text(
                              'Error loading airports.',
                              style: GoogleFonts.poppins(
                                color: _getHintColor(context),
                                fontSize: 14,
                              ),
                            ),
                          )
                        : filteredAirports.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.airplanemode_inactive,
                                      size: 50,
                                      color: AppColors.grey717.withOpacity(0.5),
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
                                        color: AppColors.grey717.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                itemCount: filteredAirports.length,
                                separatorBuilder: (_, __) => Divider(
                                  color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[800]!
                            : AppColors.greyE8E,
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
                                            child: const Icon(
                                              Icons.flight_takeoff_rounded,
                                              color: AppColors.redCA0,
                                              size: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                              ),
              ),
            ],
          ),
        ),
      ),
    );
}