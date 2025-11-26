class AppConfig {
  static const String baseUrl = 'http://10.0.2.2:3002/api';
//   static const String baseUrl = 'https://tripadmin.seemytrip.com/api';
  static const String baseUrl2 = 'http://10.0.2.2:3002/api';
  // static const String baseUrl = 'http://192.168.1:3002/api';
  static const String googleClientId =
      '493628196678-cjvhttpbp9c4ha4a35srklc9skvgq324.apps.googleusercontent.com';

  // Auth endpoints
  static const String login = '$baseUrl/login';
  static const String signUp = '$baseUrl/signup';
  static const String userProfile = '$baseUrl/users/userProfile';
  static const String googleUserData = '$baseUrl/auth/googleUserData';
  static const String editProfile = '$baseUrl/users/editProfile';
  
  // Traveller endpoints
  static const String addTraveler = '$baseUrl/users/addTraveler';
  static const String getTravelers = '$baseUrl/users/getTravelers';
  static String deleteTraveler(String passengerId) => '$baseUrl/users/deleteTraveler/$passengerId';
  static String editTraveller(String passengerId) => '$baseUrl/users/editTraveller/$passengerId';
  
  // Hotel endpoints
  static const String hotelCities = '$baseUrl/hotels/getHotelCities';
  static const String hotelsList = '$baseUrl/hotels/getHotelsList';
  static const String hotelDetails = '$baseUrl/hotels/getHoteldetails';
  static const String hotelImages = '$baseUrl/hotels/getHotelImages';
  static const String hotelGeoList = '$baseUrl/hotels/getGeoList';
  static const String hotelPrebook = '$baseUrl/hotels/getHotelPrebook';
  static const String hotelBooked = '$baseUrl/hotels/getHotelBooked';
  static const String saveHotelBooking = '$baseUrl/hotels/saveHotelBooking';
  
  // Hotel booking endpoints
  static const String getAllHotelBookings = '$baseUrl/hotels/bookings';
  static String getUserHotelBookings(int userId) => '$baseUrl/hotels/bookings/user/$userId';
  static String getHotelBookingById(String bookingId) => '$baseUrl/hotels/bookings/$bookingId';
  
  // Train endpoints
  static const String trainStations = '$baseUrl2/trains/getStation';
  static const String trainSchedule = '$baseUrl2/trains/getTrainSchedule';
  static const String trainsList = '$baseUrl2/trains/getTrains';
  static const String trainSeatBlock = '$baseUrl2/trains/booking/block';
  static String getTrainBookingDetails(String transactionId) => '$baseUrl2/trains/bookingdetails/$transactionId';
  
  // Bus endpoints
  static const String busAuth = '$baseUrl/bus/authenticateBusAPI';
  static const String busCities = '$baseUrl/bus/getBusCityList';
  static const String busSearch = '$baseUrl/bus/busSearch';
  static const String busSeatLayout = '$baseUrl/bus/getBusSeatLayOut';
  static const String busBoardingPoints = '$baseUrl/bus/getBoardingPointDetails';
  static const String busBlock = '$baseUrl/bus/getBlock';
  static const String busBook = '$baseUrl/bus/getBooking';
  static const String busBookingDetails = '$baseUrl/bus/getBookingDetails';
  static const String busBookingCancel = '$baseUrl/bus/busBookingCancel';
  static const String createBusBooking = '$baseUrl/bus/createBusBooking';
  static String getUserBusBookings(int userId) => '$baseUrl/bus/userBookings/$userId';
  static String getBusBookingDetailsById(String bookingId) => '$baseUrl/bus/bookingDetails/$bookingId';
  static String updateBusBookingStatus(String bookingId) => '$baseUrl/bus/updateBookingStatus/$bookingId';
  static String cancelBusBookingById(String bookingId) => '$baseUrl/bus/cancelBooking/$bookingId';
  static String getBusBookingStats(int userId) => '$baseUrl/bus/bookingStats/$userId';
  
  // Flight endpoints
  static const String flightsAirports = '$baseUrl/flights/getFlightsAirports';
  static const String flightsSearch = '$baseUrl/flights/getFlightsListmobile';
  static const String flightPreBook = '$baseUrl/flights/getFlightPreBook';
  static const String flightBook = '$baseUrl/flights/getFlightBook';
  static const String saveFlightBooking = '$baseUrl/flights/saveFlightBooking';
  
  // Notification endpoints
  static const String getNotifications = '$baseUrl/notifications';
  static const String markAllNotificationsRead = '$baseUrl/notifications/mark-all-read';

  // Payment endpoints
  // Note: Backend uses /Initiate_Payment (capital I) but most servers are case-insensitive
  static const String easebuzzInitiatePayment =
      '$baseUrl/easebuzzPayment/Initiate_Payment';
  static const String easebuzzGetTransactionDetails =
      '$baseUrl/easebuzzPayment/get_transaction_details';
  static const String easebuzzPaymentCallback =
      '$baseUrl/easebuzzPayment/payment_callback';
}
