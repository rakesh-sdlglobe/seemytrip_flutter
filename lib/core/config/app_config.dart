class AppConfig {
  static const String baseUrl = 'http://192.168.0.12:3002/api';
  // static const String baseUrl = 'http://192.168.1:3002/api';
  static const String googleClientId =
      '493628196678-cjvhttpbp9c4ha4a35srklc9skvgq324.apps.googleusercontent.com';

  // Auth endpoints
  static const String login = '$baseUrl/login';
  static const String signUp = '$baseUrl/signup';
  static const String userProfile = '$baseUrl/users/userProfile';
  static const String googleUserData = '$baseUrl/auth/googleUserData';
  
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
  static const String busAuth = r'$baseUrl/bus/authenticateBusAPI';
  static const String busCities = r'$baseUrl/bus/getBusCityList';
  static const String busSearch = r'$baseUrl/bus/busSearch';
  static const String busSeatLayout = r'$baseUrl/bus/getBusSeatLayOut';
  static const String busBoardingPoints = r'$baseUrl/bus/getBoardingPointDetails';
  
  // Flight endpoints
  static const String flightsAirports = r'$baseUrl/flights/getFlightsAirports';
  static const String flightsSearch = r'$baseUrl/flights/getFlightsList';
}
