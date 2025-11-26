import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:easebuzz_flutter/easebuzz_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/config/app_config.dart';

/// Payment status enum
enum PaymentStatus {
  idle,
  initiating,
  gatewayLaunched,
  processing,
  success,
  failed,
  cancelled,
}

/// Extension to check if status is completed
extension PaymentStatusExtension on PaymentStatus {
  bool get isCompleted => this == PaymentStatus.success || 
                          this == PaymentStatus.failed || 
                          this == PaymentStatus.cancelled;
}

/// Payment result model
class PaymentResult {
  final bool success;
  final String? transactionId;
  final String? bookingId;
  final String? message;
  final Map<String, dynamic>? data;

  PaymentResult({
    required this.success,
    this.transactionId,
    this.bookingId,
    this.message,
    this.data,
  });
}

/// Optimized Easebuzz Payment Service
/// Efficient, memory-safe, and crash-resistant payment handling
class EasebuzzPaymentService {
  final EasebuzzFlutter _easebuzzFlutter = EasebuzzFlutter();
  Timer? _statusPollTimer;
  Timer? _launchTimeoutTimer;
  bool _isDisposed = false;
  bool _isCheckingStatus = false; // Prevent concurrent status checks
  PaymentResult? _cachedResult; // Cache result to avoid duplicate API calls

  /// Payment configuration
  final String amount;
  final String name;
  final String email;
  final String phone;
  final String productInfo;
  final String paymentType;
  final Map<String, dynamic>? metadata;
  final bool isProduction;
  final String? successUrl;
  final String? failureUrl;

  /// Current state
  PaymentStatus _status = PaymentStatus.idle;
  String? _currentTxnId;
  final ValueNotifier<PaymentStatus> statusNotifier = ValueNotifier(PaymentStatus.idle);
  final ValueNotifier<String?> errorNotifier = ValueNotifier<String?>(null);

  EasebuzzPaymentService({
    required this.amount,
    required this.name,
    required this.email,
    required this.phone,
    required this.productInfo,
    this.paymentType = 'PAYMENT',
    this.metadata,
    this.isProduction = false,
    this.successUrl,
    this.failureUrl,
  });

  PaymentStatus get status => _status;
  String? get currentTxnId => _currentTxnId;

