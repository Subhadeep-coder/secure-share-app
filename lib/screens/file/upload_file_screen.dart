import 'dart:async';
import 'dart:io';
import 'package:app/components/default_button.dart';
import 'package:app/components/default_text_field.dart';
import 'package:app/components/permission_denied_dialog.dart';
import 'package:app/models/user_model.dart';
import 'package:app/services/file/file_service.dart';
import 'package:app/services/user/profile_service.dart';
import 'package:app/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadFileScreen extends ConsumerStatefulWidget {
  const UploadFileScreen({super.key});

  @override
  ConsumerState<UploadFileScreen> createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends ConsumerState<UploadFileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? receiverEmail, password;
  DateTime? expirationDate;
  File? selectedFile;
  PlatformFile? platformFile;
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _debounce?.cancel(); // Cancel the timer when disposing
    _emailController.dispose(); // Dispose the controller
    super.dispose();
  }

// Debounce variables
  Timer? _debounce; // Timer for debouncing
  List<String> _fetchedEmails = []; // List to hold fetched emails

  void _openAppSettings() async {
    await openAppSettings(); // Open app settings
  }

  // Function to pick a file (from gallery)
  Future<void> pickFile() async {
    // Request storage permissions
    var status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      // Pick a file using FilePicker
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.isNotEmpty) {
        // Get the PlatformFile (metadata)
        platformFile = result.files.first;

        // Check if the path exists (only for mobile/desktop platforms)
        if (platformFile!.path != null) {
          selectedFile = File(
              platformFile!.path!); // Convert to File only when the path exists
        } else {
          // Handle cases where path is null (e.g., on web platform)
          selectedFile = null; // No path on web, hence no File conversion
        }
        debugPrint("Selected File: ${selectedFile!.uri.path.split('/').last}");

        setState(() {}); // Trigger UI update
      } else {
        print('No file selected');
      }
    } else if (status.isDenied) {
      showMessage(
          "Storage permission denied. Please enable it in settings.", context);
    } else if (status.isPermanentlyDenied) {
      showMessage(
          "Storage permission permanently denied. Please enable it in settings.",
          context);
      // Optionally, show a button to open settings
      // You can prompt the user with a dialog to go to settings
      showDialog(
        context: context,
        builder: (context) =>
            PermissionDeniedDialog(onOpenSettings: _openAppSettings),
      );
    }
  }

  // Method to clear the selected file
  void _clearSelectedFile() {
    setState(() {
      selectedFile = null; // Remove the selected file
    });
  }

  // Method to pick a date using showDatePicker
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != expirationDate) {
      setState(() {
        expirationDate = picked;
      });
    }
  }

  uploadFile(String receiverEmail, String password, String expirationDate,
      File file) async {
    final FileService fileService = FileService(ref: ref);
    await fileService.sendFile(receiverEmail, password, expirationDate, file);
    _formKey.currentState?.reset();
    Navigator.of(context).pushReplacementNamed('/home');
  }

  // Debounce function to handle the user input for searching emails
  void _debounceSearch(String email) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (email.isNotEmpty) {
        await searchUsers(email);
      } else {
        setState(() {
          _fetchedEmails = []; // Clear the list if input is empty
        });
      }
    });
  }

  Future<void> searchUsers(String email) async {
    final ProfileService profileService = ProfileService(ref: ref);
    List<UserModel>? users = await profileService
        .searchUsers(email); // Assuming it returns a list of emails

    List<String> emails =
        users != null ? users.map((user) => user.email).toList() : [];
    setState(() {
      _fetchedEmails = emails; // Update the list with fetched emails
    });
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
        title: const Text("Secure Share"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.width * 0.05),
                  child: const Text(
                    "Share a file",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.width * 0.1),
                      DefaultTextField(
                        label: 'Receiver Email',
                        hintText: "Enter receiver email",
                        controller: _emailController,
                        onSaved: (newValue) {
                          setState(() {
                            receiverEmail =
                                newValue; // Update the receiverEmail variable
                          });
                        },
                        onChanged: (newValue) {
                          _debounceSearch(newValue); // Call debounce function
                        },
                      ),
                      if (_fetchedEmails
                          .isNotEmpty) // Show dropdown if emails are fetched
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: SizedBox(
                            height: 100.0,
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              separatorBuilder: (context, index) =>
                                  const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        15.0), // Horizontal padding for the divider
                                child: Divider(),
                              ),
                              itemCount: _fetchedEmails.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 40.0,
                                  alignment: Alignment.center,
                                  child: ListTile(
                                    title: Text(_fetchedEmails[index]),
                                    onTap: () {
                                      setState(() {
                                        receiverEmail = _fetchedEmails[
                                            index]; // Set the selected email
                                        _emailController.text =
                                            _fetchedEmails[index];
                                        _fetchedEmails =
                                            []; // Clear the list after selection
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      DefaultTextField(
                        label: 'Password',
                        hintText: "Enter password for file",
                        obsecure: true,
                        onSaved: (newValue) {
                          setState(() {
                            password = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Select an expiration date",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                expirationDate == null
                                    ? "Select a date"
                                    : "Date: ${getFormattedDateForDisplay(expirationDate)}",
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () => _pickDate(context),
                                child: Text(
                                  expirationDate == null
                                      ? "Select Expiration Date"
                                      : "Edit",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Select a File to share",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              selectedFile != null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          selectedFile!.path
                                              .split('/')
                                              .last, // Display the file name
                                          overflow: TextOverflow
                                              .ellipsis, // Handle overflow
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close,
                                              color: Colors.red),
                                          onPressed:
                                              _clearSelectedFile, // Remove file on click
                                        ),
                                      ],
                                    )
                                  : const Text("No file selected"),
                              selectedFile == null
                                  ? ElevatedButton(
                                      onPressed: pickFile,
                                      child: const Text('Pick File'),
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      DefaultButton(
                        hintText: 'Share File',
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _formKey.currentState?.save();
                            uploadFile(
                                receiverEmail!,
                                password!,
                                getFormattedDate(expirationDate),
                                selectedFile!);
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
