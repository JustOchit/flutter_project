// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, avoid_print, prefer_const_constructors

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ppb_progress/Screens/login.dart';
import 'dart:io';
import 'package:ppb_progress/theme_style.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  File? _profileImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _registerUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        await saveProfile(userCredential.user!.uid);
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> saveProfile(String uid) async {
    String name = _nameController.text;
    String password = _passwordController.text;
    String email = _emailController.text;

    if (_profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a profile image')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      Uint8List imageBytes = await _profileImage!.readAsBytes();
      String resp = await StoreData().saveData(
          name: name, password: password, email: email, file: imageBytes);

      if (resp == 'success') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $resp')),
        );
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $err')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppStyle.bgDefault,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.0),
              constraints: BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _isLoading
                      ? CircularProgressIndicator()
                      : _buildRegisterForm(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Container(
      padding: EdgeInsets.all(25.0),
      decoration: AppStyle.bgContainer,
      child: Column(
        children: [
          Text('Register', style: AppStyle.headline1),
          SizedBox(height: 20),
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 60,
              backgroundImage:
                  _profileImage != null ? FileImage(_profileImage!) : null,
              child: _profileImage == null
                  ? Icon(Icons.camera_alt, size: 60, color: AppStyle.whtColor)
                  : null,
            ),
          ),
          SizedBox(height: 20),
          CustomTextField(
            controller: _nameController,
            label: 'Name',
            icon: Icons.person,
          ),
          SizedBox(height: 20),
          CustomTextField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email,
          ),
          SizedBox(height: 20),
          CustomTextField(
            controller: _passwordController,
            label: 'Password',
            icon: Icons.lock,
            obscureText: true,
          ),
          SizedBox(height: 30),
          CustomElevatedButton(
            text: 'Register',
            onPressed: _registerUser,
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Already have an account?',
                  style: TextStyle(color: AppStyle.gryColor)),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(AppStyle.createRoute(LoginPage()));
                },
                child: Text('Back to Login',
                    style: TextStyle(color: AppStyle.fifthColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StoreData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage
        .ref()
        .child(childName)
        .child('profile_${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData({
    required String name,
    required String password,
    required Uint8List file,
    required String email, // Make sure to pass the email
  }) async {
    String resp = "Some Error Occurred";
    try {
      if (name.isNotEmpty && password.isNotEmpty && email.isNotEmpty) {
        String imageUrl =
            await uploadImageToStorage('profileImage', file); // Upload image
        await _firestore
            .collection('userProfile')
            .doc(_auth.currentUser!.uid)
            .set({
          'name': name,
          'password':
              password, // Not recommended, consider using Firebase Auth for password handling
          'email': email, // Store the user's email in Firestore
          'imageLink': imageUrl,
        });
        resp = 'success';
      }
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }
}
