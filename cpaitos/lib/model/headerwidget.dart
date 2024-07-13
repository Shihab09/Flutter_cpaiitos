import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String text;

  HeaderWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10, bottom: 2, top: 20),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      color: Colors.white,
    );
  }
}
