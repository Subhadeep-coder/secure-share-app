import 'package:flutter/material.dart';

class FingerPrintScreen extends StatelessWidget {
  final VoidCallback authenticate;
  const FingerPrintScreen({super.key, required this.authenticate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Column(
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 36,
                ),
                Text(
                  "Secure Share Locked",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: authenticate,
              style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Sharp corners
                ),
              ),
              child: const Text(
                "Unlock",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
