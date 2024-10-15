import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static String baseUrl = '${dotenv.env['BACKEND_URL']}/auth';

  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    contentType: 'application/json',
  ));
  final storage = const FlutterSecureStorage();
  Future<String?> register(
      String name, String email, String password, String cPassword) async {
    try {
      final response = await dio.post(
        '/register',
        data: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'passwordConfirm': cPassword,
        }),
      );
      final data = jsonDecode(response.toString());
      debugPrint("$data");
      final accessToken = data['access_token'];
      final refreshToken = data['refresh_token'];
      await storage.write(key: 'access_token', value: accessToken);
      await storage.write(key: 'refresh_token', value: refreshToken);
      debugPrint("${await storage.readAll()}");
      return accessToken;
    } catch (e) {
      debugPrint('[REGISTER_ERROR]' + e.toString());
      return null;
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/login',
        data: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.toString());
      final accessToken = data['access_token'];
      final refreshToken = data['refresh_token'];
      await storage.write(key: 'access_token', value: accessToken);
      await storage.write(key: 'refresh_token', value: refreshToken);
      return accessToken;
    } catch (e) {
      debugPrint('[LOGIN_ERROR]' + e.toString());
      return null;
    }
  }

  Future<void> logout() async {
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'refresh_token');
  }
}
