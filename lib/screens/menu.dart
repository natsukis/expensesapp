import 'package:flutter/material.dart';
import 'package:gastosapp/model/totalpermonth.dart';
import 'package:gastosapp/screens/draw/About/about.dart';
import 'package:gastosapp/screens/total/todaytotal.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:intl/intl.dart';
import 'package:gastosapp/screens/pickdate/picktwodates.dart';
import 'package:gastosapp/screens/submenu.dart';
import 'draw/creditcard/creditcard.dart';

class Menu extends StatefulWidget {
  Menu();
  @override
  State<StatefulWidget> createState() => MenuState();
}

class MenuState extends State {
  MenuState();
  DbHelper helper = DbHelper();
  TotalPerMonth tempTot;
  String currentTotal;
  @override
  Widget build(BuildContext context) {
    getTotal(DateTime.now().year);
    return Stack(children: <Widget>[
      Image.asset("images/expense.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          alignment: Alignment.center),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Control de Gastos"),
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
            child: Center(
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 230),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.yellow[300],
                        border: Border.all(color: Colors.yellow),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Text(
                        "Saldo actual de este mes es: \$" +
                            (currentTotal != null ? currentTotal : '0'),
                        style: TextStyle(color: Colors.black)),
                  )),
              Container(
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Column(children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(28.0),
                            side: BorderSide(color: Colors.brown)),
                        textColor: Colors.white,
                        color: Colors.brown[200],
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
                              padding: EdgeInsets.all(15.0),
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(28.0),
                                  side: BorderSide(color: Colors.brown)),
                              textColor: Colors.white,
                              color: Colors.brown[200],
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SubMenu("Income")));
                              },
                              child: Text("Ingresos")))
                    ]),
                    Padding(
                        padding: EdgeInsets.only(top: 35),
                        child: Row(children: <Widget>[
                          Expanded(
                              child: RaisedButton(
                                  padding: EdgeInsets.all(15.0),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(28.0),
                                      side: BorderSide(color: Colors.brown)),
                                  textColor: Colors.white,
                                  color: Colors.brown[200],
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
                                  padding: EdgeInsets.all(15.0),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(28.0),
                                      side: BorderSide(color: Colors.brown)),
                                  textColor: Colors.white,
                                  color: Colors.brown[200],
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
                        padding: EdgeInsets.only(top: 35),
                        child: Row(children: <Widget>[
                          Expanded(
                              child: RaisedButton(
                                  padding: EdgeInsets.all(15.0),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(28.0),
                                      side: BorderSide(color: Colors.brown)),
                                  textColor: Colors.white,
                                  color: Colors.brown[200],
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
                                  padding: EdgeInsets.all(15.0),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(28.0),
                                      side: BorderSide(color: Colors.brown)),
                                  textColor: Colors.white,
                                  color: Colors.brown[200],
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
                  ])),
            ])))),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Mas opciones'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Tarjetas'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreditCard()));
                },
              ),
              ListTile(
                title: Text('Viajes'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Estadisticas'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Sobre la app'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => About()));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      )
    ]);
  }

  String date() {
    String date = new DateFormat.yMd().format(DateTime.now());
    return date;
  }

  int getMoney(TotalPerMonth total) {
    if (total != null) {
      switch (DateTime.now().month) {
        case 1:
          return total.january;
          break;
        case 2:
          return total.february;
          break;
        case 3:
          return total.march;
          break;
        case 4:
          return total.april;
          break;
        case 5:
          return total.may;
          break;
        case 6:
          return total.june;
          break;
        case 7:
          return total.july;
          break;
        case 8:
          return total.august;
          break;
        case 9:
          return total.september;
          break;
        case 10:
          return total.october;
          break;
        case 11:
          return total.november;
          break;
        case 12:
          return total.december;
          break;
      }
      return 0;
    } else {
      return 0;
    }
  }

  void getTotal(int year) async {
    final dbFuture = helper.initializeDb();
    TotalPerMonth totalAux;
    TotalPerMonth totalNextYear;
    int statusTemp;
    await dbFuture.then((result) async {
      final total = helper.getTotalYear(year);
      await total.then((result) {
        int count = result.length;
        if (count == 0) {
          totalAux = new TotalPerMonth.withYear(year);
          totalNextYear = new TotalPerMonth.withYear((year + 1));
          helper.insertTotal(totalAux);
          helper.insertTotal(totalNextYear);
          statusTemp = 0;
        } else {
          totalAux = TotalPerMonth.fromObject(result[0]);
          statusTemp = 1;
        }
      });
      setState(() {
        tempTot = totalAux;
        currentTotal = getMoney(tempTot).toString();
      });
    });
  }
}
