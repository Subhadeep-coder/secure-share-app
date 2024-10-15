import 'dart:io';
import 'package:app/models/file_model.dart';
import 'package:path/path.dart';
import 'package:app/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FileService {
  final WidgetRef ref;

  FileService({required this.ref});

  Future<void> sendFile(
    String receipentEmail,
    String password,
    String expirationDate,
    File file,
  ) async {
    final api = ref.read(apiProvider); // Access the apiProvider instance
    try {
      // Prepare FormData with file and other fields
      FormData formData = FormData.fromMap({
        'recipient_email': receipentEmail, // Additional field
        'password': password, // Additional field
        'expiration_date': expirationDate, // Additional field
        'fileUpload': await MultipartFile.fromFile(
          file.path,
          filename: basename(file.path), // Get filename
        ),
      });
      final response = await api.api.post('/file/upload-file', data: formData);
      print(response.data);
    } catch (e) {
      debugPrint('Error fetching profile data: $e');
    }
    return;
  }

  Future<List<FileModel>?> getSentFiles() async {
    final api = ref.read(apiProvider);
    try {
      final response = await api.api.get("/file/get-my-files");
      final List<dynamic> fileList = response.data;

      // Convert the response into a list of FileModel
      return fileList.map((file) => FileModel.fromJson(file)).toList();
    } catch (e) {
      debugPrint('Error fetching files: $e');
      return null;
    }
  }

  Future<List<FileModel>?> getRecievedFiles() async {
    final api = ref.read(apiProvider);
    try {
      final response = await api.api.get("/file/get-recieved-files");
      final List<dynamic> fileList = response.data;

      // Convert the response into a list of FileModel
      return fileList.map((file) => FileModel.fromJson(file)).toList();
    } catch (e) {
      debugPrint('Error fetching files: $e');
      return null;
    }
  }

  Future<List<int>?> getFileContent(String shareId, String password) async {
    final api = ref.read(apiProvider);
    try {
      final response = await api.api.post(
        "/file/retrieve-file",
        data: {
          'shared_id': shareId,
          'password': password,
        },
      );

      // Directly access the 'file' key from the response data
      if (response.data['file'] != null) {
        List<int> fileData = List<int>.from(response.data['file']);
        return fileData; // Return the binary data
      } else {
        debugPrint("[ERROR_FETCHING_FILE] No file data found.");
        return null;
      }
    } catch (e) {
      debugPrint("[ERROR_FETCHING_FILE] $e");
      return null;
    }
  }

  Future<void> deleteFile(String shareId) async {
    final api = ref.read(apiProvider);
    try {
      final response = await api.api.delete(
        "/file/delete-file?share_id=$shareId",
      );

      debugPrint(response.statusCode.toString());
    } catch (e) {
      debugPrint("[ERROR_DELETE_FILE]: $e");
    }
  }
  
}
