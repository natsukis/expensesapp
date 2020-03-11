import 'package:flutter/material.dart';
import 'package:gastosapp/screens/menu.dart';
import 'package:gastosapp/screens/others/initialpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Control de Gastos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.cyan,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.cyan,
      ),
      body: SplashScreen()
     );}
}
