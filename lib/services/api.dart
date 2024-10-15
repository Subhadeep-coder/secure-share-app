import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Api {
  Dio api = Dio();
  String? accessToken;
  final _storage = const FlutterSecureStorage();
  static String baseUrl = '${dotenv.env['BACKEND_URL']}';

  Api() {
    api.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Attach the base URL if it's missing
          if (!options.path.startsWith('http')) {
            options.path = baseUrl + options.path;
          }

          // Read access token from storage if not already set
          accessToken ??= await _storage.read(key: 'access_token');

          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          // Check if the error is 401 (Unauthorized)
          if (error.response?.statusCode == 401) {
            // Check if the refresh token exists
            final refreshToken = await _storage.read(key: "refresh_token");
            if (refreshToken != null) {
              // Attempt to refresh the access token
              final refreshed = await _refreshAccessToken(refreshToken);
              if (refreshed) {
                // Retry the original request with the new access token
                final clonedRequest = await _retry(error.requestOptions);
                return handler.resolve(clonedRequest);
              }
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  // Method to retry a failed request
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    // Update the authorization header with the new access token
    options.headers?['Authorization'] = 'Bearer $accessToken';

    return api.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  // Method to refresh the access token
  Future<bool> _refreshAccessToken(String refreshToken) async {
    try {
      debugPrint("Here in refreshing token");
      final response = await api.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      debugPrint("After refreshing token");
      if (response.statusCode == 201 || response.statusCode == 200) {
        accessToken = response.data['access_token'];
        refreshToken = response.data['refresh_token'];
        await _storage.write(key: 'access_token', value: accessToken);
        await _storage.write(key: 'refresh_token', value: refreshToken);
        return true;
      } else {
        // Clear tokens if refresh fails
        await _storage.deleteAll();
        accessToken = null;
        return false;
      }
    } catch (e) {
      await _storage.deleteAll();
      accessToken = null;
      return false;
    }
  }
}
