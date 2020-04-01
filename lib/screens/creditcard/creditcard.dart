import 'package:flutter/material.dart';
import 'package:gastosapp/model/expense.dart';
import 'package:gastosapp/model/inversion.dart';
import 'package:gastosapp/model/totalpermonth.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:intl/intl.dart';

class CreditCard extends StatefulWidget {
  CreditCard();
  @override
  State<StatefulWidget> createState() => CreditCardState();
}

class CreditCardState extends State {
  DbHelper helper = DbHelper();
  List<Expense> expenses;

  int countExpense = 0;

  CreditCardState();

//Expense Months
  List<Expense> ejanuaryList = List<Expense>();
  List<Expense> efebruaryList = List<Expense>();
  List<Expense> emarchList = List<Expense>();
  List<Expense> eaprilList = List<Expense>();
  List<Expense> emayList = List<Expense>();
  List<Expense> ejuneList = List<Expense>();
  List<Expense> ejulyList = List<Expense>();
  List<Expense> eaugustList = List<Expense>();
  List<Expense> eseptemberList = List<Expense>();
  List<Expense> eoctoberList = List<Expense>();
  List<Expense> enovemberList = List<Expense>();
  List<Expense> edecemberList = List<Expense>();

  int eJanuary = 0;
  int eFebruary = 0;
  int eMarch = 0;
  int eApril = 0;
  int eMay = 0;
  int eJune = 0;
  int eJuly = 0;
  int eAugust = 0;
  int eSeptember = 0;
  int eOctober = 0;
  int eNovember = 0;
  int eDecember = 0;

  //DateTime Months
  DateTime januaryFrom = DateTime.utc(DateTime.now().year, 1, 1);
  DateTime januaryTo = DateTime.utc(DateTime.now().year, 1, 31);
  DateTime februaryFrom = DateTime.utc(DateTime.now().year, 2, 1);
  DateTime februaryTo = DateTime.utc(DateTime.now().year, 2, 28);
  DateTime marchFrom = DateTime.utc(DateTime.now().year, 3, 1);
  DateTime marchTo = DateTime.utc(DateTime.now().year, 3, 31);
  DateTime aprilFrom = DateTime.utc(DateTime.now().year, 4, 1);
  DateTime aprilTo = DateTime.utc(DateTime.now().year, 4, 30);
  DateTime mayFrom = DateTime.utc(DateTime.now().year, 5, 1);
  DateTime mayTo = DateTime.utc(DateTime.now().year, 5, 31);
  DateTime juneFrom = DateTime.utc(DateTime.now().year, 6, 1);
  DateTime juneTo = DateTime.utc(DateTime.now().year, 6, 30);
  DateTime julyFrom = DateTime.utc(DateTime.now().year, 7, 1);
  DateTime julyTo = DateTime.utc(DateTime.now().year, 7, 31);
  DateTime augustFrom = DateTime.utc(DateTime.now().year, 8, 1);
  DateTime augustTo = DateTime.utc(DateTime.now().year, 8, 31);
  DateTime septemberFrom = DateTime.utc(DateTime.now().year, 9, 1);
  DateTime septemberTo = DateTime.utc(DateTime.now().year, 9, 30);
  DateTime octoberFrom = DateTime.utc(DateTime.now().year, 10, 1);
  DateTime octoberTo = DateTime.utc(DateTime.now().year, 10, 31);
  DateTime novemberFrom = DateTime.utc(DateTime.now().year, 11, 1);
  DateTime novemberTo = DateTime.utc(DateTime.now().year, 11, 30);
  DateTime decemberFrom = DateTime.utc(DateTime.now().year, 12, 1);
  DateTime decemberTo = DateTime.utc(DateTime.now().year, 12, 31);

  TotalPerMonth totalMonth = new TotalPerMonth.withYear(DateTime.now().year);

