// import 'package:dio/dio.dart' as dio;
// import 'package:dio/dio.dart';
// import 'package:get/get.dart';
// import '../Controller/login_controller.dart';

// class ApiService extends GetxService {
//   final dio.Dio _dio = Dio();
//   final LoginController _loginController = Get.find<LoginController>();

//   ApiService() {
//     _dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) {
//         final token = _loginController.getAccessToken();
//         if (token.isNotEmpty) {
//           options.headers['Authorization'] = 'Bearer $token';
//         }
//         return handler.next(options);
//       },
//       onError: (DioError e, handler) {
//         if (e.response?.statusCode == 401) {
//           _loginController.logout();
//         }
//         return handler.next(e);
//       },
//     ));
//   }

//   Future<dio.Response> get(String path) async => await _dio.get(path);
//   Future<dio.Response> post(String path, dynamic data) async => await _dio.post(path, data: data);
//   Future<dio.Response> put(String path, dynamic data) async => await _dio.put(path, data: data);
//   Future<dio.Response> delete(String path) async => await _dio.delete(path);
// }