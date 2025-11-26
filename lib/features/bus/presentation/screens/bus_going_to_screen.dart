import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../controllers/bus_controller.dart';

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
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'Select Destination City',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              onPressed: () => Get.back(),
              padding: EdgeInsets.zero,
            ),
          ),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFFFF5722)
              : const Color(0xFFCA0B0B),
          elevation: 0,
          centerTitle: true,
          foregroundColor: Colors.white,
          toolbarHeight: 60,
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
              margin: const EdgeInsets.fromLTRB(12, 10, 12, 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.05),
                    spreadRadius: 0.5,
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyLarge?.color),
                decoration: InputDecoration(
                  hintText: "Search for a city...",
                  hintStyle: TextStyle(color: Theme.of(context).hintColor, fontSize: 12),
                  prefixIcon: Icon(Icons.search_rounded, 
                    color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFFFF5722)
                      : const Color(0xFFCA0B0B),
                    size: 18),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                  isDense: true,
                ),
              ),
            ),
            
            // Available Cities Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: Row(
                children: [
                  Text(
                    'Available Cities',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: (Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFFFF5722)
                        : const Color(0xFFCA0B0B)).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Obx(() => Text(
                      '${filteredCities.length} cities',
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFFF5722)
                          : const Color(0xFFCA0B0B),
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
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: LoadingAnimationWidget.dotsTriangle(
                            color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFFFF5722)
                              : const Color(0xFFCA0B0B),
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
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
                          size: 40,
                          color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.red[400]
                            : Colors.red[300],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Failed to load',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextButton.icon(
                          onPressed: _loadCities,
                          icon: const Icon(Icons.refresh_rounded, size: 16),
                          label: const Text('Retry', style: TextStyle(fontSize: 12)),
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFFFF5722)
                              : const Color(0xFFCA0B0B),
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
                          size: 40,
                          color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[500]
                            : Colors.grey[400],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'No results',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Try different search',
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  itemCount: filteredCities.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Theme.of(context).dividerColor,
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
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: (Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFFFF5722)
                                    : const Color(0xFFCA0B0B)).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.place_rounded,
                                  color: Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFFFF5722)
                                    : const Color(0xFFCA0B0B),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  city['CityName'] ?? 'Unknown City',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
                                size: 20,
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