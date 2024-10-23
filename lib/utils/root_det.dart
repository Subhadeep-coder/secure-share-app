import 'package:flutter/material.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

Future<bool> checkDeviceIntegrity() async {
  bool jailbroken = await FlutterJailbreakDetection.jailbroken;
  bool developerMode = await FlutterJailbreakDetection.developerMode;
  bool isSafeDevice = !(jailbroken || developerMode);
  return isSafeDevice;
}

class CompromisedDeviceApp extends StatelessWidget {
  const CompromisedDeviceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'This app cannot run on a rooted or jailbroken device.',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
