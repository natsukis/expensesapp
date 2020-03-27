import 'package:flutter/material.dart';
import 'package:gastosapp/model/totalpermonth.dart';
import 'package:gastosapp/screens/expense/expensepage.dart';
import 'package:gastosapp/screens/total/todaytotal.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:intl/intl.dart';
import 'package:gastosapp/screens/pickdate/picktwodates.dart';
import 'package:gastosapp/screens/submenu.dart';

class Menu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MenuState();
}

class MenuState extends State {
  DbHelper helper = DbHelper();
  TotalPerMonth tempTot;
  String currentTotal;
  @override
  Widget build(BuildContext context) {
    getTotal(DateTime.now().year);
    return Scaffold(
        backgroundColor: Colors.cyan,
        appBar: AppBar(
          title: Text("Control de Gastos"),
          backgroundColor: Colors.cyan,
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0),
            child: Center(
              child:Column(children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Container(
                    child: Text("Su saldo de este mes es: \$" +
                        currentTotal, style: TextStyle(color: Colors.purple)),
                  )),
              
                 SingleChildScrollView(
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
                                        builder: (context) =>
                                            SubMenu("Expense")));
                              },
                              child: Text("Gastos"),
                            )),
                            Expanded(
                                child: RaisedButton(
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(28.0),
                                        side: BorderSide(color: Colors.blue)),
                                    textColor: Colors.white,
                                    color: Colors.cyan,
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
                              padding: EdgeInsets.only(top: 25),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: RaisedButton(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(28.0),
                                            side:
                                                BorderSide(color: Colors.blue)),
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
                                            borderRadius:
                                                new BorderRadius.circular(28.0),
                                            side:
                                                BorderSide(color: Colors.blue)),
                                        textColor: Colors.white,
                                        color: Colors.cyan,
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PickTwoDate(
                                                          "TotalMoves")));
                                        },
                                        child: Text("Todos los Mov.")))
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: 25),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: RaisedButton(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(28.0),
                                            side:
                                                BorderSide(color: Colors.blue)),
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
                                            borderRadius:
                                                new BorderRadius.circular(28.0),
                                            side:
                                                BorderSide(color: Colors.blue)),
                                        textColor: Colors.white,
                                        color: Colors.cyan,
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PickTwoDate(
                                                          "TotalPerDay")));
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
              ])
            )));
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
    }
    else{
      return 0;
    }
  }

  void getTotal(int year) async {
    final dbFuture = helper.initializeDb();
    TotalPerMonth totalAux;
    int statusTemp;
    await dbFuture.then((result) async {
      final total = helper.getTotalYear(year);
      await total.then((result) {
        int count = result.length;
        if (count == 0) {
          totalAux = new TotalPerMonth.withYear(year);
          helper.insertTotal(totalAux);
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
