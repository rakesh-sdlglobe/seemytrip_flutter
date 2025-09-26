import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Import global styles
import '../../../../core/widgets/common/buttons/app_button.dart';
import '../../../../core/widgets/common/cards/app_card.dart';
import '../controllers/hotel_controller.dart';
import '../controllers/roomsGuest_controller.dart';
import 'rooms_and_guest_screen.dart';
import 'search_city_screen.dart';
import 'select_checkin_date_screen.dart';

class HotelHomeScreen extends StatelessWidget {
  HotelHomeScreen({Key? key}) : super(key: key);

  // Use Get.find() to locate existing controllers. This is safer.
  // Ensure these controllers are put() in a parent widget or a Bindings class.
  final SearchCityController _searchCtrl = Get.put(SearchCityController());
  final RoomsGuestController _roomsGuestController =
      Get.put(RoomsGuestController());

  /// Navigates to the date selection screen and updates the state.
  Future<void> _selectDates() async {
    final Map<String, dynamic>? result = await Get.to<Map<String, dynamic>>(
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
    required BuildContext context,
    required VoidCallback onTap,
    required String title,
    required String subtitle,
    required IconData icon,
    bool showDivider = false,
    bool isHalfWidth = false,
  }) => TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (BuildContext context, double value, Widget? child) => Transform.scale(
          scale: value,
          child: Opacity(opacity: value, child: child),
        ),
      child: Container(
        width: isHalfWidth ? null : double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Theme.of(context).cardColor,
              Theme.of(context).scaffoldBackgroundColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Theme.of(context).dividerColor, 
            width: 1
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            // Theme-aware splash and highlight colors
            splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
            highlightColor: Theme.of(context).primaryColor.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColorDark,
                        ],
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
                      children: <Widget>[
                        Text(
                          title.toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.titleMedium?.color,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (showDivider) ...<Widget>[
                    // This logic remains for the city card if needed
                    Container(
                      width: 1,
                      height: 36,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      color: Theme.of(context).dividerColor,
                    ),
                    Text(
                      _searchCtrl.selectedCity.value?.country ?? 'India',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(width: 12),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        final bool isSearchEnabled = _searchCtrl.selectedCity.value != null &&
            _searchCtrl.checkInDate.value != null &&
            _searchCtrl.checkOutDate.value != null &&
            _roomsGuestController.roomGuestData.isNotEmpty;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
          child: Column(
            children: <Widget>[
              // 1. City Selection Card
              _buildSearchCard(
                context: context,
                onTap: () => Get.to(() => SearchCityScreen()),
                title: 'destination'.tr,
                subtitle: _searchCtrl.selectedCity.value?.name ??
                    'selectCityOrHotel'.tr,
                icon: Icons.location_on_outlined,
                showDivider: true,
              ),

              // 2. CORRECTED: Restored the original two-card date selection UI
              Column(
                children: <Widget>[
                  _buildSearchCard(
                    context: context,
                    onTap: _selectDates,
                    title: 'checkIn'.tr,
                    subtitle: _searchCtrl.checkInDate.value == null
                        ? 'addDate'.tr
                        : DateFormat('EEE, dd MMM yyyy').format(
                            _searchCtrl.checkInDate.value!),
                    icon: Icons.calendar_today_outlined,
                    isHalfWidth: true,
                  ),
                  const SizedBox(height: 12),
                  _buildSearchCard(
                    context: context,
                    onTap: _selectDates,
                    title: 'checkOut'.tr,
                    subtitle: _searchCtrl.checkOutDate.value == null
                        ? 'addDate'.tr
                        : DateFormat('EEE, dd MMM yyyy').format(
                            _searchCtrl.checkOutDate.value!),
                    icon: Icons.calendar_today_outlined,
                    isHalfWidth: true,
                  ),
                ],
              ),

              // 3. Rooms & Guests Card
              _buildSearchCard(
                context: context,
                onTap: () async {
                  final result = await Get.bottomSheet(
                    AppCard(
                      margin: const EdgeInsets.all(16),
                      child: RoomsAndGuestScreen(
                        roomGuestData: _roomsGuestController.roomGuestData,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                  );
                  if (result is List<Map<String, dynamic>>) {
                    _roomsGuestController.onDone(result);
                  }
                },
                title: 'roomsAndGuests'.tr,
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

  Widget _buildSearchButton(bool isEnabled) => AppButton(
        onPressed: (isEnabled && !_searchCtrl.isLoading.value)
            ? () => _searchCtrl.performSearch(_roomsGuestController.roomGuestData)
            : () {},
        isLoading: _searchCtrl.isLoading.value,
        text: 'searchHotels'.tr,
      );
}
