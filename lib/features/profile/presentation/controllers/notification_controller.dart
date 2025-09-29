import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends GetxController {
  // Observable list for notifications
  var notifications = <Map<String, dynamic>>[].obs;
  
  // Loading state
  var isLoading = false.obs;
  
  // Error state
  var errorMessage = ''.obs;
  
  // Unread count
  var unreadCount = 0.obs;
  
  // Toggle for mock data (set to false when API is ready)
  static const bool useMockData = true;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  // Fetch notifications from API
  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      if (useMockData) {
        // Use mock data for testing
        await _loadMockNotifications();
      } else {
        // Use real API
        await _fetchFromAPI();
      }
    } catch (e) {
      print('❌ Error fetching notifications: $e');
      errorMessage.value = 'Network error. Please check your connection.';
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch from real API
  Future<void> _fetchFromAPI() async {
    final token = await _getAuthToken();
    if (token == null) {
      errorMessage.value = 'Please login to view notifications';
      return;
    }

    final response = await http.get(
      Uri.parse(AppConfig.getNotifications),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('📥 Notifications API Response: ${response.statusCode}');
    print('📥 Notifications Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['success'] == true && data['data'] != null) {
        notifications.value = List<Map<String, dynamic>>.from(data['data']);
        _updateUnreadCount();
      } else {
        errorMessage.value = data['message'] ?? 'Failed to fetch notifications';
      }
    } else if (response.statusCode == 401) {
      errorMessage.value = 'Session expired. Please login again.';
    } else {
      final errorData = json.decode(response.body);
      errorMessage.value = errorData['message'] ?? 'Failed to fetch notifications';
    }
  }

  // Mock data for testing - Remove when API is ready
  Future<void> _loadMockNotifications() async {
    // Simulate API delay
    await Future.delayed(Duration(seconds: 1));
    
    notifications.value = [
      {
        'id': '1',
        'title': 'Booking Confirmed!',
        'subtitle': 'Flight Booking',
        'body': 'Your flight from Delhi to Mumbai has been confirmed. Booking ID: FL123456',
        'type': 'booking',
        'is_read': false,
        'created_at': DateTime.now().subtract(Duration(minutes: 5)).toIso8601String(),
        'data': {'booking_id': 'FL123456'}
      },
      {
        'id': '2',
        'title': 'Payment Successful',
        'subtitle': 'Credit Card Transaction',
        'body': 'Payment of ₹15,000 has been processed successfully for your hotel booking.',
        'type': 'payment',
        'is_read': false,
        'created_at': DateTime.now().subtract(Duration(hours: 2)).toIso8601String(),
        'data': {'transaction_id': 'TXN789012'}
      },
      {
        'id': '3',
        'title': 'Booking Cancelled',
        'subtitle': 'Train Booking',
        'body': 'Your train booking from Mumbai to Pune has been cancelled. Refund will be processed within 3-5 business days.',
        'type': 'cancellation',
        'is_read': true,
        'created_at': DateTime.now().subtract(Duration(hours: 6)).toIso8601String(),
        'data': {'booking_id': 'TR345678'}
      },
      {
        'id': '4',
        'title': 'Reminder: Check-in Tomorrow',
        'subtitle': 'Hotel Booking',
        'body': 'Don\'t forget! Your hotel check-in is tomorrow at 2:00 PM. Have a great stay!',
        'type': 'reminder',
        'is_read': false,
        'created_at': DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
        'data': {'booking_id': 'HT901234'}
      },
      {
        'id': '5',
        'title': 'Special Offer Available!',
        'subtitle': 'Promotion',
        'body': 'Get 20% off on your next flight booking. Use code SAVE20. Valid until this weekend.',
        'type': 'promotion',
        'is_read': true,
        'created_at': DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
        'data': {'promo_code': 'SAVE20'}
      }
    ];
    
    _updateUnreadCount();
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return;

      final response = await http.put(
        Uri.parse('${AppConfig.baseUrl}/notifications/$notificationId/read'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Update local notification status
        final index = notifications.indexWhere((n) => n['id'] == notificationId);
        if (index != -1) {
          notifications[index]['is_read'] = true;
          notifications.refresh();
          _updateUnreadCount();
        }
      }
    } catch (e) {
      print('❌ Error marking notification as read: $e');
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final token = await _getAuthToken();
      if (token == null) return;

      final response = await http.put(
        Uri.parse(AppConfig.markAllNotificationsRead),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Update all notifications as read
        for (var notification in notifications) {
          notification['is_read'] = true;
        }
        notifications.refresh();
        unreadCount.value = 0;
      }
    } catch (e) {
      print('❌ Error marking all notifications as read: $e');
    }
  }

  // Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      final token = await _getAuthToken();
      if (token == null) return;

      final response = await http.delete(
        Uri.parse('${AppConfig.baseUrl}/notifications/$notificationId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        notifications.removeWhere((n) => n['id'] == notificationId);
        _updateUnreadCount();
      }
    } catch (e) {
      print('❌ Error deleting notification: $e');
    }
  }

  // Refresh notifications
  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }

  // Get auth token
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Update unread count
  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => n['is_read'] != true).length;
  }

  // Get notification by ID
  Map<String, dynamic>? getNotificationById(String id) {
    try {
      return notifications.firstWhere((n) => n['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Filter notifications by type
  List<Map<String, dynamic>> getNotificationsByType(String type) {
    return notifications.where((n) => n['type'] == type).toList();
  }

  // Get recent notifications (last 7 days)
  List<Map<String, dynamic>> getRecentNotifications() {
    final now = DateTime.now();
    final weekAgo = now.subtract(Duration(days: 7));
    
    return notifications.where((n) {
      final createdAt = DateTime.tryParse(n['created_at'] ?? '');
      return createdAt != null && createdAt.isAfter(weekAgo);
    }).toList();
  }

  // Format time ago
  String getTimeAgo(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} min ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  // Get notification icon based on type
  String getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'booking':
      case 'reservation':
        return 'assets/images/booking_icon.png';
      case 'payment':
      case 'transaction':
        return 'assets/images/payment_icon.png';
      case 'cancellation':
        return 'assets/images/cancel_icon.png';
      case 'reminder':
        return 'assets/images/reminder_icon.png';
      case 'promotion':
        return 'assets/images/promotion_icon.png';
      default:
        return 'assets/images/notification_icon.png';
    }
  }

  // Get notification color based on type
  String getNotificationColor(String type) {
    switch (type.toLowerCase()) {
      case 'booking':
      case 'reservation':
        return '#4CAF50'; // Green
      case 'payment':
      case 'transaction':
        return '#2196F3'; // Blue
      case 'cancellation':
        return '#F44336'; // Red
      case 'reminder':
        return '#FF9800'; // Orange
      case 'promotion':
        return '#9C27B0'; // Purple
      default:
        return '#757575'; // Grey
    }
  }
}
