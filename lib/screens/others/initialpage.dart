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
      body: Container(child:Center(
          child: Container(
              child: Column(children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Text("GATO: La app de control de vida",
                style: TextStyle(
                  fontSize: 25,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 6
                    ..color = Colors.blue[300],
                ))),
        Padding(
            padding: EdgeInsets.only(top: 40, left: 40),
            child: Text("By Natsuki",
                style: TextStyle(
                  fontSize: 20,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 6
                    ..color = Colors.blue[400],
                )))
      ]))),
    ));
  }
}
