import 'package:flutter/material.dart';
import 'dart:async';

import 'homepage.dart';
import 'loginpage.dart'; // Import the async library

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Add a delay of 3 seconds before navigating to the main screen
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/tos.jpg'),
            fit: BoxFit.fill, // Make the image stretch to fill the container
          ),
        ),
      ),
    );
  }
}
