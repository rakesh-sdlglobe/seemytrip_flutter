import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seemytrip/Controller/roomsGuest_controller.dart';
import 'package:seemytrip/Controller/search_city_controller.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/rooms_and_guest_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/search_city_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/HotelAndHomeStayScreens/select_checkin_date_screen.dart';

// Design Constants
const Color _primaryColor = Color(0xFFCA0B0B);
const Color _textPrimary = Color(0xFF2D2D2D);
const Color _textSecondary = Color(0xFF666666);

class UpTo5RoomsScreen extends StatelessWidget {
  UpTo5RoomsScreen({Key? key}) : super(key: key);

  // Use Get.find() to locate existing controllers. This is safer.
  // Ensure these controllers are put() in a parent widget or a Bindings class.
  final SearchCityController _searchCtrl = Get.put(SearchCityController());
  final RoomsGuestController _roomsGuestController =
      Get.put(RoomsGuestController());

  /// Navigates to the date selection screen and updates the state.
  Future<void> _selectDates() async {
    final result = await Get.to<Map<String, dynamic>>(
      () => SelectCheckInDateScreen(
        initialStartDate: _searchCtrl.checkInDate.value,
        initialEndDate: _searchCtrl.checkOutDate.value,
      ),
    );

    if (result != null &&
        result['startDate'] != null &&
        result['endDate'] != null) {
      _searchCtrl.checkInDate.value = result['startDate'] as DateTime?;
      _searchCtrl.checkOutDate.value = result['endDate'] as DateTime?;
    }
  }

  /// Builds a reusable, animated search card.
  Widget _buildSearchCard({
    required VoidCallback onTap,
    required String title,
    required String subtitle,
    required IconData icon,
    bool showDivider = false,
    bool isHalfWidth = false,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        width: isHalfWidth ? null : double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            // CORRECTED: Replaced non-existent .withValues() with .withOpacity()
            splashColor: _primaryColor.withOpacity(0.1),
            highlightColor: _primaryColor.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_primaryColor, _primaryColor.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.toUpperCase(),
                          style: TextStyle(
                            color: _textSecondary.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: _textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (showDivider) ...[
                    // This logic remains for the city card if needed
                    Container(
                      width: 1,
                      height: 36,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      color: Colors.grey.shade200,
                    ),
                    Text(
                      _searchCtrl.selectedCity.value?.country ?? 'India',
                      style: TextStyle(
                        // CORRECTED: .withValues() to .withOpacity()
                        color: _textSecondary.withOpacity(0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(width: 12),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: _primaryColor,
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
        final bool isSearchEnabled = _searchCtrl.selectedCity.value != null &&
            _searchCtrl.checkInDate.value != null &&
            _searchCtrl.checkOutDate.value != null &&
            _roomsGuestController.roomGuestData.isNotEmpty;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
          child: Column(
            children: [
              // 1. City Selection Card
              _buildSearchCard(
                onTap: () => Get.to(() => SearchCityScreen()),
                title: 'Destination',
                subtitle: _searchCtrl.selectedCity.value?.name ??
                    'Select city or hotel',
                icon: Icons.location_on_outlined,
                showDivider: true,
              ),

              // 2. CORRECTED: Restored the original two-card date selection UI
              Row(
                children: [
                  Expanded(
                    child: _buildSearchCard(
                      onTap: _selectDates,
                      title: 'Check-in',
                      subtitle: _searchCtrl.checkInDate.value == null
                          ? 'Add date'
                          : DateFormat('EEE, dd MMM')
                              .format(_searchCtrl.checkInDate.value!),
                      icon: Icons.calendar_today_outlined,
                      isHalfWidth: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSearchCard(
                      onTap: _selectDates,
                      title: 'Check-out',
                      subtitle: _searchCtrl.checkOutDate.value == null
                          ? 'Add date'
                          : DateFormat('EEE, dd MMM')
                              .format(_searchCtrl.checkOutDate.value!),
                      icon: Icons.calendar_today_outlined,
                      isHalfWidth: true,
                    ),
                  ),
                ],
              ),

              // 3. Rooms & Guests Card
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

              // 4. Search Button
              _buildSearchButton(isSearchEnabled),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSearchButton(bool isEnabled) {
    return Material(
      color: isEnabled ? _primaryColor : Colors.grey.shade400,
      borderRadius: BorderRadius.circular(16),
      elevation: isEnabled ? 4 : 0,
      shadowColor: _primaryColor.withOpacity(0.3),
      child: InkWell(
        onTap: (isEnabled && !_searchCtrl.isLoading.value)
            ? () =>
                _searchCtrl.performSearch(_roomsGuestController.roomGuestData)
            : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Center(
            child: _searchCtrl.isLoading.value
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_rounded, color: Colors.white, size: 22),
                      SizedBox(width: 10),
                      Text(
                        'SEARCH HOTELS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
