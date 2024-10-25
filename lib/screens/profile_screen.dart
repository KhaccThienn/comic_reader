import 'dart:io';
import 'package:anim_search/commons/constants.dart';
import 'package:anim_search/models/comic.dart';
import 'package:anim_search/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late File? _avatar;
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatar = File(pickedFile.path);
      });
    }
  }

  Future<void> putData() async {
    Logger log = Logger();
    var prefs = await SharedPreferences.getInstance();
    var userId = int.parse(prefs.getString("userId")!);

    String name = _nameController.text;
    String email = _emailController.text;

    // Create the User object
    User user = User(
      id: userId,
      name: name,
      email: email,
      password: "", // You can retrieve this if needed or leave it blank
      avatar: "", // Avatar will be handled separately for the file upload
      role: "user", // Assuming a default role
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      reviews: [], // Optional, pass an empty list if not needed
    );

    // Call updateInformation method to send data
    final result = await Provider.of<DataProvider>(context, listen: false)
        .updateInformation(userId, user, _avatar != null, _avatar?.path ?? "");
    log.d(result.statusCode);
    if (result.statusCode == 200) {
      // Success logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    } else {
      // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile!')),
      );
    }
  }

  Future<void> getUserData() async {
    var prefs = await SharedPreferences.getInstance();
    var userId = int.parse(prefs.getString("userId")!);

    // Fetch user data using the DataProvider
    var provider = await Provider.of<DataProvider>(context, listen: false);
    final userData = await Provider.of<DataProvider>(context, listen: false).getUserData(userId);

    // Assuming userData is of type User and has fields name and email
    if (provider.user1 != null) {
      setState(() {
        _nameController.text = provider.user1.name;
        _emailController.text = provider.user1.email;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _avatar = null;
    getUserData(); // Fetch user data when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final dataProvider = Provider.of<DataProvider>(context);
    final User user = dataProvider.user1;
    final String old_avatar = "${Constants.domain_uri}/${user.avatar}";
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.transparent,
                    backgroundImage: _avatar != null
                        ? FileImage(_avatar!)
                        : NetworkImage(old_avatar),
                  ),
                ),
              ),
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.deepOrangeAccent),
                child: IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  onPressed: _pickImage,
                ),
              ),
              const SizedBox(height: 50),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        label: const Text('Full Name'),
                        prefixIcon: const Icon(Icons.person),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepOrangeAccent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        label: const Text('Email'),
                        prefixIcon: const Icon(Icons.email),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepOrangeAccent),
                        ),
                      ),
                    ),
                    // Uncomment this block if you want to include the password field
                    // const SizedBox(height: 15),
                    // TextFormField(
                    //   decoration: InputDecoration(
                    //     label: const Text('Password'),
                    //     prefixIcon: const Icon(Icons.lock),
                    //     enabledBorder: UnderlineInputBorder(
                    //       borderSide: BorderSide(color: Colors.grey.shade400),
                    //     ),
                    //     focusedBorder: const UnderlineInputBorder(
                    //       borderSide: BorderSide(color: Colors.deepOrangeAccent),
                    //     ),
                    //   ),
                    //   obscureText: true,
                    // ),
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
