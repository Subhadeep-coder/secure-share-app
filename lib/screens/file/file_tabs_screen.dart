import 'package:app/screens/file/receive_files_tab.dart';
import 'package:app/screens/file/sent_files_tab.dart';
import 'package:flutter/material.dart';

class FileTabsScreen extends StatelessWidget {
  const FileTabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Sent Files', icon: Icon(Icons.upload)), // Tab 1
              Tab(text: 'Received Files', icon: Icon(Icons.download)), // Tab 2
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'File Share') {
                    Navigator.of(context).pushNamed('/upload-file');
                  } else if (value == 'Profile') {
                    // Navigate to settings screen (implement this screen later)
                    Navigator.of(context).pushNamed('/profile');
                  }
                },
                itemBuilder: (BuildContext context) {
                  return const [
                    PopupMenuItem(
                      value: 'File Share',
                      child: Text('Share a file'),
                    ),
                    PopupMenuItem(
                      value: 'Profile',
                      child: Text('Profile'),
                    ),
                  ];
                },
                icon: const Icon(Icons.more_vert),
                offset: const Offset(
                    0, 50), // Adjust position (lower down the menu)
                constraints: const BoxConstraints(
                  minWidth: 200, // Make the dropdown wider
                ), // Three dots icon for dropdown
              ),
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            SentFilesTab(), // Content for Sent Files tab
            ReceivedFilesTab(), // Content for Received Files tab
          ],
        ),
      ),
    );
  }
}
