import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../controllers/flight_controller.dart';

class FlightFromScreen extends StatefulWidget {
  @override
  _FlightFromScreenState createState() => _FlightFromScreenState();
}

class _FlightFromScreenState extends State<FlightFromScreen> {
  final FlightController _flightController = Get.put(FlightController());
  bool _isEditingFrom = false;
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

      // Fetch airports from the controller
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
          duration: Duration(seconds: 5),
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
    _debounce = Timer(Duration(milliseconds: 300), () {
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

  void _selectAirport(String airportName, String airportCode) {
    try {
      final flightController = Get.find<FlightController>();
      var params = flightController.getLastSearchParams();
      params['fromAirport'] = airportCode; // correct
      Get.back(result: {
        'stationName': airportName,
        'stationCode': airportCode,
      });
    } catch (e) {
      Get.back(result: null);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.greyE8E, width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child:
                            Icon(Icons.arrow_back, color: Theme.of(context).textTheme.bodyLarge?.color, size: 20),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsMedium(
                            text: 'From',
                            color: AppColors.redCA0,
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
                                      hintText: 'Enter any City/Airport Name',
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
                                        ? 'Enter any City/Airport Name'
                                        : _fromController.text,
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
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
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 12,
              ),
              Expanded(
                child: isLoading
                    ? Center(
                      child: LoadingAnimationWidget.dotsTriangle(
                      color: AppColors.redCA0,
                        size: 50,
                      )
                      )
                    : hasError
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
                                  final name =
                                      airport['name'] ?? 'Unknown Airport';

                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: AppColors.black2E2,
                                          fontSize: 16,
                                        ),
                                        children: [
                                          TextSpan(text: '$city '),
                                          TextSpan(
                                            text: '($code)',
                                            style: TextStyle(
                                              color: Theme.of(context).textTheme.bodyMedium?.color,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    subtitle: CommonTextWidget.PoppinsRegular(
                                      text: name,
                                      color: Theme.of(context).textTheme.bodyMedium?.color,
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
