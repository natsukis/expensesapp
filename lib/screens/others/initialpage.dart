import 'package:flutter/material.dart';
import 'package:gastosapp/screens/menu.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';


class IntroScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IntroScreenState();
}
class IntroScreenState extends State {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

 
    slides.add(
      new Slide(
        title: "RULER",
        description:
        "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of",
        
        backgroundColor: Color(0xff9932CC),
      ),
    );
  }

  void onDonePress() {
   Navigator.of(context).pushReplacement(
                        new MaterialPageRoute(builder: (context) => Menu()));
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
    );
  }
}