  /// Initialize payment - call backend to get access key
  Future<String?> initiatePayment() async {
    if (_isDisposed) return null;

    _updateStatus(PaymentStatus.initiating);

    try {
      final txnId = _generateTransactionId();
      _currentTxnId = txnId;

      final payload = {
        'txnid': txnId,
        'amount': amount,
        'name': name.trim(),
        'firstname': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'productinfo': productInfo.length > 100 
            ? productInfo.substring(0, 100) 
            : productInfo,
        'surl': successUrl ?? _getDefaultSuccessUrl(txnId),
        'furl': failureUrl ?? _getDefaultFailureUrl(txnId),
        'paymentType': paymentType,
        if (metadata != null && metadata!.isNotEmpty) 'metadata': metadata,
      };

      if (kDebugMode) {
        debugPrint('Initiating payment with txnId: $txnId');
      }

      final response = await http.post(
        Uri.parse(AppConfig.easebuzzInitiatePayment),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      ).timeout(
        const Duration(seconds: 15), // Reduced from 30 to 15 seconds
        onTimeout: () => throw TimeoutException('Payment initiation timeout'),
      );

      if (response.statusCode != 200) {
        throw Exception('Server error: ${response.statusCode}');
      }

      final result = jsonDecode(response.body) as Map<String, dynamic>;
      final accessKey = _extractAccessKey(result);

      if (accessKey == null || accessKey.isEmpty) {
        final error = _extractError(result);
        throw Exception(error ?? 'Failed to initiate payment');
      }

      if (kDebugMode) {
        debugPrint('Payment initiated successfully');
      }
      return accessKey;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Payment initiation error: $e');
      }
      if (!_isDisposed) {
        _updateError(e.toString());
        _updateStatus(PaymentStatus.failed);
      }
      return null;
    }
  }

  /// Launch Easebuzz payment gateway
  Future<PaymentResult> launchPayment(String accessKey) async {
    if (_isDisposed) {
      return PaymentResult(success: false, message: 'Service disposed');
    }

    _updateStatus(PaymentStatus.gatewayLaunched);

    // Start status polling immediately when gateway is launched
    _startStatusPolling();

    // Set launch timeout (reduced from 10 to 5 seconds)
    _launchTimeoutTimer?.cancel();
    _launchTimeoutTimer = Timer(const Duration(seconds: 5), () {
      if (_status == PaymentStatus.gatewayLaunched && !_isDisposed) {
        if (kDebugMode) {
          debugPrint('Payment gateway launch timeout');
        }
      }
    });

    try {
      final payMode = isProduction ? 'production' : 'test';
      if (kDebugMode) {
        debugPrint('Launching Easebuzz gateway with payMode: $payMode');
      }

      final response = await _easebuzzFlutter.payWithEasebuzz(
        accessKey,
        payMode,
      ).timeout(
        const Duration(seconds: 180), // Reduced from 300 to 180 seconds
        onTimeout: () {
          if (kDebugMode) {
            debugPrint('Payment gateway timeout');
          }
          return null;
        },
      );

      _launchTimeoutTimer?.cancel();

      if (_isDisposed) {
        return PaymentResult(success: false, message: 'Service disposed');
      }

      // If response is null, status polling will handle it
      if (response == null) {
        return PaymentResult(
          success: false,
          message: 'Checking payment status...',
        );
      }

      // Process plugin response
      return _processPluginResponse(response);
    } catch (e) {
      _launchTimeoutTimer?.cancel();
      if (kDebugMode) {
        debugPrint('Payment gateway launch error: $e');
      }

      if (_isDisposed) {
        return PaymentResult(success: false, message: 'Service disposed');
      }

      // Status polling will handle verification
      return PaymentResult(
        success: false,
        message: 'Verifying payment status...',
      );
    }
  }

  /// Process plugin response
  PaymentResult _processPluginResponse(dynamic response) {
    if (kDebugMode) {
      debugPrint('Processing plugin response');
    }

    Map<String, dynamic> payload;
    try {
      if (response is Map) {
        payload = response.cast<String, dynamic>();
      } else if (response is String) {
        payload = jsonDecode(response) as Map<String, dynamic>;
      } else {
        payload = {'raw': response.toString()};
      }
    } catch (e) {
      payload = {'raw': response.toString()};
    }

    final status = payload['status'] ?? payload['result'] ?? payload['STATUS'];
    final message = payload['message']?.toString() ?? 
                   payload['errorMessage']?.toString() ??
                   payload['error_desc']?.toString();

    // Check for failure first
    if (_isFailedStatus(status) || 
        (message?.toLowerCase().contains('fail') ?? false)) {
      _updateStatus(PaymentStatus.failed);
      return PaymentResult(
        success: false,
        transactionId: _currentTxnId,
        message: message ?? 'Payment failed',
        data: payload,
      );
    }

    // Check for success - verify with backend
    if (_isSuccessStatus(status)) {
      return PaymentResult(
        success: false, // Will be updated after verification
        transactionId: _currentTxnId,
        message: 'Verifying payment...',
        data: payload,
      );
    }

    // Status unclear - verify with backend
    return PaymentResult(
      success: false,
      transactionId: _currentTxnId,
      message: 'Verifying payment status...',
      data: payload,
    );
  }

  /// Optimized status polling - reduced frequency and duration
  void _startStatusPolling() {
    if (_isDisposed || _currentTxnId == null) return;

    // Only update to processing if not already in a terminal state
    if (!_status.isCompleted) {
      _updateStatus(PaymentStatus.processing);
    }
    
    _statusPollTimer?.cancel();

    // Poll immediately
    _checkPaymentStatus();

    // Optimized polling: 3 seconds interval, max 60 seconds (20 polls)
    int pollCount = 0;
    const maxPolls = 20; // 20 * 3 = 60 seconds total
    const pollInterval = Duration(seconds: 3);

    _statusPollTimer = Timer.periodic(pollInterval, (timer) {
      pollCount++;
      
      if (pollCount >= maxPolls || 
          _isDisposed || 
          _status.isCompleted) {
        timer.cancel();
        if (pollCount >= maxPolls && !_status.isCompleted && kDebugMode) {
          debugPrint('Status polling timeout after $pollCount polls');
        }
        return;
      }
      
      _checkPaymentStatus();
    });
  }

  /// Optimized status check with debouncing and error handling
  Future<void> _checkPaymentStatus() async {
    if (_isDisposed || _currentTxnId == null || _isCheckingStatus) return;
    
    // Prevent concurrent status checks
    _isCheckingStatus = true;

    try {
      final response = await http.post(
        Uri.parse(AppConfig.easebuzzGetTransactionDetails),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'txnid': _currentTxnId}),
      ).timeout(
        const Duration(seconds: 8), // Reduced from 10 to 8 seconds
        onTimeout: () => throw TimeoutException('Status check timeout'),
      );

      if (response.statusCode != 200 || _isDisposed) {
        return;
      }

      final result = jsonDecode(response.body) as Map<String, dynamic>;
      final status = result['status'];
      final data = result['data'];
      final msg = result['msg'];

      // Handle different response formats
      Map<String, dynamic>? transactionData;
      
      if (status == true && msg is List && msg.isNotEmpty) {
        transactionData = msg[0] as Map<String, dynamic>?;
      } else if (status == 1 && data is Map<String, dynamic>) {
        transactionData = data;
      } else if (status == true && data is Map<String, dynamic>) {
        transactionData = data;
      }

      if (transactionData != null && !_isDisposed) {
        final error = transactionData['error']?.toString().toLowerCase() ?? '';
        final errorMessage = transactionData['error_Message']?.toString().toLowerCase() ?? '';
        final unmappedStatus = transactionData['unmappedstatus']?.toString().toLowerCase() ?? '';
        
        // Check if transaction FAILED first (priority check)
        final isFailed = error.contains('fail') || 
                        error.contains('failed') ||
                        error.contains('error') ||
                        error.contains('declined') ||
                        error.contains('rejected') ||
                        errorMessage.contains('fail') ||
                        errorMessage.contains('failed') ||
                        errorMessage.contains('error') ||
                        errorMessage.contains('declined') ||
                        errorMessage.contains('rejected') ||
                        unmappedStatus == 'failed' ||
                        unmappedStatus == 'failure' ||
                        (status == false && error.isNotEmpty);
        
        // Check if transaction is successful (only if not failed)
        final isSuccess = !isFailed && (
                         error.contains('successful') || 
                         error.contains('success') ||
                         errorMessage.contains('successful') ||
                         errorMessage.contains('success') ||
                         unmappedStatus == 'success' ||
                         unmappedStatus == 'completed');
        
        // Priority: Check failure first
        if (isFailed) {
          _statusPollTimer?.cancel();
          _updateStatus(PaymentStatus.failed);
          final errorMsg = transactionData['error']?.toString() ?? 
                          transactionData['error_Message']?.toString() ??
                          'Payment failed';
          _updateError(errorMsg);
          // Cache result
          _cachedResult = PaymentResult(
            success: false,
            transactionId: _currentTxnId,
            message: errorMsg,
            data: transactionData,
          );
          return;
        } else if (isSuccess) {
          _statusPollTimer?.cancel();
          _updateStatus(PaymentStatus.success);
          // Cache result
          _cachedResult = PaymentResult(
            success: true,
            transactionId: _currentTxnId,
            bookingId: transactionData['booking_id']?.toString() ??
                       transactionData['bookingId']?.toString() ??
                       transactionData['order_id']?.toString() ??
                       transactionData['easepayid']?.toString(),
            message: transactionData['error']?.toString() ?? 
                     transactionData['error_Message']?.toString(),
            data: transactionData,
          );
          return;
        }
      }
    } catch (e) {
      if (kDebugMode && !_isDisposed) {
        debugPrint('Status check error: $e');
      }
    } finally {
      _isCheckingStatus = false;
    }
  }

  /// Get payment result - uses cache if available
  Future<PaymentResult> getPaymentResult() async {
    // Return cached result if available
    if (_cachedResult != null) {
      return _cachedResult!;
    }

    if (_currentTxnId == null) {
      return PaymentResult(
        success: false,
        message: 'No transaction ID',
      );
    }

    try {
      final response = await http.post(
        Uri.parse(AppConfig.easebuzzGetTransactionDetails),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'txnid': _currentTxnId}),
      ).timeout(
        const Duration(seconds: 8),
      );

      if (response.statusCode != 200) {
        return PaymentResult(
          success: _status == PaymentStatus.success,
          transactionId: _currentTxnId,
          message: 'Could not fetch payment details',
        );
      }

      final result = jsonDecode(response.body) as Map<String, dynamic>;
      final status = result['status'];
      final data = result['data'];
      final msg = result['msg'];

      // Handle different response formats
      Map<String, dynamic>? transactionData;
      
      if (status == true && msg is List && msg.isNotEmpty) {
        transactionData = msg[0] as Map<String, dynamic>?;
      } else if (status == 1 && data is Map<String, dynamic>) {
        transactionData = data;
      } else if (status == true && data is Map<String, dynamic>) {
        transactionData = data;
      }

      if (transactionData != null) {
        final error = transactionData['error']?.toString().toLowerCase() ?? '';
        final errorMessage = transactionData['error_Message']?.toString().toLowerCase() ?? '';
        
        final isFailed = error.contains('fail') || 
                        error.contains('failed') ||
                        error.contains('error') ||
                        error.contains('declined') ||
                        error.contains('rejected') ||
                        errorMessage.contains('fail') ||
                        errorMessage.contains('failed') ||
                        errorMessage.contains('error') ||
                        errorMessage.contains('declined') ||
                        errorMessage.contains('rejected') ||
                        (status == false && error.isNotEmpty);
        
        final isSuccess = !isFailed && (
                         error.contains('successful') || 
                         error.contains('success') ||
                         errorMessage.contains('successful') ||
                         errorMessage.contains('success'));

        final paymentResult = PaymentResult(
          success: isSuccess,
          transactionId: _currentTxnId,
          bookingId: transactionData['booking_id']?.toString() ??
                     transactionData['bookingId']?.toString() ??
                     transactionData['order_id']?.toString() ??
                     transactionData['easepayid']?.toString(),
          message: transactionData['error']?.toString() ?? 
                   transactionData['error_Message']?.toString() ??
                   transactionData['message']?.toString(),
          data: transactionData,
        );
        
        // Cache result
        _cachedResult = paymentResult;
        return paymentResult;
      }

      return PaymentResult(
        success: _status == PaymentStatus.success,
        transactionId: _currentTxnId,
        message: 'Payment status unclear',
      );
    } catch (e) {
      return PaymentResult(
        success: _status == PaymentStatus.success,
        transactionId: _currentTxnId,
        message: 'Error fetching payment details: $e',
      );
    }
  }

  /// Manual status check (for user-triggered checks)
  Future<void> checkStatusManually() async {
    if (_currentTxnId == null || _isDisposed) return;
    await _checkPaymentStatus();
  }

  /// Update status safely
  void _updateStatus(PaymentStatus newStatus) {
    if (_isDisposed) return;
    _status = newStatus;
    statusNotifier.value = newStatus;
  }

  /// Update error safely
  void _updateError(String? error) {
    if (_isDisposed) return;
    errorNotifier.value = error;
  }

  /// Extract access key from backend response
  String? _extractAccessKey(dynamic result) {
    if (result is Map<String, dynamic>) {
      if (result['data'] is String && (result['data'] as String).isNotEmpty) {
        return result['data'] as String;
      }
      if (result['data'] is Map<String, dynamic>) {
        final data = result['data'] as Map<String, dynamic>;
        return data['access_key']?.toString() ?? 
               data['accessKey']?.toString() ??
               data['data']?.toString();
      }
    }
    return null;
  }

  /// Extract error from backend response
  String? _extractError(dynamic result) {
    if (result is Map<String, dynamic>) {
      return result['error']?.toString() ??
             result['message']?.toString() ??
             result['error_desc']?.toString() ??
             (result['data'] is String ? result['data'] as String : null);
    }
    return null;
  }

  /// Check if status indicates success
  bool _isSuccessStatus(dynamic status) {
    if (status == null) return false;
    if (status is bool) return status;
    final statusStr = status.toString().toLowerCase();
    return statusStr == '1' ||
           statusStr == 'success' ||
           statusStr == 'successful' ||
           statusStr == 'true';
  }

  /// Check if status indicates failure
  bool _isFailedStatus(dynamic status) {
    if (status == null) return false;
    if (status is bool) return !status;
    final statusStr = status.toString().toLowerCase();
    return statusStr == '0' ||
           statusStr == 'failed' ||
           statusStr == 'failure' ||
           statusStr == 'fail' ||
           statusStr == 'false' ||
           statusStr == 'error' ||
           statusStr == 'cancelled';
  }

  /// Generate transaction ID
  String _generateTransactionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(10000);
    final prefix = paymentType.toUpperCase().replaceAll(RegExp(r'\s+'), '_');
    return '${prefix}_$timestamp\_$random';
  }

  /// Get default success URL
  String _getDefaultSuccessUrl(String txnId) {
    return '${AppConfig.easebuzzPaymentCallback}?status=success&txnid=$txnId';
  }

  /// Get default failure URL
  String _getDefaultFailureUrl(String txnId) {
    return '${AppConfig.easebuzzPaymentCallback}?status=failure&txnid=$txnId';
  }

  /// Dispose resources - prevents memory leaks
  void dispose() {
    if (_isDisposed) return; // Prevent double disposal
    
    _isDisposed = true;
    
    // Cancel all timers
    _statusPollTimer?.cancel();
    _statusPollTimer = null;
    
    _launchTimeoutTimer?.cancel();
    _launchTimeoutTimer = null;
    
    // Dispose notifiers
    statusNotifier.dispose();
    errorNotifier.dispose();
    
    // Clear cache
    _cachedResult = null;
    _currentTxnId = null;
  }
}
