import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Controller to monitor network connectivity status throughout the entire application
class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  Timer? _periodicCheckTimer;
  
  // Observable connectivity status
  final RxBool isConnected = true.obs;
  final Rx<ConnectivityResult> connectivityResult = ConnectivityResult.none.obs;
  
  // Flag to prevent multiple simultaneous checks
  bool _isChecking = false;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _startMonitoring();
    _startPeriodicChecks();
  }

  /// Initialize connectivity check
  Future<void> _initConnectivity() async {
    if (_isChecking) return;
    _isChecking = true;
    
    try {
      final result = await _connectivity.checkConnectivity();
      connectivityResult.value = result.isNotEmpty ? result.first : ConnectivityResult.none;
      await _checkInternetConnection();
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      isConnected.value = false;
    } finally {
      _isChecking = false;
    }
  }

  /// Start monitoring connectivity changes in real-time
  void _startMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) async {
        connectivityResult.value = results.isNotEmpty ? results.first : ConnectivityResult.none;
        await _checkInternetConnection();
      },
      onError: (error) {
        debugPrint('Connectivity error: $error');
        isConnected.value = false;
      },
      cancelOnError: false,
    );
  }

  /// Start periodic checks to ensure connectivity is always monitored
  void _startPeriodicChecks() {
    // Check connectivity every 10 seconds to ensure we catch any missed updates
    _periodicCheckTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) async {
        if (!_isChecking) {
          await _initConnectivity();
        }
      },
    );
  }

  /// Check actual internet connection by pinging a server
  Future<void> _checkInternetConnection() async {
    if (_isChecking) return;
    _isChecking = true;
    
    try {
      if (connectivityResult.value == ConnectivityResult.none) {
        isConnected.value = false;
        _isChecking = false;
        return;
      }

      // Additional check by pinging a reliable server
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      
      isConnected.value = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isConnected.value = false;
    } on TimeoutException catch (_) {
      isConnected.value = false;
    } catch (e) {
      debugPrint('Error checking internet: $e');
      isConnected.value = false;
    } finally {
      _isChecking = false;
    }
  }

  /// Manually check connectivity
  Future<void> checkConnectivity() async {
    await _initConnectivity();
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    _periodicCheckTimer?.cancel();
    super.onClose();
  }
}

