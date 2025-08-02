class AppConfig {
  static const String baseUrl = 'http://192.168.1.6:3002/api';
  
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
  static const String busAuth = '$baseUrl/bus/authenticateBusAPI';
  static const String busCities = '$baseUrl/bus/getBusCityList';
  static const String busSearch = '$baseUrl/bus/busSearch';
  static const String busSeatLayout = '$baseUrl/bus/getBusSeatLayOut';
  static const String busBoardingPoints = '$baseUrl/bus/getBoardingPointDetails';
}
