import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../controllers/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key}) : super(key: key);
  
  final NotificationController notificationController = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark 
          ? AppColors.backgroundDark 
          : AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          borderRadius: BorderRadius.circular(12),
          child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: 'Notification',
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: Obx(() {
        if (notificationController.isLoading.value) {
          return _buildLoadingState(context);
        } else if (notificationController.errorMessage.value.isNotEmpty) {
          return _buildErrorState(context);
        } else if (notificationController.notifications.isEmpty) {
          return _buildEmptyState(context);
        } else {
          return _buildNotificationList(context);
        }
      }),
    );

  Widget _buildEmptyState(BuildContext context) {
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
                    ? AppColors.cardDark.withValues(alpha: 0.5)
                    : AppColors.greyE8E.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_outlined,
                size: 64,
                color: isDark 
                    ? AppColors.textSecondaryDark 
                    : AppColors.grey717,
              ),
            ),
            SizedBox(height: 24),
            CommonTextWidget.PoppinsSemiBold(
              text: 'No Notifications',
              color: isDark 
                  ? AppColors.textPrimaryDark 
                  : AppColors.black2E2,
              fontSize: 20,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            CommonTextWidget.PoppinsRegular(
              text: 'You\'re all caught up! We\'ll notify you when something important happens.',
              color: isDark 
                  ? AppColors.textSecondaryDark 
                  : AppColors.grey717,
              fontSize: 14,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.redCA0.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.redCA0.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: CommonTextWidget.PoppinsMedium(
                text: 'Check back later',
                color: AppColors.redCA0,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return RefreshIndicator(
      onRefresh: () => notificationController.refreshNotifications(),
      child: ListView.builder(
        itemCount: notificationController.notifications.length,
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 16),
        itemBuilder: (context, index) {
          final notification = notificationController.notifications[index];
        
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: isDark 
                ? AppColors.cardDark 
                : AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: isDark 
                    ? AppColors.black262.withValues(alpha: 0.1)
                    : AppColors.black262.withValues(alpha: 0.05),
                blurRadius: 8,
                spreadRadius: 0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.redCA0.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        notificationController.getNotificationIcon(notification['type'] ?? ''),
                        height: 20, 
                        width: 20,
                        color: AppColors.redCA0,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.notifications,
                          color: AppColors.redCA0,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsSemiBold(
                            text: notification['title'] ?? notification['message'] ?? 'Notification',
                            color: isDark 
                                ? AppColors.textPrimaryDark 
                                : AppColors.black2E2,
                            fontSize: 14,
                          ),
                          SizedBox(height: 4),
                          CommonTextWidget.PoppinsMedium(
                            text: notification['subtitle'] ?? notification['type'] ?? '',
                            color: isDark 
                                ? AppColors.textSecondaryDark 
                                : AppColors.grey717,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ),
                    if (notification['is_read'] != true)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.redCA0,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CommonTextWidget.PoppinsMedium(
                          text: 'New',
                          color: AppColors.white,
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
                if (notification['body'] != null && notification['body'].toString().isNotEmpty) ...[
                  SizedBox(height: 12),
                  CommonTextWidget.PoppinsRegular(
                    text: notification['body'] ?? notification['description'] ?? '',
                    color: isDark 
                        ? AppColors.textSecondaryDark 
                        : AppColors.grey717,
                    fontSize: 13,
                  ),
                ],
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonTextWidget.PoppinsRegular(
                      text: notificationController.getTimeAgo(notification['created_at'] ?? notification['timestamp'] ?? ''),
                      color: isDark 
                          ? AppColors.textSecondaryDark 
                          : AppColors.grey717,
                      fontSize: 11,
                    ),
                    InkWell(
                      onTap: () {
                        // Mark as read and handle notification tap
                        if (notification['is_read'] != true) {
                          notificationController.markAsRead(notification['id'] ?? '');
                        }
                        _handleNotificationTap(notification);
                      },
                      child: CommonTextWidget.PoppinsMedium(
                        text: 'View',
                        color: AppColors.redCA0,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.redCA0,
          ),
          SizedBox(height: 16),
          CommonTextWidget.PoppinsMedium(
            text: 'Loading notifications...',
            color: isDark 
                ? AppColors.textSecondaryDark 
                : AppColors.grey717,
            fontSize: 14,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.redCA0,
            ),
            SizedBox(height: 16),
            CommonTextWidget.PoppinsSemiBold(
              text: 'Error Loading Notifications',
              color: isDark 
                  ? AppColors.textPrimaryDark 
                  : AppColors.black2E2,
              fontSize: 18,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            CommonTextWidget.PoppinsRegular(
              text: notificationController.errorMessage.value,
              color: isDark 
                  ? AppColors.textSecondaryDark 
                  : AppColors.grey717,
              fontSize: 14,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => notificationController.refreshNotifications(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.redCA0,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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

  void _handleNotificationTap(Map<String, dynamic> notification) {
    // Handle different notification types
    final type = notification['type'] ?? '';
    final data = notification['data'] ?? {};
    
    switch (type.toLowerCase()) {
      case 'booking':
      case 'reservation':
        // Navigate to booking details
        if (data['booking_id'] != null) {
          // Get.toNamed('/booking-details', arguments: data['booking_id']);
          print('Navigate to booking: ${data['booking_id']}');
        }
        break;
      case 'payment':
      case 'transaction':
        // Navigate to transaction details
        if (data['transaction_id'] != null) {
          // Get.toNamed('/transaction-details', arguments: data['transaction_id']);
          print('Navigate to transaction: ${data['transaction_id']}');
        }
        break;
      case 'cancellation':
        // Navigate to cancellation details
        if (data['cancellation_id'] != null) {
          // Get.toNamed('/cancellation-details', arguments: data['cancellation_id']);
          print('Navigate to cancellation: ${data['cancellation_id']}');
        }
        break;
      default:
        // Show notification details
        Get.snackbar(
          'Notification',
          notification['title'] ?? notification['message'] ?? 'Notification details',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.redCA0,
          colorText: AppColors.white,
        );
    }
  }
}