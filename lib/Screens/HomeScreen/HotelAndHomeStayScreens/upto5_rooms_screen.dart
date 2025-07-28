import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seemytrip/Controller/search_city_controller.dart';
import 'package:seemytrip/Controller/roomsGuest_controller.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/rooms_and_guest_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/search_city_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/select_checkin_date_screen.dart';

// Design Constants
const Color _primaryColor = Color(0xFFCA0B0B);
const Color _cardColor = Colors.white;
const Color _textPrimary = Color(0xFF2D2D2D);
const Color _textSecondary = Color(0xFF666666);
const Color _borderColor = Color(0xFFE0E0E0);
const double _cardElevation = 2.0;
const double _borderRadius = 12.0;

class UpTo5RoomsScreen extends StatelessWidget {
  UpTo5RoomsScreen({Key? key}) : super(key: key);

  // find the shared controller
  final SearchCityController _searchCtrl = Get.put(SearchCityController());
  final RoomsGuestController _roomsGuestController =
      Get.put(RoomsGuestController());

  // Build an engaging search card widget with modern UI elements
  Widget _buildSearchCard({
    required VoidCallback onTap,
    required String title,
    required String subtitle,
    required IconData icon,
    bool showDivider = false,
    bool isHalfWidth = false,
  }) {
    // Add a subtle animation for the card
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        width: isHalfWidth ? null : double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _primaryColor.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 6),
              spreadRadius: 1,
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            splashColor: _primaryColor.withValues(alpha: 0.1),
            highlightColor: _primaryColor.withValues(alpha: 0.05),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  // Icon with gradient background
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _primaryColor.withOpacity(0.9),
                          _primaryColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title with subtle animation
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            color: _textSecondary.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                          child: Text(
                            title.toUpperCase(),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Subtitle with better typography
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: _textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Right side elements
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showDivider)
                        Container(
                          width: 1,
                          height: 36,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.grey.shade300,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      if (showDivider)
                        Obx(() {
                          final city = _searchCtrl.selectedCity.value;
                          return Text(
                            city?.country ?? 'India',
                            style: TextStyle(
                              color: _textSecondary.withValues(alpha: 0.8),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }),
                      const SizedBox(width: 12),
                      // Animated chevron icon
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 300),
                        builder: (context, value, child) {
                          return Transform.rotate(
                            angle: value * 0.5,
                            child: child,
                          );
                        },
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: _primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Obx(() {
        // ADDED: A reactive flag to determine if the search button should be enabled.
        final bool isSearchEnabled = _searchCtrl.selectedCity.value != null &&
            _searchCtrl.checkInDate.value != null &&
            _searchCtrl.checkOutDate.value != null &&
            _roomsGuestController.roomGuestData.isNotEmpty;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Card
              _buildSearchCard(
                onTap: () => Get.to(() => SearchCityScreen()),
                title: 'Where to?',
                subtitle: _searchCtrl.selectedCity.value?.name ??
                    'Select city or hotel',
                icon: Icons.location_on_outlined,
                showDivider: true,
              ),
              const SizedBox(height: 12),

              // Check-in/Check-out Row
              Row(
                children: [
                  Expanded(
                    child: _buildSearchCard(
                      onTap: () async {
                        final result =
                            await Get.to(() => SelectCheckInDateScreen());
                        if (result is Map<String, dynamic>) {
                          _searchCtrl.checkInDate.value = result['startDate'];
                          _searchCtrl.checkOutDate.value = result['endDate'];
                        }
                      },
                      title: 'Check-in',
                      subtitle: _searchCtrl.checkInDate.value == null
                          ? 'Add date'
                          : DateFormat('EEE, MMM d')
                              .format(_searchCtrl.checkInDate.value!),
                      icon: Icons.calendar_today_outlined,
                      isHalfWidth: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSearchCard(
                      onTap: () async {
                        final result =
                            await Get.to(() => SelectCheckInDateScreen());
                        if (result is Map<String, dynamic>) {
                          _searchCtrl.checkInDate.value = result['startDate'];
                          _searchCtrl.checkOutDate.value = result['endDate'];
                        }
                      },
                      title: 'Check-out',
                      subtitle: _searchCtrl.checkOutDate.value == null
                          ? 'Add date'
                          : DateFormat('EEE, MMM d')
                              .format(_searchCtrl.checkOutDate.value!),
                      icon: Icons.calendar_today_outlined,
                      isHalfWidth: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              const SizedBox(height: 16),

              // Rooms & Guests card
              _buildSearchCard(
                onTap: () async {
                  final result = await Get.bottomSheet(
                    RoomsAndGuestScreen(
                      roomGuestData: _roomsGuestController.roomGuestData,
                    ),
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                  );
                  if (result is List<Map<String, dynamic>>) {
                    _roomsGuestController.onDone(result);
                  }
                },
                title: 'Rooms & Guests',
                subtitle: _roomsGuestController.subtitleSummary,
                icon: Icons.people_outline,
              ),

              const SizedBox(height: 24),

              // CHANGED: The entire search button logic is updated.
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 400),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.98 + (0.02 * value),
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        // Dim the shadow if disabled
                        color: isSearchEnabled
                            ? _primaryColor.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Material(
                    // Use grey color when disabled
                    color:
                        isSearchEnabled ? _primaryColor : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      // Disable onTap if not enabled or if loading
                      onTap: (isSearchEnabled && !_searchCtrl.isLoading.value)
                          ? () async {
                              // SIMPLIFIED: Delegate the entire process to the controller.
                              await _searchCtrl.performSearch(
                                  _roomsGuestController.roomGuestData);
                            }
                          : null,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Center(
                          // Show loader or text based on controller's loading state
                          child: _searchCtrl.isLoading.value
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.search_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'SEARCH HOTELS',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                        shadows: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            offset: const Offset(0, 1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }
}
