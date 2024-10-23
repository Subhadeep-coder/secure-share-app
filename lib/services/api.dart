// import 'dart:io';
import 'package:dio/dio.dart';
// import 'package:dio/io.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Api {
  late Dio api;
  String? accessToken;
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  static String baseUrl = '${dotenv.env['BACKEND_URL']}';

  Api() {
    api = Dio();
    _configureDio();
  }

  Future<void> _configureDio() async {
    api.options.baseUrl = baseUrl;

    // Load the certificate
    // ByteData bytes = await rootBundle.load('assets/certificate.crt');
    // SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    // securityContext.setTrustedCertificatesBytes(bytes.buffer.asUint8List());

    // // Create an HttpClient with the security context
    // HttpClient httpClient = HttpClient(context: securityContext);

    // // Configure SSL pinning
    // httpClient.badCertificateCallback =
    //     (X509Certificate cert, String host, int port) {
    //   // You can add additional checks here if needed
    //   return false; // Reject any certificate that doesn't match your pinned certificate
    // };

    // // Set the httpClientAdapter with the configured HttpClient
    // (api.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
    //     () => httpClient;

    // Add interceptors
    api.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!options.path.startsWith('http')) {
            options.path = baseUrl + options.path;
          }

          accessToken ??= await _storage.read(key: 'access_token');

          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            final refreshToken = await _storage.read(key: "refresh_token");
            if (refreshToken != null) {
              final refreshed = await _refreshAccessToken(refreshToken);
              if (refreshed) {
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

  // Existing methods (_retry, _refreshAccessToken) remain the same
  // ...

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    options.headers?['Authorization'] = 'Bearer $accessToken';

    return api.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

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
