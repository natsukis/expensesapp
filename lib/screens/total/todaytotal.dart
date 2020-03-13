import 'package:flutter/material.dart';
import 'package:gastosapp/model/expense.dart';
import 'package:gastosapp/model/inversion.dart';
import 'package:gastosapp/model/month.dart';
import 'package:gastosapp/model/monthinversion.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:intl/intl.dart';

class TodayTotal extends StatefulWidget {
  String date;
  TodayTotal(this.date);
  @override
  TodayTotalState createState() => TodayTotalState(date);
}

class TodayTotalState extends State<PageView> {
  String date;
  TodayTotalState(this.date);
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: [
        TodayTotal1(date),
        TodayTotal2(),
      ],
    );
  }
}

/////////////////////////////////////////////////
class TodayTotal1 extends StatefulWidget {
  String date;
  TodayTotal1(this.date);
  @override
  State<StatefulWidget> createState() => TodayTotal1State(date);
}

class TodayTotal1State extends State {
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
  TodayTotal1State(this.date);

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
          centerTitle: true,
          backgroundColor: Colors.cyan,
        ),
        floatingActionButton: FloatingActionButton(
            child: Text("Volver"),
            backgroundColor: Colors.lightBlue,
            onPressed: () {
              Navigator.pop(context, true);
            }),
        body: Padding(
          padding: EdgeInsets.only(top: 20.0, left: 20),
          child: Center(
              child: SingleChildScrollView(
                  child: Container(
                      alignment: Alignment.center,
                      child: Column(children: <Widget>[
                        Row(children: <Widget>[
                          Expanded(
                            child: Text("Gastos del dia: ",
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
                                  child: Text("Ingresos del dia:",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotalExpenses(
                                              incomes, countIncome),
                                      style:
                                          TextStyle(color: Colors.greenAccent)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Inversiones del dia: ",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotalInversions(
                                              inversions, countInversion),
                                      style:
                                          TextStyle(color: Colors.blueAccent)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Total (Ingre.-Gasto-Inver.):",
                                      style: TextStyle(color: Colors.yellow))),
                              Expanded(
                                  child: Text('\$' +
                                      calculateTotal(
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
                              Expanded(
                                  child: Text("Gastos ult. 7 dias:",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '-\$' +
                                          calculateTotalExpenses(
                                              weekExpense, weekexpensecount),
                                      style: TextStyle(color: Colors.red)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Ingresos ult. 7 dias:",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotalExpenses(
                                              weekIncome, weekincomecount),
                                      style:
                                          TextStyle(color: Colors.greenAccent)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Inversiones ult. 7 dias:",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotalInversions(
                                              weekInversion,
                                              weekInversioncount),
                                      style:
                                          TextStyle(color: Colors.blueAccent)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Gastos ult. 30 dias:",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '-\$' +
                                          calculateTotalExpenses(
                                              monthExpense, monthExpenseCount),
                                      style: TextStyle(color: Colors.red)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Ingresos ult. 30 dias:",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotalExpenses(
                                              monthIncome, monthIncomeCount),
                                      style:
                                          TextStyle(color: Colors.greenAccent)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Inversiones ult. 30 dias:",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotalInversions(
                                              monthInversion,
                                              monthInversionCount),
                                      style:
                                          TextStyle(color: Colors.blueAccent))),
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Total ult. 30 dias:",
                                      style: TextStyle(color: Colors.yellow))),
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
                              Expanded(
                                  child: Text("Total ult. 30 dias (I-G):",
                                      style: TextStyle(color: Colors.yellow))),
                              Expanded(
                                  child: Text('\$' +
                                      calculateTotalSimple(
                                          monthExpense,
                                          monthExpenseCount,
                                          monthIncome,
                                          monthIncomeCount)))
                            ])),
                      ])))),
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

/////////////////////////////////////////////////

class TodayTotal2 extends StatefulWidget {
  TodayTotal2();
  @override
  State<StatefulWidget> createState() => TodayTotal2State();
}

