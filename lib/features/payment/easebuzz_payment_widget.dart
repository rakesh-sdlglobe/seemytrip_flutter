// ignore_for_file: always_specify_types, use_build_context_synchronously, avoid_catches_without_on_clauses

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../flights/presentation/screens/FlightSearchScreen/booking_success_page.dart';
import 'easebuzz_payment_success_screen.dart';
import 'services/easebuzz_payment_service.dart';

/// Professional Easebuzz Payment Widget
/// Provides a seamless and smooth payment experience
class EasebuzzPaymentWidget extends StatefulWidget {
  const EasebuzzPaymentWidget({
    required this.amount,
    required this.name,
    required this.email,
    required this.phone,
    required this.productInfo,
    this.paymentType = 'PAYMENT',
    this.metadata,
    this.onValidation,
    this.onSuccess,
    this.onSuccessWithResult, // New callback with payment result
    this.onFailure,
    this.showError = true,
    this.environment = EasebuzzEnvironment.test,
    this.successUrl,
    this.failureUrl,
    super.key,
  });

  final double amount;
  final String name;
  final String email;
  final String phone;
  final String productInfo;
  final String paymentType;
  final Map<String, dynamic>? metadata;
  final Future<bool> Function()? onValidation;
  final VoidCallback? onSuccess;
  final Future<void> Function(PaymentResult)? onSuccessWithResult; // New callback with payment result
  final VoidCallback? onFailure;
  final bool showError;
  final EasebuzzEnvironment environment;
  final String? successUrl;
  final String? failureUrl;

  @override
  State<EasebuzzPaymentWidget> createState() => _EasebuzzPaymentWidgetState();
}

enum EasebuzzEnvironment {
  test,
  production,
}

