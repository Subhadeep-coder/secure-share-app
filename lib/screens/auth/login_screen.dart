import 'package:app/components/default_button.dart';
import 'package:app/components/default_text_field.dart';
import 'package:app/services/user/auth_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String? email, password;
  bool isLoading = false;

  Future<void> _login(String email, String password) async {
    setState(() {
      isLoading = true;
    });
    await _authService.login(email, password);
    _formKey.currentState?.reset();
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pushReplacementNamed('/home');
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
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width * 0.05),
                      child: const Text(
                        'Welcome back!',
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
                          SizedBox(
                              height: MediaQuery.of(context).size.width * 0.1),
                          DefaultTextField(
                            label: 'Email',
                            hintText: "Enter your email",
                            onSaved: (newValue) {
                              setState(() {
                                email = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          DefaultTextField(
                            label: 'Password',
                            hintText: "Enter your password",
                            obsecure: true,
                            onSaved: (newValue) {
                              setState(() {
                                password = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          DefaultButton(
                            hintText: 'Login',
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _formKey.currentState?.save();
                                _login(email!, password!);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              const Opacity(
                opacity: 0.8,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}