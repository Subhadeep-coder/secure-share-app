import 'package:app/main.dart';
import 'package:app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileService {
  final WidgetRef ref;

  ProfileService({required this.ref});

  Future<UserModel?> getProfile() async {
    final api = ref.read(apiProvider); // Access the apiProvider instance

    try {
      // Example GET request to fetch user profile
      final response = await api.api.get('/user/get-me');
      final user = response.data['data']['user'];
      // Assuming you want to convert the response into UserModel
      return UserModel.fromJson(
          {'id': user['id'], 'name': user['name'], 'email': user['email']});
    } catch (e) {
      debugPrint('Error fetching profile data: $e');
      return null;
    }
  }

  Future<List<UserModel>?> searchUsers(String email) async {
    final api = ref.read(apiProvider); // Access the apiProvider instance

    try {
      // Example GET request to fetch user profile
      final response = await api.api.get('/user/filter-user?email_text=$email');
      final List<dynamic> users = response.data['users'];

      return users
          .map((user) => UserModel.fromJson(
              {'id': user['id'], 'name': user['name'], 'email': user['email']}))
          .toList();
    } catch (e) {
      debugPrint('Error fetching profile data: $e');
      return null;
    }
  }
}
