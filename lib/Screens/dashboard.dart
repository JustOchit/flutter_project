// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ppb_progress/theme_style.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  String? _name;
  String? _email;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser; // Get the currently logged-in user

    if (user != null) {
      try {
        // Fetch user profile from Firestore based on UID
        DocumentSnapshot userDoc =
            await _firestore.collection('userProfile').doc(user.uid).get();

        if (userDoc.exists) {
          setState(() {
            _name = userDoc['name']; // Retrieve the name
            _email = userDoc['email']; // Retrieve the email
            _profileImageUrl =
                userDoc['imageLink']; // Retrieve the profile image URL
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User profile data not found.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildProfile(),
    );
  }

  Widget _buildProfile() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _profileImageUrl != null
              ? CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(_profileImageUrl!),
                )
              : CircleAvatar(
                  radius: 60,
                  child: Icon(Icons.person, size: 60),
                ),
          SizedBox(height: 20),
          Text(
            _name ?? 'Name not found',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            _email ?? 'Email not found',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
