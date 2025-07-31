import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Controller/bus_controller.dart';

class BusGoingToScreen extends StatefulWidget {
  const BusGoingToScreen({Key? key}) : super(key: key);

  @override
  State<BusGoingToScreen> createState() => _BusGoingToScreenState();
}

class _BusGoingToScreenState extends State<BusGoingToScreen> {
  final BusController controller = Get.find<BusController>();
  final TextEditingController searchController = TextEditingController();
  final RxList<dynamic> filteredCities = <dynamic>[].obs;

  @override
  void initState() {
    super.initState();
    // Initialize with all cities if already loaded
    if (controller.cityList.isNotEmpty) {
      filteredCities.value = List.from(controller.cityList);
    } else {
      // If cities are not loaded yet, fetch them
      _loadCities();
    }
    searchController.addListener(_filterCities);
  }

  Future<void> _loadCities() async {
    try {
      // Access the values from Rx variables
      final tokenId = controller.tokenId.value;
      final endUserIp = controller.endUserIp.value;

      if (tokenId.isNotEmpty && endUserIp.isNotEmpty) {
        await controller.fetchCities(tokenId, endUserIp);
        // Update the filtered list after cities are loaded
        if (mounted) {
          filteredCities.value = List.from(controller.cityList);
        }
      } else {
        throw Exception('Invalid session. Please try again.');
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          e.toString().replaceAll('Exception: ', ''),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  @override
  void dispose() {
    searchController.removeListener(_filterCities);
    searchController.dispose();
    super.dispose();
  }

  void _filterCities() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredCities.value = List.from(controller.cityList);
    } else {
      filteredCities.value = controller.cityList.where((city) {
        final cityName = city['CityName']?.toString().toLowerCase() ?? '';
        return cityName.contains(query);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Select Destination City',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        backgroundColor: redCA0,
        elevation: 0,
        centerTitle: true,
        foregroundColor: white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              decoration: InputDecoration(
                hintText: "Search for a city...",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                prefixIcon: Icon(Icons.search_rounded, color: redCA0, size: 24),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          
          // Available Cities Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Available Cities',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: redCA0.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Obx(() => Text(
                    '${filteredCities.length} cities',
                    style: TextStyle(
                      fontSize: 12,
                      color: redCA0,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                ),
              ],
            ),
          ),
          
          // Cities List
          Expanded(
            child: Obx(() {
              // Show loading indicator when cities are being loaded
              if (controller.isLoading.value) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(redCA0),
                          strokeWidth: 3,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading cities...',
                        style: TextStyle(
                          fontSize: 16,
                          color: white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Show error state if loading failed
              if (controller.cityList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Failed to load cities',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _loadCities,
                        icon: const Icon(Icons.refresh_rounded, size: 20),
                        label: const Text('Retry'),
                        style: TextButton.styleFrom(
                          foregroundColor: redCA0,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Show empty state when no cities match search
              if (filteredCities.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No cities found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try a different search term',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filteredCities.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.grey[200],
                  indent: 16,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  final city = filteredCities[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Get.back(result: {
                          'name': city['CityName'],
                          'id': city['CityId'].toString(),
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: redCA0.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.place_rounded,
                                color: redCA0,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                city['CityName'] ?? 'Unknown City',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.grey[400],
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}