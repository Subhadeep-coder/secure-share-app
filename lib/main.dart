import 'package:app/screens/auth/login_screen.dart';
import 'package:app/screens/auth/signup_screen.dart';
import 'package:app/screens/auth/auth_screen.dart';
import 'package:app/screens/file/file_tabs_screen.dart';
import 'package:app/screens/file/upload_file_screen.dart';
import 'package:app/screens/splash/intro.dart';
import 'package:app/screens/splash/splash_screen.dart';
import 'package:app/screens/user/profile_screen.dart';
import 'package:app/services/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiProvider = Provider((ref) => Api());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
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
        '/': (context) => SplashScreen(),
        '/intro': (context) => IntroScreen(),
        '/auth': (context) => AuthScreen(),
        '/home': (context) => FileTabsScreen(),
        '/signup': (context) => SignupScreen(),
        '/login': (context) => LoginScreen(),
        '/profile': (context) => ProfileScreen(),
        '/upload-file': (context) => UploadFileScreen(),
      },
    );
  }
}