  @override
  Widget build(BuildContext context) {
    if (expenses == null) {
      expenses = List<Expense>();
      getDataExpense();
      totalMonth.january = calculateTotalSimple(ejanuaryList, eJanuary);
      totalMonth.february = calculateTotalSimple(efebruaryList, eFebruary);
      totalMonth.march = calculateTotalSimple(emarchList, eMarch);
      totalMonth.april = calculateTotalSimple(eaprilList, eApril);
      totalMonth.may = calculateTotalSimple(emayList, eMay);
      totalMonth.june = calculateTotalSimple(ejuneList, eJune);
      totalMonth.july = calculateTotalSimple(ejulyList, eJuly);
      totalMonth.august = calculateTotalSimple(eaugustList, eAugust);
      totalMonth.september = calculateTotalSimple(eseptemberList, eSeptember);
      totalMonth.october = calculateTotalSimple(
        eoctoberList,
        eOctober,
      );
      totalMonth.november = calculateTotalSimple(enovemberList, eNovember);
      totalMonth.december = calculateTotalSimple(edecemberList, eDecember);
    }
    return Scaffold(
        backgroundColor: Colors.brown[200],
        appBar: AppBar(
          title: Text("Totales " + DateTime.now().year.toString()),
          centerTitle: true,
          backgroundColor: Colors.brown,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 20.0, left: 20),
          child: Center(
              child: SingleChildScrollView(
                  child: Container(
                      alignment: Alignment.center,
                      child: Column(children: <Widget>[
                        Row(children: <Widget>[
                          Expanded(
                            child: Text("Total Enero(Ingre-Gasto): ",
                                style: TextStyle(color: Colors.white)),
                          ),
                          Expanded(
                              child: Text(
                                  '                \$' +
                                      totalMonth.january.toString(),
                                  style: TextStyle(color: Colors.white)))
                        ]),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Total Febrero(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '                \$' +
                                          totalMonth.february.toString(),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Total Marzo(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '                \$' +
                                          totalMonth.march.toString(),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Total Abril(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '                \$' +
                                          totalMonth.april.toString(),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Total Mayo(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '                \$' +
                                          totalMonth.may.toString(),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Total Junio(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '                \$' +
                                          totalMonth.june.toString(),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Total Julio(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '                \$' +
                                          totalMonth.july.toString(),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Total Agosto(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '                \$' +
                                          totalMonth.august.toString(),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Total Septiembre(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '                \$' +
                                          totalMonth.september.toString(),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Total Octubre(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '                \$' +
                                          totalMonth.october.toString(),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Total Noviembre(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '                \$' +
                                          totalMonth.november.toString(),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Total Diciembre(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '                \$' +
                                          totalMonth.december.toString(),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                      ])))),
        ));
  }

  void getDataExpense() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final expensesFuture = helper.getExpenses();
      expensesFuture.then((result) {
        countExpense = result.length;

        //List
        List<Expense> januaryList = List<Expense>();
        List<Expense> februaryList = List<Expense>();
        List<Expense> marchList = List<Expense>();
        List<Expense> aprilList = List<Expense>();
        List<Expense> mayList = List<Expense>();
        List<Expense> juneList = List<Expense>();
        List<Expense> julyList = List<Expense>();
        List<Expense> augustList = List<Expense>();
        List<Expense> septemberList = List<Expense>();
        List<Expense> octoberList = List<Expense>();
        List<Expense> novemberList = List<Expense>();
        List<Expense> decemberList = List<Expense>();

        int notJanuary = 0;
        int notFebruary = 0;
        int notMarch = 0;
        int notApril = 0;
        int notMay = 0;
        int notJune = 0;
        int notJuly = 0;
        int notAugust = 0;
        int notSeptember = 0;
        int notOctober = 0;
        int notNovember = 0;
        int notDecember = 0;

        for (int i = 0; i < countExpense; i++) {
          Expense producAux = Expense.fromObject(result[i]);
          if (comparedate(producAux.date, januaryFrom, januaryTo) &&
              producAux.type == "Expense" &&
              (producAux.method == "Tarjeta 1c" ||
                  producAux.method == "Tarjeta 3c" ||
                  producAux.method == "Tarjeta 6c" ||
                  producAux.method == "12")) {
            januaryList.add(producAux);
          } else {
            notJanuary = notJanuary + 1;
          }
          if (comparedate(producAux.date, februaryFrom, februaryTo) &&
              producAux.type == "Expense" &&
              (producAux.method == "Tarjeta 1c" ||
                  producAux.method == "Tarjeta 3c" ||
                  producAux.method == "Tarjeta 6c" ||
                  producAux.method == "12")) {
            februaryList.add(producAux);
          } else {
            notFebruary = notFebruary + 1;
          }
          if (comparedate(producAux.date, marchFrom, marchTo) &&
              producAux.type == "Expense" &&
              (producAux.method == "Tarjeta 1c" ||
                  producAux.method == "Tarjeta 3c" ||
                  producAux.method == "Tarjeta 6c" ||
                  producAux.method == "12")) {
            marchList.add(producAux);
          } else {
            notMarch = notMarch + 1;
          }
          if (comparedate(producAux.date, aprilFrom, aprilTo) &&
              producAux.type == "Expense" &&
              (producAux.method == "Tarjeta 1c" ||
                  producAux.method == "Tarjeta 3c" ||
                  producAux.method == "Tarjeta 6c" ||
                  producAux.method == "12")) {
            aprilList.add(producAux);
          } else {
            notApril = notApril + 1;
          }
          if (comparedate(producAux.date, mayFrom, mayTo) &&
              producAux.type == "Expense" &&
              (producAux.method == "Tarjeta 1c" ||
                  producAux.method == "Tarjeta 3c" ||
                  producAux.method == "Tarjeta 6c" ||
                  producAux.method == "12")) {
            mayList.add(producAux);
          } else {
            notMay = notMay + 1;
          }
          if (comparedate(producAux.date, juneFrom, juneTo) &&
              producAux.type == "Expense" &&
              (producAux.method == "Tarjeta 1c" ||
                  producAux.method == "Tarjeta 3c" ||
                  producAux.method == "Tarjeta 6c" ||
                  producAux.method == "12")) {
            juneList.add(producAux);
          } else {
            notJune = notJune + 1;
          }
          if (comparedate(producAux.date, julyFrom, julyTo) &&
              producAux.type == "Expense" &&
              (producAux.method == "Tarjeta 1c" ||
                  producAux.method == "Tarjeta 3c" ||
                  producAux.method == "Tarjeta 6c" ||
                  producAux.method == "12")) {
            julyList.add(producAux);
          } else {
            notJuly = notJuly + 1;
          }
          if (comparedate(producAux.date, augustFrom, augustTo) &&
              producAux.type == "Expense" &&
              (producAux.method == "Tarjeta 1c" ||
                  producAux.method == "Tarjeta 3c" ||
                  producAux.method == "Tarjeta 6c" ||
                  producAux.method == "12")) {
            augustList.add(producAux);
          } else {
            notAugust = notAugust + 1;
          }
          if (comparedate(producAux.date, septemberFrom, septemberTo) &&
              producAux.type == "Expense" &&
              (producAux.method == "Tarjeta 1c" ||
                  producAux.method == "Tarjeta 3c" ||
                  producAux.method == "Tarjeta 6c" ||
                  producAux.method == "12")) {
            septemberList.add(producAux);
          } else {
            notSeptember = notSeptember + 1;
          }
          if (comparedate(producAux.date, octoberFrom, octoberTo) &&
              producAux.type == "Expense" &&
              (producAux.method == "Tarjeta 1c" ||
                  producAux.method == "Tarjeta 3c" ||
                  producAux.method == "Tarjeta 6c" ||
                  producAux.method == "12")) {
            octoberList.add(producAux);
          } else {
            notOctober = notOctober + 1;
          }
          if (comparedate(producAux.date, novemberFrom, novemberTo) &&
              producAux.type == "Expense" &&
              (producAux.method == "Tarjeta 1c" ||
                  producAux.method == "Tarjeta 3c" ||
                  producAux.method == "Tarjeta 6c" ||
                  producAux.method == "12")) {
            novemberList.add(producAux);
          } else {
            notNovember = notNovember + 1;
          }
          if (comparedate(producAux.date, decemberFrom, decemberTo) &&
              producAux.type == "Expense" &&
              (producAux.method == "Tarjeta 1c" ||
                  producAux.method == "Tarjeta 3c" ||
                  producAux.method == "Tarjeta 6c" ||
                  producAux.method == "12")) {
            decemberList.add(producAux);
          } else {
            notDecember = notDecember + 1;
          }
        }

        ejanuaryList = januaryList;
        efebruaryList = februaryList;
        emarchList = marchList;
        eaprilList = aprilList;
        emayList = mayList;
        ejuneList = juneList;
        ejulyList = julyList;
        eaugustList = augustList;
        eseptemberList = septemberList;
        eoctoberList = octoberList;
        enovemberList = novemberList;
        edecemberList = decemberList;

        eJanuary = countExpense - notJanuary;
        eFebruary = countExpense - notFebruary;
        eMarch = countExpense - notMarch;
        eApril = countExpense - notApril;
        eMay = countExpense - notMay;
        eJune = countExpense - notJune;
        eJuly = countExpense - notJuly;
        eAugust = countExpense - notAugust;
        eSeptember = countExpense - notSeptember;
        eOctober = countExpense - notOctober;
        eNovember = countExpense - notNovember;
        eDecember = countExpense - notDecember;
      });
    });
  }

  String stringToDate(String aux) {
    var newDateTimeObj = new DateFormat().add_yMd().parse(aux);
    return newDateTimeObj.day.toString() +
        '/' +
        newDateTimeObj.month.toString() +
        '/' +
        newDateTimeObj.year.toString();
  }

  String calculateTotalExpenses(List<Expense> expenses, int count) {
    var total = 0;
    for (var i = 0; i < count; i++) {
      total = total + expenses[i].price;
    }
    return total.toString();
  }

  int calculateTotalSimple(List<Expense> expenses, int count) {
    var totalexpense = 0;
    for (var i = 0; i < count; i++) {
      totalexpense = totalexpense + expenses[i].price;
    }

    return (totalexpense);
  }

  bool comparedate(String date, DateTime dateFrom, DateTime dateTo) {
    DateTime dateD = new DateFormat().add_yMd().parse(date);
    if (dateD.isAfter(dateFrom.add(new Duration(days: -1))) &&
        dateD.isBefore(dateTo.add(new Duration(days: 1)))) {
      return true;
    } else {
      return false;
    }
  }
}
