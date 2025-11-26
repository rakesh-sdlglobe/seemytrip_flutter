import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/network_controller.dart';

/// Middleware to check connectivity on route changes
/// This ensures connectivity is checked whenever the user navigates
class ConnectivityMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {  
    final networkController = Get.find<NetworkController>()
    
    // Check connectivity when navigating to ensure it's always monitored
    ..checkConnectivity();    
    
    // Don't block navigation, just check connectivity
    return null;
  }
}

