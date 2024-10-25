import 'dart:io';

import 'package:anim_search/commons/constants.dart';
import 'package:anim_search/models/comic.dart';
import 'package:anim_search/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  Future<void> putData() async {
    if (_formKey.currentState!.validate()) {
      // If form is valid, proceed with data submission
      Logger log = Logger();
      var prefs = await SharedPreferences.getInstance();
      var userId = int.parse(prefs.getString("userId")!);

      String oldPass = _oldPassController.text;
      String newPass = _newPassController.text;

      // Call updateInformation method to send data
      final result = await Provider.of<DataProvider>(context, listen: false)
          .UpdatePassword(userId: userId, oldPass: oldPass, newPass: newPass);
      log.d(result);
      if (result) {
        // Success logic
        _oldPassController.clear();
        _newPassController.clear();
        _confirmPassController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully!')),
        );
      } else {
        // Error handling
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating password!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final dataProvider = Provider.of<DataProvider>(context);
    final User? user = dataProvider.user1;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: [
              const Center(
                child: Text(
                  "Update Password",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey, // Assign form key
                child: Column(
                  children: [
                    TextFormField(
                      controller: _oldPassController,
                      decoration: InputDecoration(
                        label: const Text('Old Password'),
                        prefixIcon: const Icon(Icons.key),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepOrangeAccent),
                        ),
                      ),
                      obscureText: true, // Hide password input
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your old password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _newPassController,
                      decoration: InputDecoration(
                        label: const Text('New Password'),
                        prefixIcon: const Icon(Icons.key),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepOrangeAccent),
                        ),
                      ),
                      obscureText: true, // Hide password input
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a new password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _confirmPassController,
                      decoration: InputDecoration(
                        label: const Text('Confirm Password'),
                        prefixIcon: const Icon(Icons.key),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepOrangeAccent),
                        ),
                      ),
                      obscureText: true, // Hide password input
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        } else if (value != _newPassController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: putData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

