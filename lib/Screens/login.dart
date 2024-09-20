// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ppb_progress/theme_style.dart';
import 'package:ppb_progress/Screens/register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      Navigator.pushReplacementNamed(context, '/dashboard');
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
                      : _buildLoginForm(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: EdgeInsets.all(25.0),
      decoration: AppStyle.bgContainer,
      child: Column(
        children: [
          AppStyle().logoImg,
          Text('Login', style: AppStyle.headline1),
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
            text: 'Login',
            onPressed: _loginUser,
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Don\'t have an account?',
                  style: TextStyle(color: AppStyle.gryColor)),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(AppStyle.createRoute(RegisterPage()));
                },
                child: Text('Register here!', style: TextStyle(color: AppStyle.fifthColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
