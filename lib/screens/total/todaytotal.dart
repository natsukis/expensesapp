import 'package:flutter/material.dart';
import 'package:gastosapp/model/expense.dart';
import 'package:gastosapp/model/inversion.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:intl/intl.dart';

class TodayTotal extends StatefulWidget {
  String date;
  TodayTotal(this.date);
  @override
  State<StatefulWidget> createState() => TodayTotalState(date);
}

class TodayTotalState extends State {
  DbHelper helper = DbHelper();
  List<Expense> expenses;
  List<Expense> incomes;
  List<Inversion> inversions;
  List<Expense> weekExpense;
  List<Expense> weekIncome;
  List<Inversion> weekInversion;
  List<Expense> monthExpense;
  List<Expense> monthIncome;
  List<Inversion> monthInversion;

  int countIncome = 0;
  int countInversion = 0;
  int weekexpensecount = 0;
  int weekincomecount = 0;
  int weekInversioncount = 0;
  int monthExpenseCount = 0;
  int monthInversionCount = 0;
  int monthIncomeCount = 0;
  int countExpense = 0;
  String date;
  TodayTotalState(this.date);

  @override
  Widget build(BuildContext context) {
    if (expenses == null) {
      expenses = List<Expense>();
      getDataExpense();
      getDataIncome();
      getDataInversion();
      getWeekExpenseData();
      getWeekIncomeData();
      getWeekInversionData();
      getMonthExpenseData();
      getMonthInversionData();
      getMonthIncomeData();
    }
    return Scaffold(
      backgroundColor: Colors.cyan,
        appBar: AppBar(
          title: Text(stringToDate(date)),
          backgroundColor: Colors.cyan,
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
                        child: Text("Gastos del dia: ",style: TextStyle(color:Colors.white)),
                      ),
                      Expanded(
                          child: Text('\$' +
                              calculateTotalExpenses(expenses, countExpense)))
                    ]),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Ingresos del dia:",style: TextStyle(color:Colors.white))),
                          Expanded(
                              child: Text('\$' +
                                  calculateTotalExpenses(incomes, countIncome)))
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Inversiones del dia: ",style: TextStyle(color:Colors.white))),
                          Expanded(
                              child: Text('\$' +
                                  calculateTotalInversions(
                                      inversions, countInversion)))
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Total (Ingre.-Gasto-Inver.):",style: TextStyle(color:Colors.white))),
                          Expanded(
                              child: Text('\$' + calculateTotal(
                                  expenses,
                                  countExpense,
                                  incomes,
                                  countIncome,
                                  inversions,
                                  countInversion)))
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Gastos ult. 7 dias:",style: TextStyle(color:Colors.white))),
                          Expanded(
                              child: Text('\$' +
                                  calculateTotalExpenses(
                                      weekExpense, weekexpensecount)))
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Ingresos ult. 7 dias:",style: TextStyle(color:Colors.white))),
                          Expanded(
                              child: Text('\$' +
                                  calculateTotalExpenses(
                                      weekIncome, weekincomecount)))
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Inversiones ult. 7 dias:",style: TextStyle(color:Colors.white))),
                          Expanded(
                              child: Text('\$' +
                                  calculateTotalInversions(
                                      weekInversion, weekInversioncount)))
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Gastos ult. 30 dias:",style: TextStyle(color:Colors.white))),
                          Expanded(
                              child: Text('\$' +
                                  calculateTotalExpenses(
                                      monthExpense, monthExpenseCount)))
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Ingresos ult. 30 dias:",style: TextStyle(color:Colors.white))),
                          Expanded(
                              child: Text('\$' +
                                  calculateTotalExpenses(
                                      monthIncome, monthIncomeCount)))
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Inversiones ult. 30 dias:",style: TextStyle(color:Colors.white))),
                          Expanded(
                              child: Text('\$' +
                                  calculateTotalInversions(
                                      monthInversion, monthInversionCount))),
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Total ult. 30 dias:",style: TextStyle(color:Colors.white))),
                          Expanded(
                              child: Text('\$' +
                                  calculateTotal(
                                      monthExpense,
                                      monthExpenseCount,
                                      monthIncome,
                                      monthIncomeCount,
                                      monthInversion,
                                      monthInversionCount)))
                        ])),
                         Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Row(children: <Widget>[
                          Expanded(child: Text("Total ult. 30 dias (I-G):",style: TextStyle(color:Colors.white))),
                          Expanded(
                              child: Text('\$' +
                                  calculateTotalSimple(
                                      monthExpense,
                                      monthExpenseCount,
                                      monthIncome,
                                      monthIncomeCount)))
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
          if (producAux.date == date && producAux.type == "Expense") {
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
          if (producAux.date == date && producAux.type == "Income") {
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
          if (producAux.date == date) {
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

  void getWeekExpenseData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final expensesFuture = helper.getExpenses();
      expensesFuture.then((result) {
        List<Expense> expenseList = List<Expense>();
        weekexpensecount = result.length;
        int notToday = 0;
        for (int i = 0; i < weekexpensecount; i++) {
          Expense producAux = Expense.fromObject(result[i]);
          DateTime tempDate = DateFormat().add_yMd().parse(producAux.date);
          var diff = DateTime.now().difference(tempDate);
          if (diff.inDays <= 7 && producAux.type == "Expense") {
            expenseList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        setState(() {
          weekExpense = expenseList;
          weekexpensecount = weekexpensecount - notToday;
        });
      });
    });
  }

  void getWeekIncomeData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final expensesFuture = helper.getExpenses();
      expensesFuture.then((result) {
        List<Expense> expenseList = List<Expense>();
        weekincomecount = result.length;
        int notToday = 0;
        for (int i = 0; i < weekincomecount; i++) {
          Expense producAux = Expense.fromObject(result[i]);
          DateTime tempDate = DateFormat().add_yMd().parse(producAux.date);
          var diff = DateTime.now().difference(tempDate);
          if (diff.inDays <= 7 && producAux.type == "Income") {
            expenseList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        setState(() {
          weekIncome = expenseList;
          weekincomecount = weekincomecount - notToday;
        });
      });
    });
  }

  void getWeekInversionData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final expensesFuture = helper.getInversion();
      expensesFuture.then((result) {
        List<Inversion> inversionList = List<Inversion>();
        weekInversioncount = result.length;
        int notToday = 0;
        for (int i = 0; i < weekInversioncount; i++) {
          Inversion producAux = Inversion.fromObject(result[i]);
          DateTime tempDate = DateFormat().add_yMd().parse(producAux.date);
          var diff = DateTime.now().difference(tempDate);
          if (diff.inDays <= 7) {
            inversionList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        setState(() {
          weekInversion = inversionList;
          weekInversioncount = weekInversioncount - notToday;
        });
      });
    });
  }

  void getMonthIncomeData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final expensesFuture = helper.getExpenses();
      expensesFuture.then((result) {
        List<Expense> expenseList = List<Expense>();
        monthIncomeCount = result.length;
        int notToday = 0;
        for (int i = 0; i < monthIncomeCount; i++) {
          Expense producAux = Expense.fromObject(result[i]);
          DateTime tempDate = DateFormat().add_yMd().parse(producAux.date);
          var diff = DateTime.now().difference(tempDate);
          if (diff.inDays <= 30 && producAux.type == "Income") {
            expenseList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        setState(() {
          monthIncome = expenseList;
          monthIncomeCount = monthIncomeCount - notToday;
        });
      });
    });
  }

  void getMonthExpenseData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final expensesFuture = helper.getExpenses();
      expensesFuture.then((result) {
        List<Expense> expenseList = List<Expense>();
        monthExpenseCount = result.length;
        int notToday = 0;
        for (int i = 0; i < monthExpenseCount; i++) {
          Expense producAux = Expense.fromObject(result[i]);
          DateTime tempDate = DateFormat().add_yMd().parse(producAux.date);
          var diff = DateTime.now().difference(tempDate);
          if (diff.inDays <= 30 && (producAux.type == "Expense")) {
            expenseList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        setState(() {
          monthExpense = expenseList;
          monthExpenseCount = monthExpenseCount - notToday;
        });
      });
    });
  }

  void getMonthInversionData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final expensesFuture = helper.getInversion();
      expensesFuture.then((result) {
        List<Inversion> expenseList = List<Inversion>();
        monthInversionCount = result.length;
        int notToday = 0;
        for (int i = 0; i < monthInversionCount; i++) {
          Inversion producAux = Inversion.fromObject(result[i]);
          DateTime tempDate = DateFormat().add_yMd().parse(producAux.date);
          var diff = DateTime.now().difference(tempDate);
          if (diff.inDays <= 30) {
            expenseList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        setState(() {
          monthInversion = expenseList;
          monthInversionCount = monthInversionCount - notToday;
        });
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

  String calculateTotalInversions(List<Inversion> inversion, int count) {
    var total = 0;
    for (var i = 0; i < count; i++) {
      total = total + inversion[i].price;
    }
    return total.toString();
  }

  String calculateTotal(
    List<Expense> expenses,
    int count,
    List<Expense> incomes,
    int countIncome,
    List<Inversion> inversions,
    int countInversion,
  ) {
    var total = 0;
    for (var i = 0; i < countIncome; i++) {
      total = total + incomes[i].price;
    }

    var totalexpense = 0;
    for (var i = 0; i < count; i++) {
      totalexpense = totalexpense + expenses[i].price;
    }

    var totalInversion = 0;
    for (var i = 0; i < countInversion; i++) {
      totalInversion = totalInversion + inversions[i].price;
    }

    return (total - totalexpense - totalInversion).toString();
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
}
