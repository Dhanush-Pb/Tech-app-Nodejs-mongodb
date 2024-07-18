// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/model/config.dart';
import 'package:http/http.dart' as http;

class CreatePage extends StatefulWidget {
  CreatePage({Key? key, required this.userid}) : super(key: key);
  final String userid;
  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> registerUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var regBody = {
        'userid': widget.userid,
        'title': nameController.text,
        'desc': descriptionController.text,
      };

      try {
        var response = await http.post(
          Uri.parse(adddetailslink), // Replace with your API endpoint
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(regBody),
        );

        log(response.body);

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse['status']) {
            // Handle success as per your requirements
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Submission successful!'),
              ),
            );
            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Submission failed. Please try again.'),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to submit. Please try again.'),
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Create Your Tech Robo',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        height: 900,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 0, 0, 0), Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputField('Innovative Tech Idea',
                      controller: nameController),
                  const SizedBox(height: 16),
                  _buildInputField('Detailed Description',
                      maxLines: 6, controller: descriptionController),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => registerUser(context),
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                            color: const Color.fromARGB(255, 113, 113, 113),
                            width: 0.4), // Add
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text('Submit'),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset('assets/images/shutterstock_1200990472.jpg'),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: const Text(
                      'The great growling engine of change – technology',
                      style:
                          TextStyle(color: Color.fromARGB(255, 142, 142, 142)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label,
      {int maxLines = 1, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color.fromARGB(255, 21, 21, 21),
            border: const OutlineInputBorder(),
            hintText: label,
            hintStyle: const TextStyle(color: Colors.white54),
          ),
          style: const TextStyle(color: Colors.white),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a value';
            }
            return null;
          },
        ),
      ],
    );
  }
}
