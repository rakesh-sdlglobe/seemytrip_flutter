import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/constants.dart';

/// A utility class for handling network operations
class NetworkUtils {
  // Singleton pattern
  static final NetworkUtils _instance = NetworkUtils._internal();
  factory NetworkUtils() => _instance;
  NetworkUtils._internal();

  // HTTP client
  final http.Client _client = http.Client();
  
  // Headers
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Set authorization token
  void setAuthToken(String token) {
    _headers['Authorization'] = 'Bearer $token';
  }

  /// Clear authorization token
  void clearAuthToken() {
    _headers.remove('Authorization');
  }

  /// Generic GET request
  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    return _handleRequest(
      () async {
        final uri = Uri.parse(url).replace(queryParameters: queryParams);
        final response = await _client.get(
          uri,
          headers: {..._headers, ...?headers},
        );
        return _handleResponse(response);
      },
    );
  }

  /// Generic POST request
  Future<dynamic> post(
    String url, {
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    return _handleRequest(
      () async {
        final uri = Uri.parse(url).replace(queryParameters: queryParams);
        final response = await _client.post(
          uri,
          headers: {..._headers, ...?headers},
          body: body is Map || body is List ? jsonEncode(body) : body,
        );
        return _handleResponse(response);
      },
    );
  }

  /// Generic PUT request
  Future<dynamic> put(
    String url, {
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    return _handleRequest(
      () async {
        final uri = Uri.parse(url).replace(queryParameters: queryParams);
        final response = await _client.put(
          uri,
          headers: {..._headers, ...?headers},
          body: body is Map || body is List ? jsonEncode(body) : body,
        );
        return _handleResponse(response);
      },
    );
  }

  /// Generic PATCH request
  Future<dynamic> patch(
    String url, {
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    return _handleRequest(
      () async {
        final uri = Uri.parse(url).replace(queryParameters: queryParams);
        final response = await _client.patch(
          uri,
          headers: {..._headers, ...?headers},
          body: body is Map || body is List ? jsonEncode(body) : body,
        );
        return _handleResponse(response);
      },
    );
  }

  /// Generic DELETE request
  Future<dynamic> delete(
    String url, {
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    return _handleRequest(
      () async {
        final uri = Uri.parse(url).replace(queryParameters: queryParams);
        final response = await _client.delete(
          uri,
          headers: {..._headers, ...?headers},
          body: body is Map || body is List ? jsonEncode(body) : body,
        );
        return _handleResponse(response);
      },
    );
  }

  /// Handle file upload
  Future<dynamic> uploadFile(
    String url, {
    required String filePath,
    required String fileFieldName,
    Map<String, String>? fields,
    Map<String, String>? headers,
  }) async {
    return _handleRequest(
      () async {
        final uri = Uri.parse(url);
        final request = http.MultipartRequest('POST', uri);
        
        // Add headers
        request.headers.addAll({..._headers, ...?headers});
        
        // Add file
        request.files.add(await http.MultipartFile.fromPath(
          fileFieldName,
          filePath,
        ));
        
        // Add fields if any
        if (fields != null) {
          request.fields.addAll(fields);
        }
        
        // Send request
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        
        return _handleResponse(response);
      },
    );
  }

  /// Handle response
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = response.body;
    
    try {
      final jsonResponse = jsonDecode(responseBody);
      
      if (statusCode >= 200 && statusCode < 300) {
        return jsonResponse;
      } else if (statusCode == 401) {
        // Handle unauthorized
        throw Exception('Unauthorized access');
      } else if (statusCode == 403) {
        // Handle forbidden
        throw Exception('Access denied');
      } else if (statusCode == 404) {
        // Handle not found
        throw Exception('Resource not found');
      } else if (statusCode >= 500) {
        // Handle server error
        throw Exception('Server error occurred');
      } else {
        // Handle other errors
        final errorMessage = jsonResponse['message'] ?? 'An error occurred';
        throw Exception(errorMessage);
      }
    } catch (e) {
      // If response is not JSON, return the raw response
      if (e is FormatException) {
        if (statusCode >= 200 && statusCode < 300) {
          return responseBody;
        } else {
          throw Exception('Invalid response format: ${e.toString()}');
        }
      }
      rethrow;
    }
  }

  /// Handle network requests with error handling and retry logic
  Future<dynamic> _handleRequest(Future<dynamic> Function() request) async {
    try {
      // Check internet connection
      final hasConnection = await checkInternetConnection();
      if (!hasConnection) {
        throw SocketException('No internet connection');
      }
      
      // Execute the request
      return await request();
    } on SocketException catch (e) {
      throw Exception('No internet connection: ${e.message}');
    } on TimeoutException catch (e) {
      throw Exception('Request timed out: ${e.message}');
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  /// Check internet connection
  Future<bool> checkInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      
      // Additional check by pinging a reliable server
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Download a file from the given URL
  Future<String> downloadFile(
    String url, 
    String savePath, {
    void Function(int received, int total)? onProgress,
  }) async {
    try {
      final response = await _client.send(
        http.Request('GET', Uri.parse(url)),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to download file: ${response.reasonPhrase}');
      }
      
      final file = File(savePath);
      final bytes = <int>[];
      final contentLength = response.contentLength ?? 0;
      int receivedLength = 0;
      
      await response.stream.listen(
        (List<int> chunk) {
          bytes.addAll(chunk);
          receivedLength += chunk.length;
          onProgress?.call(receivedLength, contentLength);
        },
        onDone: () async {
          await file.writeAsBytes(bytes);
        },
        onError: (e) {
          throw Exception('Error downloading file: $e');
        },
        cancelOnError: true,
      ).asFuture();
      
      return file.path;
    } catch (e) {
      debugPrint('Download error: $e');
      rethrow;
    }
  }

  /// Close the HTTP client when not needed anymore
  void close() {
    _client.close();
  }
}
