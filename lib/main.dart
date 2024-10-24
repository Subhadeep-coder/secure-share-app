import 'package:app/screens/auth/login_screen.dart';
import 'package:app/screens/auth/signup_screen.dart';
import 'package:app/screens/auth/auth_screen.dart';
import 'package:app/screens/file/file_tabs_screen.dart';
import 'package:app/screens/file/upload_file_screen.dart';
import 'package:app/screens/splash/intro.dart';
import 'package:app/screens/splash/splash_screen.dart';
import 'package:app/screens/user/profile_screen.dart';
import 'package:app/services/api.dart';
import 'package:app/utils/root_det.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiProvider = Provider((ref) => Api());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // Check for root/jailbreak
  bool isDeviceCompromised = await checkDeviceIntegrity();
  if (isDeviceCompromised) {
    runApp(const CompromisedDeviceApp());
  } else {
    runApp(
      ProviderScope(
        overrides: [apiProvider],
        child: const MyApp(),
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Secure Share',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/intro': (context) => const IntroScreen(),
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const FileTabsScreen(),
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/upload-file': (context) => const UploadFileScreen(),
      },
    );
  }
}
