// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:frontend/model/config.dart'; // Ensure this import is correct
import 'package:frontend/view/screens/dashboard_page.dart'; // Ensure this import is correct
// Ensure this import is correct

class singupage extends StatefulWidget {
  singupage({super.key});

  @override
  State<singupage> createState() => _singupageState();
}

class _singupageState extends State<singupage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late SharedPreferences? prefrs; // Make SharedPreferences nullable

  @override
  void initState() {
    super.initState();
    initSharedPreferences(); // Initialize SharedPreferences
  }

  Future<void> initSharedPreferences() async {
    prefrs = await SharedPreferences.getInstance();
  }

  Future<void> registerUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var regBody = {
        'email': emailController.text,
        'password': passwordController.text,
      };

      try {
        var response = await http.post(
          Uri.parse(loginapi),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(regBody),
        );

        log(response.body);

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status']) {
            var myToken = jsonResponse['token'];
            prefrs!.setString('token', myToken);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => DashboardPage(token: myToken),
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registration failed. Please try again.'),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration failed. Please try again.'),
            ),
          );
        }
      } catch (e) {
        log(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Failed to connect. Please check your internet connection.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/HD-wallpaper-machine-high-tech-thumbnail.jpg', // Replace with your image asset path
              fit: BoxFit.cover,
            ),
          ),
          // Login form container
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 0, 0, 0),
                            hintText: 'Enter your email',
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 15.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: passwordController,
                          style: const TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 0, 0, 0),
                            hintText: 'Enter your password',
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 15.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 30.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            registerUser(context);
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
