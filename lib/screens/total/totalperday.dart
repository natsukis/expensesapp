import 'package:flutter/material.dart';
import 'package:gastosapp/model/expense.dart';
import 'package:gastosapp/model/inversion.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:intl/intl.dart';

class TotalPerDay extends StatefulWidget {
  DateTime dateFrom;
  DateTime dateTo;
  TotalPerDay(this.dateFrom, this.dateTo);
  @override
  State<StatefulWidget> createState() => TotalPerDayState(dateFrom, dateTo);
}

class TotalPerDayState extends State {
  DbHelper helper = DbHelper();
  List<Expense> expenses;
  List<Expense> incomes;
  List<Inversion> inversions;

  int countIncome = 0;
  int countInversion = 0;
  int countExpense = 0;
  DateTime dateFrom;
  DateTime dateTo;
  TotalPerDayState(this.dateFrom, this.dateTo);

  @override
  Widget build(BuildContext context) {
    if (expenses == null) {
      expenses = List<Expense>();
      getDataExpense();
      getDataIncome();
      getDataInversion();
    }
    return Scaffold(
        backgroundColor: Colors.brown[200],
        appBar: AppBar(
          centerTitle: true,
          title: Text(stringToDate(dateFrom) + " a " + stringToDate(dateTo)),
          backgroundColor: Colors.brown,
        ),
        floatingActionButton: FloatingActionButton(
            child: Text("Volver"),
            backgroundColor: Colors.lightBlue,
            onPressed: () {
              Navigator.pop(context, true);
            }),
        body: Padding(
          padding: EdgeInsets.only(top: 50.0, left: 20.0),
          child: Center(
              child: Container(
                  alignment: Alignment.center,
                  child: Column(children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(
                        child: Text("Gastos en esos dias: ",
                            style: TextStyle(color: Colors.white)),
                      ),
                      Expanded(
                          child: Text(
                              '-\$' +
                                  calculateTotalExpenses(
                                      expenses, countExpense),
                              style: TextStyle(color: Colors.red)))
                    ]),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(
                              child: Text("Ingresos en esos dias:",
                                  style: TextStyle(color: Colors.white))),
                          Expanded(
                              child: Text(
                                  '\$' +
                                      calculateTotalExpenses(
                                          incomes, countIncome),
                                  style: TextStyle(color: Colors.greenAccent)))
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(
                              child: Text("Inversiones en esos dias: ",
                                  style: TextStyle(color: Colors.white))),
                          Expanded(
                              child: Text(
                                  '\$' +
                                      calculateTotalInversions(
                                          inversions, countInversion),
                                  style: TextStyle(color: Colors.blueAccent)))
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(
                              child: Text("Total (Ingre-Gasto):",
                                  style: TextStyle(color: Colors.yellow))),
                          Expanded(
                              child: Text('\$' +
                                  calculateTotalSimple(expenses, countExpense,
                                      incomes, countIncome)))
                        ])),
                  ]))),
        ));
  }

  void getDataExpense() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final expensesFuture = helper.getExpenses();
      expensesFuture.then((result) {
        List<Expense> expenseList = List<Expense>();
        countExpense = result.length;
        int notToday = 0;
        for (int i = 0; i < countExpense; i++) {
          Expense producAux = Expense.fromObject(result[i]);
          if (comparedate(producAux.date) && producAux.type == "Expense") {
            expenseList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        setState(() {
          expenses = expenseList;
          countExpense = countExpense - notToday;
        });
      });
    });
  }

  void getDataIncome() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final expensesFuture = helper.getExpenses();
      expensesFuture.then((result) {
        List<Expense> expenseList = List<Expense>();
        countIncome = result.length;
        int notToday = 0;
        for (int i = 0; i < countIncome; i++) {
          Expense producAux = Expense.fromObject(result[i]);
          if (comparedate(producAux.date) && producAux.type == "Income") {
            expenseList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        setState(() {
          incomes = expenseList;
          countIncome = countIncome - notToday;
        });
      });
    });
  }

  void getDataInversion() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final inversionFuture = helper.getInversion();
      inversionFuture.then((result) {
        List<Inversion> inversionList = List<Inversion>();
        countInversion = result.length;
        int notToday = 0;
        for (int i = 0; i < countInversion; i++) {
          Inversion producAux = Inversion.fromObject(result[i]);
          if (comparedate(producAux.date)) {
            inversionList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        setState(() {
          inversions = inversionList;
          countInversion = countInversion - notToday;
        });
      });
    });
  }

  String stringToDate(DateTime aux) {
    return aux.day.toString() + '/' + aux.month.toString();
  }

  String calculateTotalExpenses(List<Expense> expenses, int count) {
    var total = 0;
    for (var i = 0; i < count; i++) {
      total = total + expenses[i].price;
    }
    return total.toString();
  }

  String calculateTotalInversions(List<Inversion> inversion, int count) {
    var total = 0;
    for (var i = 0; i < count; i++) {
      total = total + inversion[i].price;
    }
    return total.toString();
  }

  String calculateTotalSimple(
    List<Expense> expenses,
    int count,
    List<Expense> incomes,
    int countIncome,
  ) {
    var total = 0;
    for (var i = 0; i < countIncome; i++) {
      total = total + incomes[i].price;
    }

    var totalexpense = 0;
    for (var i = 0; i < count; i++) {
      totalexpense = totalexpense + expenses[i].price;
    }

    return (total - totalexpense).toString();
  }

  bool comparedate(String date) {
    DateTime dateD = new DateFormat().add_yMd().parse(date);
    if (dateD.isAfter(dateFrom.add(new Duration(days: -1))) &&
        dateD.isBefore(dateTo.add(new Duration(days: 1)))) {
      return true;
    } else {
      return false;
    }
  }
}