class TodayTotal2State extends State {
  DbHelper helper = DbHelper();

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
/////////////////////////////////////////

  var incomeMonth = new Month();
  var inversionMonth = new MonthInversion();

  ///

  int countIncome = 0;
  int countInversion = 0;
  int countExpense = 0;

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

  TodayTotal2State();

  @override
  Widget build(BuildContext context) {
    if (ejanuaryList == null) {
      ejanuaryList = List<Expense>();
      getDataExpense();
      getDataIncome();
      getDataInversion();
    }
    return Scaffold(
        backgroundColor: Colors.cyan,
        appBar: AppBar(
          title: Text("Totales"),
          centerTitle: true,
          backgroundColor: Colors.cyan,
        ),
        floatingActionButton: FloatingActionButton(
            child: Text("Volver"),
            backgroundColor: Colors.lightBlue,
            onPressed: () {
              Navigator.pop(context, true);
            }),
        body: Padding(
          padding: EdgeInsets.only(top: 20.0, left: 20),
          child: Center(
              child: SingleChildScrollView(
                  child: Container(
                      alignment: Alignment.center,
                      child: Column(children: <Widget>[
                        Row(children: <Widget>[
                          Expanded(
                            child: Text("Ingresos Enero(Ingre.-Gasto-Inver.): ",
                                style: TextStyle(color: Colors.white)),
                          ),
                          Expanded(
                              child: Text(
                                  '-\$' +
                                      calculateTotal(
                                          ejanuaryList,
                                          eJanuary,
                                          incomeMonth.januaryList,
                                          incomeMonth.notJanuary,
                                          inversionMonth.januaryList,
                                          inversionMonth.notJanuary),
                                  style: TextStyle(color: Colors.white)))
                        ]),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text(
                                      "Ingresos Febrero(Ingre.-Gasto-Inver.):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotal(
                                              efebruaryList,
                                              eFebruary,
                                              incomeMonth.februaryList,
                                              incomeMonth.notFebruary,
                                              inversionMonth.februaryList,
                                              inversionMonth.notFebruary),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text(
                                      "Ingresos Marzo(Ingre.-Gasto-Inver.):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotal(
                                              emarchList,
                                              eMarch,
                                              incomeMonth.marchList,
                                              incomeMonth.notMarch,
                                              inversionMonth.marchList,
                                              inversionMonth.notMarch),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text(
                                      "Ingresos Abril(Ingre.-Gasto-Inver.):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotal(
                                              eaprilList,
                                              eApril,
                                              incomeMonth.aprilList,
                                              incomeMonth.notApril,
                                              inversionMonth.aprilList,
                                              inversionMonth.notApril),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text(
                                      "Ingresos Mayo(Ingre.-Gasto-Inver.):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotal(
                                              emayList,
                                              eMay,
                                              incomeMonth.mayList,
                                              incomeMonth.notMay,
                                              inversionMonth.mayList,
                                              inversionMonth.notMay),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text(
                                      "Ingresos Junio(Ingre.-Gasto-Inver.):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotal(
                                              ejuneList,
                                              eJune,
                                              incomeMonth.juneList,
                                              incomeMonth.notJune,
                                              inversionMonth.juneList,
                                              inversionMonth.notJune),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text(
                                      "Ingresos Julio(Ingre.-Gasto-Inver.):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotal(
                                              ejulyList,
                                              eJuly,
                                              incomeMonth.julyList,
                                              incomeMonth.notJuly,
                                              inversionMonth.julyList,
                                              inversionMonth.notJuly),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text(
                                      "Ingresos Agosto(Ingre.-Gasto-Inver.):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotal(
                                              eaugustList,
                                              eAugust,
                                              incomeMonth.augustList,
                                              incomeMonth.notAugust,
                                              inversionMonth.augustList,
                                              inversionMonth.notAugust),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text(
                                      "Ingresos Septiembre(Ingre.-Gasto-Inver.):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotal(
                                              eseptemberList,
                                              eSeptember,
                                              incomeMonth.septemberList,
                                              incomeMonth.notSeptember,
                                              inversionMonth.septemberList,
                                              inversionMonth.notSeptember),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text(
                                      "Ingresos Octubre(Ingre.-Gasto-Inver.):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotal(
                                              eoctoberList,
                                              eOctober,
                                              incomeMonth.octoberList,
                                              incomeMonth.notOctober,
                                              inversionMonth.octoberList,
                                              inversionMonth.notOctober),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text(
                                      "Ingresos Noviembre(Ingre.-Gasto-Inver.):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotal(
                                              enovemberList,
                                              eNovember,
                                              incomeMonth.novemberList,
                                              incomeMonth.notNovember,
                                              inversionMonth.novemberList,
                                              inversionMonth.notNovember),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text(
                                      "Ingresos Diciembre(Ingre.-Gasto-Inver.):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotal(
                                              edecemberList,
                                              eDecember,
                                              incomeMonth.decemberList,
                                              incomeMonth.notDecember,
                                              inversionMonth.decemberList,
                                              inversionMonth.notDecember),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        //

                        Row(children: <Widget>[
                          Expanded(
                            child: Text("Ingresos Enero(Ingre-Gasto): ",
                                style: TextStyle(color: Colors.white)),
                          ),
                          Expanded(
                              child: Text(
                                  '-\$' +
                                      calculateTotalSimple(
                                          ejanuaryList,
                                          eJanuary,
                                          incomeMonth.januaryList,
                                          incomeMonth.notJanuary),
                                  style: TextStyle(color: Colors.white)))
                        ]),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Ingresos Febrero(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotalSimple(
                                              efebruaryList,
                                              eFebruary,
                                              incomeMonth.februaryList,
                                              incomeMonth.notFebruary),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Ingresos Marzo(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotalSimple(
                                              emarchList,
                                              eMarch,
                                              incomeMonth.marchList,
                                              incomeMonth.notMarch),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Ingresos Abril(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotalSimple(
                                              eaprilList,
                                              eApril,
                                              incomeMonth.aprilList,
                                              incomeMonth.notApril),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Ingresos Mayo(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotalSimple(
                                              emayList,
                                              eMay,
                                              incomeMonth.mayList,
                                              incomeMonth.notMay),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Ingresos Junio(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotalSimple(
                                              ejuneList,
                                              eJune,
                                              incomeMonth.juneList,
                                              incomeMonth.notJune),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Ingresos Julio(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotalSimple(
                                              ejulyList,
                                              eJuly,
                                              incomeMonth.julyList,
                                              incomeMonth.notJuly),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Ingresos Agosto(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotalSimple(
                                              eaugustList,
                                              eAugust,
                                              incomeMonth.augustList,
                                              incomeMonth.notAugust),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text(
                                      "Ingresos Septiembre(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotalSimple(
                                              eseptemberList,
                                              eSeptember,
                                              incomeMonth.septemberList,
                                              incomeMonth.notSeptember),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text("Ingresos Octubre(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotalSimple(
                                              eoctoberList,
                                              eOctober,
                                              incomeMonth.octoberList,
                                              incomeMonth.notOctober),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text(
                                      "Ingresos Noviembre(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotalSimple(
                                              enovemberList,
                                              eNovember,
                                              incomeMonth.novemberList,
                                              incomeMonth.notNovember),
                                      style: TextStyle(color: Colors.white)))
                            ])),
                        Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Text(
                                      "Ingresos Diciembre(Ingre-Gasto):",
                                      style: TextStyle(color: Colors.white))),
                              Expanded(
                                  child: Text(
                                      '\$' +
                                          calculateTotalSimple(
                                              edecemberList,
                                              eDecember,
                                              incomeMonth.decemberList,
                                              incomeMonth.notDecember),
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
              producAux.type == "Expense") {
            januaryList.add(producAux);
          } else {
            notJanuary = notJanuary + 1;
          }
          if (comparedate(producAux.date, februaryFrom, februaryTo) &&
              producAux.type == "Expense") {
            februaryList.add(producAux);
          } else {
            notFebruary = notFebruary + 1;
          }
          if (comparedate(producAux.date, marchFrom, marchTo) &&
              producAux.type == "Expense") {
            marchList.add(producAux);
          } else {
            notMarch = notMarch + 1;
          }
          if (comparedate(producAux.date, aprilFrom, aprilTo) &&
              producAux.type == "Expense") {
            aprilList.add(producAux);
          } else {
            notApril = notApril + 1;
          }
          if (comparedate(producAux.date, mayFrom, mayTo) &&
              producAux.type == "Expense") {
            mayList.add(producAux);
          } else {
            notMay = notMay + 1;
          }
          if (comparedate(producAux.date, juneFrom, juneTo) &&
              producAux.type == "Expense") {
            juneList.add(producAux);
          } else {
            notJune = notJune + 1;
          }
          if (comparedate(producAux.date, julyFrom, julyTo) &&
              producAux.type == "Expense") {
            julyList.add(producAux);
          } else {
            notJuly = notJuly + 1;
          }
          if (comparedate(producAux.date, augustFrom, augustTo) &&
              producAux.type == "Expense") {
            augustList.add(producAux);
          } else {
            notAugust = notAugust + 1;
          }
          if (comparedate(producAux.date, septemberFrom, septemberTo) &&
              producAux.type == "Expense") {
            septemberList.add(producAux);
          } else {
            notSeptember = notSeptember + 1;
          }
          if (comparedate(producAux.date, octoberFrom, octoberTo) &&
              producAux.type == "Expense") {
            octoberList.add(producAux);
          } else {
            notOctober = notOctober + 1;
          }
          if (comparedate(producAux.date, novemberFrom, novemberTo) &&
              producAux.type == "Expense") {
            novemberList.add(producAux);
          } else {
            notNovember = notNovember + 1;
          }
          if (comparedate(producAux.date, decemberFrom, decemberTo) &&
              producAux.type == "Expense") {
            decemberList.add(producAux);
          } else {
            notDecember = notDecember + 1;
          }
        }

        setState(() {
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

          eJanuary = eJanuary - notJanuary;
          eFebruary = eFebruary - notFebruary;
          eMarch = eMarch - notMarch;
          eApril = eApril - notApril;
          eMay = eMay - notMay;
          eJune = eJune - notJune;
          eJuly = eJuly - notJuly;
          eAugust = eAugust - notAugust;
          eSeptember = eSeptember - notSeptember;
          eOctober = eOctober - notOctober;
          eNovember = eNovember - notNovember;
          eDecember = eDecember - notDecember;
        });
      });
    });
  }

  void getDataIncome() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final expensesFuture = helper.getExpenses();
      expensesFuture.then((result) {
        countIncome = result.length;

        var income = Month();

        for (int i = 0; i < countIncome; i++) {
          Expense producAux = Expense.fromObject(result[i]);
          if (comparedate(producAux.date, januaryFrom, januaryTo) &&
              producAux.type == "Income") {
            income.januaryList.add(producAux);
          } else {
            income.notJanuary = income.notJanuary + 1;
          }
          if (comparedate(producAux.date, februaryFrom, februaryTo) &&
              producAux.type == "Income") {
            income.februaryList.add(producAux);
          } else {
            income.notFebruary = income.notFebruary + 1;
          }
          if (comparedate(producAux.date, marchFrom, marchTo) &&
              producAux.type == "Income") {
            income.marchList.add(producAux);
          } else {
            income.notMarch = income.notMarch + 1;
          }
          if (comparedate(producAux.date, aprilFrom, aprilTo) &&
              producAux.type == "Income") {
            income.aprilList.add(producAux);
          } else {
            income.notApril = income.notApril + 1;
          }
          if (comparedate(producAux.date, mayFrom, mayTo) &&
              producAux.type == "Income") {
            income.mayList.add(producAux);
          } else {
            income.notMay = income.notMay + 1;
          }
          if (comparedate(producAux.date, juneFrom, juneTo) &&
              producAux.type == "Income") {
            income.juneList.add(producAux);
          } else {
            income.notJune = income.notJune + 1;
          }
          if (comparedate(producAux.date, julyFrom, julyTo) &&
              producAux.type == "Income") {
            income.julyList.add(producAux);
          } else {
            income.notJuly = income.notJuly + 1;
          }
          if (comparedate(producAux.date, augustFrom, augustTo) &&
              producAux.type == "Income") {
            income.augustList.add(producAux);
          } else {
            income.notAugust = income.notAugust + 1;
          }
          if (comparedate(producAux.date, septemberFrom, septemberTo) &&
              producAux.type == "Income") {
            income.septemberList.add(producAux);
          } else {
            income.notSeptember = income.notSeptember + 1;
          }
          if (comparedate(producAux.date, octoberFrom, octoberTo) &&
              producAux.type == "Income") {
            income.octoberList.add(producAux);
          } else {
            income.notOctober = income.notOctober + 1;
          }
          if (comparedate(producAux.date, novemberFrom, novemberTo) &&
              producAux.type == "Income") {
            income.novemberList.add(producAux);
          } else {
            income.notNovember = income.notNovember + 1;
          }
          if (comparedate(producAux.date, decemberFrom, decemberTo) &&
              producAux.type == "Income") {
            income.decemberList.add(producAux);
          } else {
            income.notDecember = income.notDecember + 1;
          }
        }

        setState(() {
          incomeMonth.januaryList = income.januaryList;
          incomeMonth.februaryList = income.februaryList;
          incomeMonth.marchList = income.marchList;
          incomeMonth.aprilList = income.aprilList;
          incomeMonth.mayList = income.mayList;
          incomeMonth.juneList = income.juneList;
          incomeMonth.julyList = income.julyList;
          incomeMonth.augustList = income.augustList;
          incomeMonth.septemberList = income.septemberList;
          incomeMonth.octoberList = income.octoberList;
          incomeMonth.novemberList = income.novemberList;
          incomeMonth.decemberList = income.decemberList;

          incomeMonth.notJanuary = incomeMonth.notJanuary - income.notJanuary;
          incomeMonth.notFebruary =
              incomeMonth.notFebruary - income.notFebruary;
          incomeMonth.notMarch = incomeMonth.notMarch - income.notMarch;
          incomeMonth.notApril = incomeMonth.notApril - income.notApril;
          incomeMonth.notMay = incomeMonth.notMay - income.notMay;
          incomeMonth.notJune = incomeMonth.notJune - income.notJune;
          incomeMonth.notJuly = incomeMonth.notJuly - income.notJuly;
          incomeMonth.notAugust = incomeMonth.notAugust - income.notAugust;
          incomeMonth.notSeptember =
              incomeMonth.notSeptember - income.notSeptember;
          incomeMonth.notOctober = incomeMonth.notOctober - income.notOctober;
          incomeMonth.notNovember =
              incomeMonth.notNovember - income.notNovember;
          incomeMonth.notDecember =
              incomeMonth.notDecember - income.notDecember;
        });
      });
    });
  }

  void getDataInversion() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final inversionFuture = helper.getInversion();
      inversionFuture.then((result) {
        countInversion = result.length;
        var inversion = new MonthInversion();

        for (int i = 0; i < countInversion; i++) {
          Inversion producAux = Inversion.fromObject(result[i]);
          if (comparedate(producAux.date, januaryFrom, januaryTo)) {
            inversion.januaryList.add(producAux);
          } else {
            inversion.notJanuary = inversion.notJanuary + 1;
          }
          if (comparedate(producAux.date, februaryFrom, februaryTo)) {
            inversion.februaryList.add(producAux);
          } else {
            inversion.notFebruary = inversion.notFebruary + 1;
          }
          if (comparedate(producAux.date, marchFrom, marchTo)) {
            inversion.marchList.add(producAux);
          } else {
            inversion.notMarch = inversion.notMarch + 1;
          }
          if (comparedate(producAux.date, aprilFrom, aprilTo)) {
            inversion.aprilList.add(producAux);
          } else {
            inversion.notApril = inversion.notApril + 1;
          }
          if (comparedate(producAux.date, mayFrom, mayTo)) {
            inversion.mayList.add(producAux);
          } else {
            inversion.notMay = inversion.notMay + 1;
          }
          if (comparedate(producAux.date, juneFrom, juneTo)) {
            inversion.juneList.add(producAux);
          } else {
            inversion.notJune = inversion.notJune + 1;
          }
          if (comparedate(producAux.date, julyFrom, julyTo)) {
            inversion.julyList.add(producAux);
          } else {
            inversion.notJuly = inversion.notJuly + 1;
          }
          if (comparedate(producAux.date, augustFrom, augustTo)) {
            inversion.augustList.add(producAux);
          } else {
            inversion.notAugust = inversion.notAugust + 1;
          }
          if (comparedate(producAux.date, septemberFrom, septemberTo)) {
            inversion.septemberList.add(producAux);
          } else {
            inversion.notSeptember = inversion.notSeptember + 1;
          }
          if (comparedate(producAux.date, octoberFrom, octoberTo)) {
            inversion.octoberList.add(producAux);
          } else {
            inversion.notOctober = inversion.notOctober + 1;
          }
          if (comparedate(producAux.date, novemberFrom, novemberTo)) {
            inversion.novemberList.add(producAux);
          } else {
            inversion.notNovember = inversion.notNovember + 1;
          }
          if (comparedate(producAux.date, decemberFrom, decemberTo)) {
            inversion.decemberList.add(producAux);
          } else {
            inversion.notDecember = inversion.notDecember + 1;
          }
        }

        setState(() {
          inversionMonth.januaryList = inversion.januaryList;
          inversionMonth.februaryList = inversion.februaryList;
          inversionMonth.marchList = inversion.marchList;
          inversionMonth.aprilList = inversion.aprilList;
          inversionMonth.mayList = inversion.mayList;
          inversionMonth.juneList = inversion.juneList;
          inversionMonth.julyList = inversion.julyList;
          inversionMonth.augustList = inversion.augustList;
          inversionMonth.septemberList = inversion.septemberList;
          inversionMonth.octoberList = inversion.octoberList;
          inversionMonth.novemberList = inversion.novemberList;
          inversionMonth.decemberList = inversion.decemberList;

          inversionMonth.notJanuary =
              inversionMonth.notJanuary - inversion.notJanuary;
          inversionMonth.notFebruary =
              inversionMonth.notFebruary - inversion.notFebruary;
          inversionMonth.notMarch =
              inversionMonth.notMarch - inversion.notMarch;
          inversionMonth.notApril =
              inversionMonth.notApril - inversion.notApril;
          inversionMonth.notMay = inversionMonth.notMay - inversion.notMay;
          inversionMonth.notJune = inversionMonth.notJune - inversion.notJune;
          inversionMonth.notJuly = inversionMonth.notJuly - inversion.notJuly;
          inversionMonth.notAugust =
              inversionMonth.notAugust - inversion.notAugust;
          inversionMonth.notSeptember =
              inversionMonth.notSeptember - inversion.notSeptember;
          inversionMonth.notOctober =
              inversionMonth.notOctober - inversion.notOctober;
          inversionMonth.notNovember =
              inversionMonth.notNovember - inversion.notNovember;
          inversionMonth.notDecember =
              inversionMonth.notDecember - inversion.notDecember;
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

  bool comparedate(String date, DateTime dateTo, DateTime dateFrom) {
    DateTime dateD = new DateFormat().add_yMd().parse(date);
    if (dateD.isAfter(dateFrom.add(new Duration(days: -1))) &&
        dateD.isBefore(dateTo.add(new Duration(days: 1)))) {
      return true;
    } else {
      return false;
    }
  }
}
