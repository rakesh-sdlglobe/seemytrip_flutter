import 'package:get/get.dart';
import 'package:seemytrip/features/auth/presentation/controllers/login_controller.dart';
import 'package:seemytrip/features/flights/presentation/controllers/flight_controller.dart';
import 'package:seemytrip/core/theme/theme_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Initialize LoginController
    Get..lazyPut(() => LoginController(), fenix: true)
    
    // Initialize FlightController
    ..lazyPut(() => FlightController(), fenix: true)
    
    // Initialize ThemeService
    ..putAsync<ThemeService>(() => ThemeService().init(), permanent: true);
  }
}
