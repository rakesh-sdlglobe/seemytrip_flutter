// class CityModel {
//   final String id;
//   final String code;
//   final String name;
//   final String display;
//   final String type;
//   final int count;
//   final String lat;
//   final String long;

//   CityModel({
//     required this.id,
//     required this.code,
//     required this.name,
//     required this.display,
//     required this.type,
//     required this.count,
//     required this.lat,
//     required this.long,
//   });

//   factory CityModel.fromJson(Map<String, dynamic> json) {
//     return CityModel(
//       id: json['Id'] ?? '',
//       code: json['Code'] ?? '',
//       name: json['Name'] ?? '',
//       display: json['Display'] ?? '',
//       type: json['Type'] ?? '',
//       count: json['Count'] ?? 0,
//       lat: json['Lat'] ?? '',
//       long: json['Long'] ?? '',
//     );
//   }
// }