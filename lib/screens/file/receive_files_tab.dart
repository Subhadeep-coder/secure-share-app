import 'package:app/models/file_model.dart';
import 'package:app/screens/file/download_file_modal.dart';
import 'package:app/services/file/file_service.dart';
import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReceivedFilesTab extends ConsumerStatefulWidget {
  const ReceivedFilesTab({super.key});

  @override
  ConsumerState<ReceivedFilesTab> createState() => _ReceivedFilesTabState();
}

class _ReceivedFilesTabState extends ConsumerState<ReceivedFilesTab> {
  List<FileModel> sentFiles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getRecievedFiles(); // Call the API on widget init
  }

  Future<void> getRecievedFiles() async {
    final FileService fileService = FileService(ref: ref);
    final files = await fileService.getRecievedFiles();

    setState(() {
      sentFiles = files ?? []; // Update the file list
      isLoading = false;
    });
  }

  void _openFileDetailsModal(BuildContext context, FileModel file) {
    showDialog(
      context: context,
      builder: (BuildContext content) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9, // 90% width
            ),
            child: DownloadFileModal(file: file),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator()); // Show loading indicator
    } else if (sentFiles.isEmpty) {
      // Show message when there are no files
      return const Center(
        child: Text(
          "You have no received files.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: sentFiles.length,
        itemBuilder: (context, index) {
          final file = sentFiles[index];
          return ListTile(
            leading: const Icon(Icons.file_present),
            title: Text(
              "${file.fileName} (${formatFileSize(file.fileSize)})",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              file.receiverName,
              style: const TextStyle(fontSize: 14),
            ),
            trailing: Text(
              formatSharedAt(file.sharedAt),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            onTap: () {
              _openFileDetailsModal(
                  context, file); // Call function to open modal
            },
          );
        },
      );
    }
  }
}
