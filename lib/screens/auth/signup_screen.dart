import 'package:app/components/default_button.dart';
import 'package:app/components/default_text_field.dart';
import 'package:app/services/user/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String? name, email, password, cPassword;
  bool isLoading = false;

  Future<void> _register(
      String name, String email, String password, String cPassword) async {
    if (password != cPassword) return;
    setState(() {
      isLoading = true;
    });
    final res = await _authService.register(name, email, password, cPassword);
    if(res==null){
      
    }
    _formKey.currentState?.reset();
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pushReplacementNamed('/login');
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
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width * 0.05),
                      child: const Text(
                        'Register Now',
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
                            label: 'Name',
                            hintText: "Enter your name",
                            onSaved: (newValue) {
                              setState(() {
                                name = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
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
                          DefaultTextField(
                            label: 'Confirm Password',
                            hintText: "Confirm your password",
                            obsecure: true,
                            onSaved: (newValue) {
                              setState(() {
                                cPassword = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          DefaultButton(
                            hintText: 'Register',
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _formKey.currentState?.save();
                                _register(name!, email!, password!, cPassword!);
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
