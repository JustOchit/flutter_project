// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AppStyle {
  // =========== COLOR ==========
  static const Color firstColor = Color.fromARGB(255, 15, 76, 117);
  static const Color secondColor = Color.fromARGB(255, 50, 130, 184);
  static const Color thirdColor = Color.fromARGB(255, 187, 225, 250);
  static const Color fourthColor = Color.fromARGB(255, 27, 38, 44);
  static const Color fifthColor = Color.fromARGB(255, 0, 173, 181);

  static const Color blkColor = Colors.black;
  static const Color whtColor = Colors.white;
  static const Color gryColor = Colors.grey;

  // =========== TEXT ==========
  static TextStyle get headline1 => TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: secondColor,
      );

  static TextStyle get bodyText1 => TextStyle(
        fontSize: 16,
        color: firstColor,
      );

  static TextStyle get bodyText2 => TextStyle(
        fontSize: 14,
        color: firstColor,
      );

  static TextStyle get subtitle1 => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: fourthColor,
      );

  // =========== BUTTON ==========
  static ButtonStyle get defaultButton => ElevatedButton.styleFrom(
        foregroundColor: blkColor,
        backgroundColor: secondColor,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 100),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        textStyle: TextStyle(
          fontSize: 18, // Adjust the font size here
          fontWeight: FontWeight.bold, // Optionally, adjust the font weight
        ),
      );

  // =========== TEXT FIELD ==========
  static InputDecorationTheme get inputDecoration => InputDecorationTheme(
        filled: true,
        fillColor: blkColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: fifthColor),
          borderRadius: BorderRadius.circular(30.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: secondColor),
          borderRadius: BorderRadius.circular(30.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: secondColor),
          borderRadius: BorderRadius.circular(30.0),
        ),
      );

  // =========== BACKGROUND ==========
  static BoxDecoration get bgDefault => BoxDecoration(
        gradient: LinearGradient(
          colors: [firstColor, secondColor, fifthColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );

  // =========== LOGO ==========
  Widget get logoImg => ClipOval(
        child: Image.asset(
          'assets/img/robo_nobg.png',
          width: 180,
          height: 180,
          fit: BoxFit.cover,
        ),
      );

  // =========== AVATAR ==========
  static CircleAvatar get placeHolder => CircleAvatar(
        backgroundColor: whtColor,
        radius: 60,
        child: Icon(
          Icons.person,
          size: 60,
          color: fifthColor,
        ),
      );

  // =========== CONTAINER ==========
  static BoxDecoration get bgContainer => BoxDecoration(
        color: whtColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: blkColor.withAlpha(50),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      );

  // ========== Page Trasnsition ==========

  static Route createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}

// ========== Custom Text Field & Elevated Button ==========

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppStyle.firstColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppStyle.fifthColor),
          borderRadius: BorderRadius.circular(30.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppStyle.secondColor),
          borderRadius: BorderRadius.circular(30.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppStyle.secondColor),
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: AppStyle.defaultButton,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
