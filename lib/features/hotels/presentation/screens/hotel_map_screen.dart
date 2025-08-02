import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

/// A simple model for type safety.
class Location {
  final String name;
  final double latitude;
  final double longitude;

  Location({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  /// Factory constructor that correctly parses the nested JSON structure.
  factory Location.fromMap(Map<String, dynamic> map) {
    final addressMap = map['HotelAddress'] as Map<String, dynamic>?;
    double lat = 0.0;
    double lng = 0.0;

    if (addressMap != null) {
      lat = _extractCoordinate(addressMap, ['Latitude']);
      lng = _extractCoordinate(addressMap, ['Longitude']);
    }

    return Location(
      name: map['HotelName']?.toString() ?? 'Unknown Hotel',
      latitude: lat,
      longitude: lng,
    );
  }

  /// Helper method to safely extract and parse a coordinate value.
  static double _extractCoordinate(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      if (map.containsKey(key) && map[key] != null) {
        return double.tryParse(map[key].toString()) ?? 0.0;
      }
    }
    return 0.0;
  }
}

class HotelMapScreen extends StatefulWidget {
  final List<Location> locations;

  const HotelMapScreen({Key? key, required this.locations}) : super(key: key);

  @override
  _HotelMapScreenState createState() => _HotelMapScreenState();
}

class _HotelMapScreenState extends State<HotelMapScreen> {
  late MapController mapController;
  // ✅ ADDED: State to track the currently selected location
  Location? _selectedLocation;

  @override
  void initState() {
    super.initState();
    mapController = MapController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fitBounds();
      }
    });
  }

  /// ✅ ADDED: Helper method to fit the map to show all markers.
  void _fitBounds() {
    final validLocations = widget.locations
        .where((loc) => loc.latitude != 0.0 && loc.longitude != 0.0)
        .toList();

    if (validLocations.isNotEmpty) {
      final bounds = LatLngBounds.fromPoints(
        validLocations.map((loc) => LatLng(loc.latitude, loc.longitude)).toList(),
      );
      mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.all(50.0),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final validLocations = widget.locations
        .where((loc) => loc.latitude != 0.0 && loc.longitude != 0.0)
        .toList();

    if (validLocations.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('No Locations Available')),
        body: const Center(child: Text('No valid hotel locations were found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Locations'),
        backgroundColor: redCA0,
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        foregroundColor: white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      // ✅ MODIFIED: Using a Stack to overlay controls on the map
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(validLocations.first.latitude, validLocations.first.longitude),
              initialZoom: 12.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.yourcompany.yourappname',
              ),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    '© OpenStreetMap contributors',
                    onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                  ),
                  TextSourceAttribution(
                    '© CARTO',
                    onTap: () => launchUrl(Uri.parse('https://carto.com/attributions')),
                  ),
                ],
              ),
              MarkerLayer(
                markers: validLocations.map((location) {
                  // ✅ ADDED: Check if the current marker is the selected one
                  final isSelected = _selectedLocation == location;
                  return Marker(
                    width: 150.0,
                    height: 90.0, // Increased height for selection effect
                    point: LatLng(location.latitude, location.longitude),
                    child: GestureDetector(
                      onTap: () {
                        // ✅ ADDED: Update state when a marker is tapped
                        setState(() {
                          _selectedLocation = location;
                        });
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            // ✅ MODIFIED: Icon color and size change on selection
                            child: Icon(
                              Icons.location_on,
                              color: isSelected ? Colors.blue.shade700 : Colors.red,
                              size: isSelected ? 50 : 40,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1))
                              ],
                            ),
                            child: Text(
                              location.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          // ✅ ADDED: Map UI controls (Zoom and Reset)
          Positioned(
            right: 16,
            bottom: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoom_in',
                  mini: true,
                  onPressed: () {
                    mapController.move(mapController.camera.center, mapController.camera.zoom + 1);
                  },
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoom_out',
                  mini: true,
                  onPressed: () {
                    mapController.move(mapController.camera.center, mapController.camera.zoom - 1);
                  },
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'reset_view',
                  mini: true,
                  onPressed: _fitBounds, // Re-centers the map to show all markers
                  child: const Icon(Icons.fullscreen),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}