import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';

class HotelBookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final bool isDark;

  const HotelBookingCard({
    Key? key,
    required this.booking,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hotelName = booking['hotel_name']?.toString() ?? 'Hotel';
    final hotelImageUrl = booking['hotel_image_url']?.toString() ?? '';
    final checkInDate = booking['check_in_date']?.toString() ?? '';
    final checkOutDate = booking['check_out_date']?.toString() ?? '';
    final hotelCity = booking['hotel_city']?.toString() ?? '';
    final hotelCountry = booking['hotel_country']?.toString() ?? '';
    final bookingStatus = booking['booking_status']?.toString() ?? 'pending';
    final totalAmount = booking['total_amount'] ?? 0.0;
    final currency = booking['currency']?.toString() ?? 'AED';
    final roomName = booking['room_name']?.toString() ?? '';
    final numberOfRooms = booking['number_of_rooms'] ?? 1;
    final numberOfAdults = booking['number_of_adults'] ?? 0;
    final numberOfChildren = booking['number_of_children'] ?? 0;

    return Container(
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
                : AppColors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image section
          Container(
            height: 140,
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: isDark ? AppColors.surfaceDark : AppColors.grey5F5,
            ),
            child: Stack(
              children: [
                // Hotel image or placeholder
                if (hotelImageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Image.network(
                      hotelImageUrl,
                      width: Get.width,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: isDark ? AppColors.surfaceDark : AppColors.grey5F5,
                          child: Icon(
                            Icons.hotel,
                            size: 48,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.grey656,
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(
                    color: isDark ? AppColors.surfaceDark : AppColors.grey5F5,
                    child: Icon(
                      Icons.hotel,
                      size: 48,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.grey656,
                    ),
                  ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
                // Status badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(bookingStatus),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CommonTextWidget.PoppinsMedium(
                      text: bookingStatus.toUpperCase(),
                      color: AppColors.white,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content section
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextWidget.PoppinsBold(
                  text: hotelName,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.black2E2,
                  fontSize: 16,
                ),
                SizedBox(height: 4),
                if (hotelCity.isNotEmpty || hotelCountry.isNotEmpty)
                  CommonTextWidget.PoppinsRegular(
                    text: [hotelCity, hotelCountry].where((s) => s.isNotEmpty).join(', '),
                    color: isDark ? AppColors.textSecondaryDark : AppColors.grey656,
                    fontSize: 14,
                  ),
                if (roomName.isNotEmpty) ...[
                  SizedBox(height: 4),
                  CommonTextWidget.PoppinsRegular(
                    text: roomName,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.grey656,
                    fontSize: 13,
                  ),
                ],
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.grey656,
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: CommonTextWidget.PoppinsMedium(
                        text: checkInDate.isNotEmpty && checkOutDate.isNotEmpty
                            ? '${_formatDate(checkInDate)} - ${_formatDate(checkOutDate)}'
                            : 'Dates not available',
                        color: isDark ? AppColors.textSecondaryDark : AppColors.grey656,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 16,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.grey656,
                    ),
                    SizedBox(width: 6),
                    CommonTextWidget.PoppinsMedium(
                      text: '$numberOfRooms Room${numberOfRooms > 1 ? 's' : ''} • $numberOfAdults Adult${numberOfAdults > 1 ? 's' : ''}${numberOfChildren > 0 ? ' • $numberOfChildren Child${numberOfChildren > 1 ? 'ren' : ''}' : ''}',
                      color: isDark ? AppColors.textSecondaryDark : AppColors.grey656,
                      fontSize: 12,
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextWidget.PoppinsRegular(
                          text: 'Total Amount Paid',
                          color: isDark ? AppColors.textSecondaryDark : AppColors.grey656,
                          fontSize: 12,
                        ),
                        SizedBox(height: 2),
                        CommonTextWidget.PoppinsBold(
                          text: _formatAmount(totalAmount is num ? totalAmount.toDouble() : 0.0, currency),
                          color: isDark ? AppColors.textPrimaryDark : AppColors.black2E2,
                          fontSize: 16,
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.redCA0.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CommonTextWidget.PoppinsMedium(
                        text: 'View Details',
                        color: AppColors.redCA0,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr.split('T')[0]);
      return '${date.day} ${_getMonthName(date.month)}, ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String _formatAmount(double amount, String currency) {
    // Format amount in rupees with Indian number system
    return '₹${_formatIndianCurrency(amount)}';
  }

  String _formatIndianCurrency(double amount) {
    if (amount >= 10000000) {
      // Crores
      final crores = amount / 10000000;
      return '${crores.toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      // Lakhs
      final lakhs = amount / 100000;
      return '${lakhs.toStringAsFixed(2)} L';
    } else if (amount >= 1000) {
      // Thousands
      final thousands = amount / 1000;
      return '${thousands.toStringAsFixed(2)} K';
    } else {
      return amount.toStringAsFixed(2);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return AppColors.grey656;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

