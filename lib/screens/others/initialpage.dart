import 'package:flutter/material.dart';
import 'package:gastosapp/screens/menu.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(milliseconds: 1500),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => Menu())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Container(              
        child:Padding(
            padding: EdgeInsets.only(top: 40, left: 40),
            child: Stack(
  children: <Widget>[
    // Stroked text as border.
    Text(
      'By Natsuki',
      style: TextStyle(
        fontSize: 40,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..color = Colors.blue[700],
      ),
    ),
    // Solid text as fill.
    Text(
      'By Natsuki',
      style: TextStyle(
        fontSize: 40,
        color: Colors.grey[300],
      ),
    ),
  ],
))
      )),
    );
  }
}