class _EasebuzzPaymentWidgetState extends State<EasebuzzPaymentWidget>
    with WidgetsBindingObserver {
  EasebuzzPaymentService? _paymentService;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializePayment());
  }

  @override
  void dispose() {
    // Remove observer first
    WidgetsBinding.instance.removeObserver(this);
    
    // Dispose payment service to prevent memory leaks
    _paymentService?.dispose();
    _paymentService = null;
    
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // When app resumes, immediately check payment status if payment is in progress
    if (state == AppLifecycleState.resumed &&
        _paymentService != null &&
        !_paymentService!.statusNotifier.value.isCompleted) {
      // Reduced delay for faster detection
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && _paymentService != null) {
          final status = _paymentService!.statusNotifier.value;
          if (status == PaymentStatus.gatewayLaunched ||
              status == PaymentStatus.processing) {
            _paymentService!.checkStatusManually();
            setState(() {});
          }
        }
      });
    }
  }

  /// Initialize payment process
  Future<void> _initializePayment() async {
    if (_isInitialized) return;

    // Run validation
    if (widget.onValidation != null) {
      final isValid = await widget.onValidation!();
      if (!isValid || !mounted) {
        widget.onFailure?.call();
        Get.back();
        return;
      }
    }

    // Validate required fields
    if (!_validateInputs()) {
      widget.onFailure?.call();
      Get.back();
      return;
    }

    setState(() {
      _isInitialized = true;
    });

    // Create payment service
    _paymentService = EasebuzzPaymentService(
      amount: widget.amount.toStringAsFixed(2),
      name: widget.name,
      email: widget.email,
      phone: widget.phone,
      productInfo: widget.productInfo,
      paymentType: widget.paymentType,
      metadata: widget.metadata,
      isProduction: widget.environment == EasebuzzEnvironment.production,
      successUrl: widget.successUrl,
      failureUrl: widget.failureUrl,
    );

    // Listen to status changes
    _paymentService!.statusNotifier.addListener(_onStatusChanged);
    _paymentService!.errorNotifier.addListener(_onErrorChanged);

    // Start payment flow
    await _startPaymentFlow();
  }

  /// Start the payment flow
  Future<void> _startPaymentFlow() async {
    if (_paymentService == null || !mounted) return;

    try {
      // Step 1: Initiate payment with backend
      final accessKey = await _paymentService!.initiatePayment();

      if (accessKey == null || !mounted) {
        return;
      }

      // Step 2: Launch payment gateway
      final result = await _paymentService!.launchPayment(accessKey);

      // Result will be processed via status listener
      debugPrint('Payment launch result: ${result.message}');
    } catch (e) {
      debugPrint('Payment flow error: $e');
      if (mounted) {
        _showError('Payment could not be initiated. Please try again.');
        widget.onFailure?.call();
      }
    }
  }

  /// Handle status changes
  void _onStatusChanged() {
    if (!mounted || _paymentService == null) return;

    final status = _paymentService!.status;

    switch (status) {
      case PaymentStatus.success:
        _handlePaymentSuccess();
        break;
      case PaymentStatus.failed:
        _handlePaymentFailure();
        break;
      case PaymentStatus.cancelled:
        _handlePaymentCancellation();
        break;
      default:
        setState(() {}); // Update UI
    }
  }

  /// Handle error changes
  void _onErrorChanged() {
    if (!mounted || _paymentService == null) return;
    final error = _paymentService!.errorNotifier.value;
    if (error != null && widget.showError) {
      _showError(error);
    }
    setState(() {});
  }

  /// Handle successful payment
  Future<void> _handlePaymentSuccess() async {
    if (!mounted || _paymentService == null) return;

    // Double-check payment status before showing success page
    final result = await _paymentService!.getPaymentResult();

    if (!mounted) return;

    // Verify payment is actually successful before navigating
    if (!result.success) {
      debugPrint('Payment result indicates failure - not showing success page');
      _handlePaymentFailure();
      return;
    }

    // Call onSuccessWithResult first if provided (new way with payment result)
    if (widget.onSuccessWithResult != null) {
      await widget.onSuccessWithResult!(result);
    } else {
      // Fallback to old onSuccess callback (backward compatibility)
      widget.onSuccess?.call();
    }

    // Reduced delay for faster navigation
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    // Close the payment widget first to dismiss any popups
    Get.back();

    // Small delay to ensure payment screen is closed
    await Future.delayed(const Duration(milliseconds: 100));

    // Navigate to appropriate success page using GetX
    // Use off() to replace current route but keep navigation history
    if (_isBookingPayment()) {
      Get.off(
        () => BookingSuccessPage(
          bookingId: result.bookingId ?? result.transactionId ?? 'N/A',
          message: result.message ?? 'Your booking has been confirmed successfully!',
        ),
      );
    } else {
      Get.off(
        () => EasebuzzPaymentSuccessScreen(
          amount: widget.amount,
          transactionId: result.transactionId ?? 'N/A',
          productInfo: widget.productInfo,
        ),
      );
    }
  }

  /// Handle failed payment
  void _handlePaymentFailure() {
    if (!mounted) return;
    widget.onFailure?.call();
    setState(() {});
  }

  /// Handle cancelled payment
  void _handlePaymentCancellation() {
    if (!mounted) return;
    widget.onFailure?.call();
    setState(() {});
  }

  /// Check if this is a booking payment
  bool _isBookingPayment() {
    final type = widget.paymentType.toUpperCase();
    return type.contains('BOOKING') ||
        type.contains('FLIGHT') ||
        type.contains('BUS') ||
        type.contains('TRAIN') ||
        type.contains('HOTEL') ||
        (widget.metadata != null &&
            (widget.metadata!['type']
                    ?.toString()
                    .toUpperCase()
                    .contains('BOOKING') ??
                false));
  }

  /// Validate input fields
  bool _validateInputs() {
    if (widget.phone.trim().isEmpty ||
        widget.email.trim().isEmpty ||
        widget.name.trim().isEmpty) {
      _showError('Please provide valid phone, email, and name');
      return false;
    }

    if (widget.amount <= 0) {
      _showError('Please provide a valid payment amount');
      return false;
    }

    if (widget.productInfo.trim().isEmpty) {
      _showError('Product information is required');
      return false;
    }

    return true;
  }

  /// Show error message
  void _showError(String message) {
    if (!mounted || !widget.showError) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: Theme.of(context).colorScheme.onError,
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Payment'),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),
      body: _paymentService == null
          ? _buildLoadingState(theme, colorScheme)
          : ValueListenableBuilder<PaymentStatus>(
              valueListenable: _paymentService!.statusNotifier,
              builder: (context, status, _) {
                return _buildBody(theme, colorScheme, status);
              },
            ),
    );
  }

  /// Build loading state (initial)
  Widget _buildLoadingState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
          const SizedBox(height: 24),
          Text(
            'Preparing payment...',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  /// Build main body based on status
  Widget _buildBody(ThemeData theme, ColorScheme colorScheme, PaymentStatus status) {
    switch (status) {
      case PaymentStatus.initiating:
        return _buildInitiatingState(theme, colorScheme);
      case PaymentStatus.gatewayLaunched:
        return _buildGatewayLaunchedState(theme, colorScheme);
      case PaymentStatus.processing:
        return _buildProcessingState(theme, colorScheme);
      case PaymentStatus.failed:
        return _buildFailedState(theme, colorScheme);
      case PaymentStatus.cancelled:
        return _buildCancelledState(theme, colorScheme);
      case PaymentStatus.success:
        return _buildSuccessState(theme, colorScheme);
      default:
        return _buildLoadingState(theme, colorScheme);
    }
  }

  /// Build initiating state
  Widget _buildInitiatingState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
          const SizedBox(height: 24),
          Text(
            'Initiating payment...',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait while we prepare your payment',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Build gateway launched state
  Widget _buildGatewayLaunchedState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.payment,
              size: 64,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Payment Gateway Opened',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Please complete your payment in the payment screen.\n\n'
              'If you see "Transaction Successful!", close that screen and return here.\n\n'
              'Your payment will be automatically verified.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'Waiting for payment confirmation...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _paymentService?.checkStatusManually();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Check Payment Status'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build processing state
  Widget _buildProcessingState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Text(
              'Verifying Payment',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Please wait while we verify your payment status...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _paymentService?.checkStatusManually,
              icon: const Icon(Icons.refresh),
              label: const Text('Check Status'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build failed state
  Widget _buildFailedState(ThemeData theme, ColorScheme colorScheme) {
    final error = _paymentService?.errorNotifier.value;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              'Payment Failed',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (error != null)
              Text(
                error,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                _initializePayment();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry Payment'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build cancelled state
  Widget _buildCancelledState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cancel_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 24),
            Text(
              'Payment Cancelled',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'You cancelled the payment process.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build success state (shouldn't be visible as navigation happens)
  Widget _buildSuccessState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
          const SizedBox(height: 24),
          Text(
            'Payment successful! Redirecting...',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
