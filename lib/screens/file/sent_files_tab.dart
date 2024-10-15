import 'package:app/models/file_model.dart';
import 'package:app/screens/file/delete_file_modal.dart';
import 'package:app/services/file/file_service.dart';
import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SentFilesTab extends ConsumerStatefulWidget {
  const SentFilesTab({super.key});
  @override
  ConsumerState<SentFilesTab> createState() => _SentFilesTabState();
}

class _SentFilesTabState extends ConsumerState<SentFilesTab> with RouteAware {
  List<FileModel> sentFiles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getSentFiles(); // Call the API on widget init
  }

// This method is called when the current screen comes back into view.
  @override
  void didPopNext() {
    super.didPopNext();
    // Refresh the data when coming back to this screen
    getSentFiles();
  }

  Future<void> getSentFiles() async {
    final FileService fileService = FileService(ref: ref);
    final files = await fileService.getSentFiles();

    setState(() {
      sentFiles = files ?? []; // Update the file list
      isLoading = false;
    });
  }

  void _openDeleteFileModal(BuildContext context, FileModel file) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext content) {
          return DeleteFileModal(
            file: file,
            onFileDeleted: () {
              // Remove the file from the local state when it's deleted
              setState(() {
                sentFiles.removeWhere((f) => f.sharedId == file.sharedId);
              });
            },
          );
        });
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
          "You haven't sent any file.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: sentFiles.length,
        itemBuilder: (context, index) {
          final file = sentFiles[index];
          debugPrint(file.toJson().toString());
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.file_present, size: 40),
                const SizedBox(width: 12), // Space between icon and text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${file.fileName} (${formatFileSize(file.fileSize)})",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow
                            .ellipsis, // Ensure text doesn't overflow
                      ),
                      Text(
                        file.receiverName,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                IntrinsicHeight(
                  // Automatically adjusts the height
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatSharedAt(file.sharedAt),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      IconButton(
                        onPressed: () {
                          _openDeleteFileModal(context, file);
                        },
                        icon: const Icon(Icons.delete),
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
