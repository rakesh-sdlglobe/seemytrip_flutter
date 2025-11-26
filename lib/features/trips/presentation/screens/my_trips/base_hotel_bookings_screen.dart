import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../main.dart';
import '../../../../../features/auth/presentation/controllers/login_controller.dart';
import '../../../../../features/hotels/presentation/controllers/hotel_controller.dart';
import '../../widgets/hotel_booking_card.dart';

abstract class BaseHotelBookingsScreen extends StatefulWidget {
  const BaseHotelBookingsScreen({Key? key}) : super(key: key);
}

abstract class BaseHotelBookingsScreenState<T extends BaseHotelBookingsScreen> extends State<T> {
  late final SearchCityController hotelController;
  late final LoginController loginController;
  
  List<Map<String, dynamic>> hotelBookings = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _fetchHotelBookings();
  }

  void _initializeControllers() {
    // Initialize LoginController
    if (!Get.isRegistered<LoginController>()) {
      Get.put(LoginController());
    }
    loginController = Get.find<LoginController>();
    
    // Initialize SearchCityController (HotelController)
    if (!Get.isRegistered<SearchCityController>()) {
      Get.put(SearchCityController());
    }
    hotelController = Get.find<SearchCityController>();
  }

  Future<void> _fetchHotelBookings() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final userId = loginController.userData['id'] ?? 
                     loginController.userData['userId'];
      
      List<Map<String, dynamic>> bookings;
      if (userId != null) {
        bookings = await hotelController.getUserHotelBookings(userId as int);
      } else {
        bookings = await hotelController.getAllHotelBookings();
      }

      // Filter bookings based on tab type
      final filteredBookings = filterBookings(bookings);

      setState(() {
        hotelBookings = filteredBookings;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  // Override this method in each tab to filter bookings
  List<Map<String, dynamic>> filterBookings(List<Map<String, dynamic>> bookings);

  // Override these methods to customize empty state
  String getEmptyStateTitle();
  String getEmptyStateMessage();
  IconData getEmptyStateIcon();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.redCA0,
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.redCA0,
              ),
              SizedBox(height: 16),
              CommonTextWidget.PoppinsMedium(
                text: 'Error loading bookings',
                color: isDark ? AppColors.textPrimaryDark : AppColors.black2E2,
                fontSize: 16,
              ),
              SizedBox(height: 8),
              CommonTextWidget.PoppinsRegular(
                text: errorMessage!,
                color: isDark ? AppColors.textSecondaryDark : AppColors.grey656,
                fontSize: 14,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _fetchHotelBookings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.redCA0,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: CommonTextWidget.PoppinsMedium(
                  text: 'Retry',
                  color: AppColors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (hotelBookings.isEmpty) {
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
                  getEmptyStateIcon(),
                  size: 48,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.redCA0,
                ),
              ),
              SizedBox(height: 24),
              CommonTextWidget.PoppinsBold(
                text: getEmptyStateTitle(),
                color: isDark ? AppColors.textPrimaryDark : AppColors.black2E2,
                fontSize: 18,
              ),
              SizedBox(height: 8),
              CommonTextWidget.PoppinsRegular(
                text: getEmptyStateMessage(),
                color: isDark ? AppColors.textSecondaryDark : AppColors.grey656,
                fontSize: 14,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchHotelBookings,
      color: AppColors.redCA0,
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: hotelBookings.length,
          shrinkWrap: true,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: HotelBookingCard(
              booking: hotelBookings[index],
              isDark: isDark,
            ),
          ),
        ),
      ),
    );
  }
}

