import 'package:flutter/material.dart';

import 'views/splashscreen.dart';
// import 'package:fluttertest/views/HomePage.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  // gotoSecondActivity(BuildContext context){
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => LoginPage()),
  //   );

  //}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
