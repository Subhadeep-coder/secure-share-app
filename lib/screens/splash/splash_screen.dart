import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _storage =
      const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  ); // Secure storage to store tokens
  @override
  void initState() {
    super.initState();
    _checkTokens(); // Check for tokens when the app starts
    // Future.delayed(const Duration(seconds: 3), () {
    //   Navigator.of(context).pushReplacementNamed('/intro');
    // });
  }

  Future<void> _checkTokens() async {
    // Retrieve tokens from secure storage
    String? accessToken = await _storage.read(key: 'access_token');
    String? refreshToken = await _storage.read(key: 'refresh_token');

    // Delay for splash effect (optional)
    await Future.delayed(const Duration(seconds: 3));

    if (accessToken != null || refreshToken != null) {
      // Redirect to home if either token is present
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      // Redirect to login/signup (auth) if no tokens are found
      Navigator.of(context).pushReplacementNamed('/intro');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/company.png', // Make sure you add the company logo in assets
              color: const Color.fromARGB(255, 78, 143, 255),
              height: 500,
              width: 500,
            ),
          ],
        ),
      ),
    );
  }
}
