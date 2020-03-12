import 'package:flutter/material.dart';
import 'package:gastosapp/screens/expense/expensepage.dart';
import 'package:gastosapp/screens/total/todaytotal.dart';
import 'package:intl/intl.dart';
import 'package:gastosapp/screens/pickdate/picktwodates.dart';
import 'package:gastosapp/screens/submenu.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.cyan,
      appBar: AppBar(
        title: Text("Control de Gastos"),
        backgroundColor: Colors.cyan,
      ),
      body:Padding(
      padding: EdgeInsets.only(top: 150.0, left: 5.0, right: 5.0),
      child: Center(
          child: Container(
              alignment: Alignment.center,
              child: Column(children: <Widget>[
                Row(children: <Widget>[
                  Expanded(
                      child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(28.0),
                        side: BorderSide(color: Colors.blueAccent)),
                    textColor: Colors.white,
                    color: Colors.cyan,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubMenu("Expense")));
                    },
                    child: Text("Gastos"),
                  )),
                  Expanded(
                      child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(28.0),
                              side: BorderSide(color: Colors.blue)),
                          textColor: Colors.white,
                          color: Colors.cyan,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SubMenu("Income")));
                          },
                          child: Text("Ingresos")))
                ]),
                Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Row(children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(28.0),
                                  side: BorderSide(color: Colors.blue)),
                              textColor: Colors.white,
                              color: Colors.cyan,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SubMenu("Inversion")));
                              },
                              child: Text("Inversiones"))),
                      Expanded(
                          child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(28.0),
                                  side: BorderSide(color: Colors.blue)),
                              textColor: Colors.white,
                              color: Colors.cyan,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PickTwoDate("TotalMoves")));
                              },
                              child: Text("Todos los Mov.")))
                    ])),
                Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Row(children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(28.0),
                                  side: BorderSide(color: Colors.blue)),
                              textColor: Colors.white,
                              color: Colors.cyan,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TodayTotal(date())));
                              },
                              child: Text("Resumen"))),
                      Expanded(
                          child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(28.0),
                                  side: BorderSide(color: Colors.blue)),
                              textColor: Colors.white,
                              color: Colors.cyan,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PickTwoDate("TotalPerDay")));
                              },
                              child: Text("Resumen x fecha"))),
                    ])),
                // Center(
                //     child: RaisedButton(
                //         shape: new RoundedRectangleBorder(
                //             borderRadius: new BorderRadius.circular(28.0),
                //             side: BorderSide(color: Colors.blue)),
                //         textColor: Colors.white,
                //         color: Colors.cyan,
                //         onPressed: () {
                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (context) => PickTwoDate("Excel")));
                //         },
                //         child: Text("Exportar")))
              ]))),
    )
    );
  }

  String date() {
    String date = new DateFormat.yMd().format(DateTime.now());
    return date;
  }
}
