import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gastosapp/screens/pickdate/picktwodates.dart';
import 'package:gastosapp/screens/pickdate/pickdate.dart';
import 'package:gastosapp/screens/expense/expensepage.dart';
import 'package:gastosapp/screens/inversion/inversionpage.dart';
import 'package:gastosapp/screens/income/incomepage.dart';

class SubMenu extends StatelessWidget {
  final String route;
  SubMenu(this.route);
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Image.asset(imageMenu(),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          alignment: Alignment.center),
    Scaffold(
        appBar: AppBar(
          title: Text(title()),
          backgroundColor: Colors.transparent,
        ),
        floatingActionButton: FloatingActionButton(
            child: Text("Volver", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.brown,
            onPressed: () {
              Navigator.pop(context, true);
            }),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.only(top: 90.0, left: 5.0, right: 5.0),
          child: Center(
              child: SingleChildScrollView(child: Column(children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: Container(
                    width: 180.0,
                    height: 50.0,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(28.0),
                          side: BorderSide(color: Colors.brown)),
                      textColor: Colors.white,
                      color: Colors.brown[200],
                      onPressed: () {
                        switch (route) {
                          case "Expense":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExpensePage(date())));
                            break;
                          case "Inversion":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InversionPage(date())));
                            break;
                          case "Income":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IncomePage(date())));
                            break;
                        }
                      },
                      child: Text("Movimientos de hoy"),
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    ))),
                    Padding(
                padding: EdgeInsets.only(top: 40),
                child: Container(
                    width: 180.0,
                    height: 50.0,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(28.0),
                          side: BorderSide(color: Colors.brown)),
                      textColor: Colors.white,
                      color: Colors.brown[200],
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PickDate(route)));
                      },
                      child: Text("Movimientos x dia"),
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    ))),
            Padding(
                padding: EdgeInsets.only(top: 40, bottom: 20),
                child: Container(
                    width: 180.0,
                    height: 50.0,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(28.0),
                          side: BorderSide(color: Colors.brown)),
                      textColor: Colors.white,
                      color: Colors.brown[200],
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PickTwoDate(route)));
                      },
                      child: Text("Movimientos x fecha"),
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    )))
          ]))),
        ))]);
  }

  String date() {
    String date = new DateFormat.yMd().format(DateTime.now());
    return date;
  }

  String title() {
    switch (route) {
      case "Expense":
        return "Gastos";
        break;
      case "Inversion":
        return "Inversiones";
        break;
      case "Income":
        return "Ingresos";
        break;
      default:
        return "Control";
    }
  }

  String imageMenu(){
    switch (route) {
      case "Expense":
        return "images/expense.jpg";
        break;
      case "Inversion":
        return "images/inversion.jpg";
        break;
      case "Income":
        return "images/income.jpg";
        break;
      default:
        return "images/person.jpg";
    }
  }
}
