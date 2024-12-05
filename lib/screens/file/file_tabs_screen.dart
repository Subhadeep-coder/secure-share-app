import 'package:app/screens/auth/finger_print_screen.dart';
import 'package:app/screens/file/receive_files_tab.dart';
import 'package:app/screens/file/sent_files_tab.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class FileTabsScreen extends StatefulWidget {
  const FileTabsScreen({super.key});

  @override
  State<FileTabsScreen> createState() => _FileTabsScreenState();
}

class _FileTabsScreenState extends State<FileTabsScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticated = false;

  @override
  initState() {
    super.initState();
    _authenticate();
  }

  _authenticate() async {
    if (!_isAuthenticated) {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      if (canAuthenticateWithBiometrics) {
        try {
          final bool didAuthenticate = await auth.authenticate(
            localizedReason: "Unlock to use Secure Share",
            options: const AuthenticationOptions(
              biometricOnly: false,
            ),
          );
          setState(() {
            _isAuthenticated = didAuthenticate;
          });
        } catch (e) {
          debugPrint("$e");
        }
      }
    } else {
      setState(() {
        _isAuthenticated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: _isAuthenticated
          ? Scaffold(
              appBar: AppBar(
                title: const Text('Dashboard'),
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Sent Files', icon: Icon(Icons.upload)), // Tab 1
                    Tab(
                        text: 'Received Files',
                        icon: Icon(Icons.download)), // Tab 2
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
            )
          : FingerPrintScreen(authenticate: _authenticate),
    );
  }
}
