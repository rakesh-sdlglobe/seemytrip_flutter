class AppConfig {
  static const String baseUrl = 'http://192.168.0.12:3002/api';
  // static const String baseUrl = 'http://10.0.2.2:3002/api';
  // static const String baseUrl = 'http://192.168.1:3002/api';
  static const String googleClientId =
      '493628196678-cjvhttpbp9c4ha4a35srklc9skvgq324.apps.googleusercontent.com';

  // Auth endpoints
  static const String login = '$baseUrl/login';
  static const String signUp = '$baseUrl/signup';
  static const String userProfile = '$baseUrl/users/userProfile';
  static const String googleUserData = '$baseUrl/auth/googleUserData';
  static const String editProfile = '$baseUrl/users/editProfile';
  
  // Hotel endpoints
  static const String hotelCities = '$baseUrl/hotels/getHotelCities';
  static const String hotelsList = '$baseUrl/hotels/getHotelsList';
  static const String hotelDetails = '$baseUrl/hotels/getHoteldetails';
  static const String hotelImages = '$baseUrl/hotels/getHotelImages';
  static const String hotelGeoList = '$baseUrl/hotels/getGeoList';
  
  // Train endpoints
  static const String trainStations = '$baseUrl/trains/getStation';
  static const String trainSchedule = '$baseUrl/trains/getTrainSchedule';
  static const String trainsList = '$baseUrl/trains/getTrains';
  
  // Bus endpoints
  static const String busAuth = '$baseUrl/bus/authenticateBusAPI';
  static const String busCities = '$baseUrl/bus/getBusCityList';
  static const String busSearch = '$baseUrl/bus/busSearch';
  static const String busSeatLayout = '$baseUrl/bus/getBusSeatLayOut';
  static const String busBoardingPoints = '$baseUrl/bus/getBoardingPointDetails';
  
  // Flight endpoints
  static const String flightsAirports = '$baseUrl/flights/getFlightsAirports';
  static const String flightsSearch = '$baseUrl/flights/getFlightsList';
  
  // Notification endpoints
  static const String getNotifications = '$baseUrl/notifications';
  static const String markAllNotificationsRead = '$baseUrl/notifications/mark-all-read';
}
