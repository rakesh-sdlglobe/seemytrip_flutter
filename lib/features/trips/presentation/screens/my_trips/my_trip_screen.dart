import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../features/trips/presentation/controllers/my_trip_controller.dart';
import '../../../../../features/trips/presentation/screens/my_trips/cancelled_trip_screen.dart';
import '../../../../../features/trips/presentation/screens/my_trips/upcoming_trip_screen.dart';

class MyTripScreen extends StatelessWidget {
  MyTripScreen({Key? key}) : super(key: key);

  final MyTripTabController myTripTabController =
      Get.put(MyTripTabController());

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark 
          ? AppColors.backgroundDark 
          : AppColors.whiteF2F,
      appBar: _buildModernAppBar(context),
      body: Column(
        children: [
          _buildModernTabBar(context),
          Expanded(
            child: TabBarView(
              controller: myTripTabController.controller,
              children: [
                UpComingTripScreen(),
                CancelledTripScreen(),
                _buildEmptyState(context, 'completed'.tr, Icons.check_circle_outline),
                _buildEmptyState(context, 'unsuccessful'.tr, Icons.cancel_outlined),
              ],
            ),
          ),
        ],
      ),
    );

  PreferredSizeWidget _buildModernAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AppBar(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.whiteF2F,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: true,
      leading: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark 
              ? AppColors.surfaceDark.withValues(alpha: 0.8)
              : AppColors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          border: isDark 
              ? Border.all(color: AppColors.borderDark.withValues(alpha: 0.3))
              : null,
          boxShadow: [
            BoxShadow(
              color: isDark 
                  ? AppColors.shadowDark.withValues(alpha: 0.2)
                  : AppColors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => Get.back(),
          borderRadius: BorderRadius.circular(12),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? AppColors.textPrimaryDark : AppColors.black2E2,
            size: 18,
          ),
        ),
      ),
      title: CommonTextWidget.PoppinsBold(
        text: 'myTrips'.tr,
        color: isDark ? AppColors.textPrimaryDark : AppColors.black2E2,
        fontSize: 20,
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: isDark 
                ? AppColors.surfaceDark.withValues(alpha: 0.8)
                : AppColors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12),
            border: isDark 
                ? Border.all(color: AppColors.borderDark.withValues(alpha: 0.3))
                : null,
            boxShadow: [
              BoxShadow(
                color: isDark 
                    ? AppColors.shadowDark.withValues(alpha: 0.2)
                    : AppColors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              // Refresh functionality
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.refresh_rounded,
                color: isDark ? AppColors.textPrimaryDark : AppColors.black2E2,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernTabBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDark 
            ? Border.all(color: AppColors.borderDark.withValues(alpha: 0.3))
            : null,
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? AppColors.shadowDark.withValues(alpha: 0.3)
                : AppColors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        isScrollable: true,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        tabs: myTripTabController.myTabs.map((tab) => _buildModernTab(tab, isDark)).toList(),
        unselectedLabelColor: isDark ? AppColors.textSecondaryDark : AppColors.grey5F5,
        labelStyle: TextStyle(
          fontFamily: 'PoppinsSemiBold', 
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'PoppinsMedium', 
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        labelColor: AppColors.redCA0,
        controller: myTripTabController.controller,
        indicator: BoxDecoration(
          color: AppColors.redCA0.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
      ),
    );
  }

  Widget _buildModernTab(Tab tab, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        tab.text!,
        style: TextStyle(
          fontFamily: 'PoppinsMedium',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.textSecondaryDark : AppColors.grey5F5,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String title, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark 
                    ? AppColors.surfaceDark.withValues(alpha: 0.5)
                    : AppColors.redCA0.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: isDark ? AppColors.textSecondaryDark : AppColors.redCA0,
              ),
            ),
            SizedBox(height: 24),
            CommonTextWidget.PoppinsBold(
              text: 'No $title Trips',
              color: isDark ? AppColors.textPrimaryDark : AppColors.black2E2,
              fontSize: 18,
            ),
            SizedBox(height: 8),
            CommonTextWidget.PoppinsRegular(
              text: 'Your $title trips will appear here',
              color: isDark ? AppColors.textSecondaryDark : AppColors.grey656,
              fontSize: 14,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.redCA0,
                borderRadius: BorderRadius.circular(25),
              ),
              child: CommonTextWidget.PoppinsMedium(
                text: 'Book a Trip',
                color: AppColors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
