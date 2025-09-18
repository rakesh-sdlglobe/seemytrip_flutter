import 'package:get/get.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/hotels/presentation/screens/booking_confirmation_screen.dart';
import '../../features/flights/presentation/routes/flight_routes.dart';

class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();
  
  // Static instance for accessing the class
  static final AppRoutes _instance = AppRoutes._();
  
  // Factory constructor to return the same instance
  factory AppRoutes() => _instance;
  static const String home = '/';
  static const String bookingConfirmation = '/booking-confirmation';
  
  static List<GetPage> get routes => [
    GetPage(
      name: home,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: bookingConfirmation,
      page: () => const BookingConfirmationScreen(),
    ),
    // ...FlightRoutes.routes,
  ];
}
