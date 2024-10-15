import 'dart:io';

import 'package:app/models/file_model.dart';
import 'package:app/services/file/file_service.dart';
import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadFileModal extends ConsumerStatefulWidget {
  final FileModel file;
  const DownloadFileModal({super.key, required this.file});

  @override
  ConsumerState<DownloadFileModal> createState() => _DownloadFileModalState();
}

class _DownloadFileModalState extends ConsumerState<DownloadFileModal> {
  // Access the file from the widget property
  TextEditingController passwordController = TextEditingController();
  String? password;
  void downloadFile(String password) async {
    final FileService fileService = FileService(ref: ref);
    // Request storage permissions
    var status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      try {
        String downloadsPath = '/storage/emulated/0/Download';
        String filePath = '$downloadsPath/${widget.file.fileName}';
        File file = File(filePath);
        print(filePath);
        final response =
            await fileService.getFileContent(widget.file.sharedId, password);

        // Check if response is not null
        if (response != null && response.isNotEmpty) {
          // Write the binary data to the file
          await file.writeAsBytes(response);

          // Notify the user that the download is complete
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("File downloaded")),
          );
          Navigator.pop(context); // Close the modal
        } else {
          // Handle case when response is null or empty
          throw Exception('Failed to download file: No data received.');
        }
      } catch (e) {
        print("Download error: $e");
      }
    } else {
      print("Storage permission denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    final file = widget.file;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Make the modal take minimum vertical space
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              file.fileName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "File Size: ",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black), // Hardcoded text bold and black
                  ),
                  TextSpan(
                    text: formatFileSize(file.fileSize), // Variable text
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black), // Downgraded font size and black
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Expires At: ",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black), // Hardcoded text bold and black
                  ),
                  TextSpan(
                    text: formatSharedAt(file.sharedAt), // Variable text
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black), // Downgraded font size and black
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Sender: ",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black), // Hardcoded text bold and black
                  ),
                  TextSpan(
                    text: file.receiverName, // Variable text
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black), // Downgraded font size and black
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Enter Password",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Enter Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  String password = passwordController.text;
                  // Check if password is null or empty
                  if (password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter a password.")),
                    );
                  } else {
                    // Proceed with downloading the file
                    // Call downloadFile safely
                    downloadFile(password);
                  }
                },
                icon: const Icon(Icons.download),
                label: const Text("Download"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
