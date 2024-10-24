import 'package:app/components/intro_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_view_indicator/flutter_page_view_indicator.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: const [
                IntroScreens(
                  icon: Icons.file_upload,
                  title: 'Share Files Securely',
                  description:
                      'Transfer your files with complete protection, wherever you are.',
                ),
                IntroScreens(
                  icon: Icons.lock,
                  title: 'End-to-End Encryption',
                  description:
                      'Only you and your recipient can access the files, ensuring total privacy.',
                ),
                IntroScreens(
                  icon: Icons.check_circle,
                  title: 'Fast, Easy, and Safe',
                  description:
                      'Effortless file sharing, without compromising security or speed.',
                ),
              ],
            ),
          ),
          PageViewIndicator(
            length: 3, // Number of pages
            currentIndex: _currentIndex,
            currentColor: Colors.blue, // Active dot color
            otherColor: Colors.grey, // Inactive dot color
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _currentIndex > 0
                      ? () {
                          _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        }
                      : null,
                  child: const Text(
                    'Previous',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: _currentIndex < 2
                      ? () {
                          _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        }
                      : () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/auth',
                              (Route<dynamic> route) =>
                                  false); // Navigate to the Auth screen
                        },
                  child: Text(
                    _currentIndex < 2 ? 'Next' : 'Get Started',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
