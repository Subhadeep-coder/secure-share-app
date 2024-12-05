import 'dart:math';
import 'package:app/models/user_model.dart';
import 'package:app/services/user/auth_service.dart';
import 'package:app/services/user/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  UserModel? user; // UserModel to hold fetched data
  String? imagePath;
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final profileService = ProfileService(ref: ref); // Access ProfileService

    try {
      // Fetch user profile using ProfileService
      UserModel? fetchedUser = await profileService.getProfile();
      if (fetchedUser != null) {
        // Create a Random object
        final Random random = Random();

        // Generate a random number between 1 and 9 (inclusive)
        final int randomNumber = random.nextInt(9) + 1;
        String image = "assets/pfp/pfp$randomNumber.png";
        setState(() {
          user = fetchedUser;
          imagePath = image;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> logout() async {
    final AuthService authService = AuthService();
    await authService.logout();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/auth', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Profile'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : user != null && imagePath!.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60, // Adjust the radius as needed
                          backgroundImage: AssetImage(imagePath!),
                        ),
                        const SizedBox(height: 16), // Spacing

                        // Name
                        Text(
                          user!.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8), // Spacing

                        // Email
                        Text(
                          user!.email,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                            height: 24), // Spacing before other content

                        // Removed Edit Profile button

                        const SizedBox(height: 16), // Spacing

                        ElevatedButton.icon(
                          onPressed: () {
                            // Action for Logout button
                            logout();
                          },
                          icon: const Icon(Icons.logout),
                          label: const Text('Logout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.red.shade300, // Changed button color
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(child: Text('Error fetching profile data')),
    );
  }
}
