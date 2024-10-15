import 'package:app/models/file_model.dart';
import 'package:app/services/file/file_service.dart';
import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteFileModal extends ConsumerStatefulWidget {
  final FileModel file;
  final VoidCallback onFileDeleted;
  const DeleteFileModal({
    super.key,
    required this.file,
    required this.onFileDeleted,
  });

  @override
  ConsumerState<DeleteFileModal> createState() => _DeleteFileModalState();
}

class _DeleteFileModalState extends ConsumerState<DeleteFileModal> {
  Future<void> deleteFile(String shareId) async {
    final FileService fileService = FileService(ref: ref);
    await fileService.deleteFile(shareId);
    widget.onFileDeleted();
    Navigator.pop(context);
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
            Text(
              "File Size: ${formatFileSize(file.fileSize)}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Expires At: ${formatSharedAt(file.sharedAt)}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Sent to: ${file.receiverName}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text("Cancel"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      deleteFile(file.sharedId);
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
