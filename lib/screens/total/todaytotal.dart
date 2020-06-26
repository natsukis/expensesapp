import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:gastosapp/model/expense.dart';
import 'package:gastosapp/model/inversion.dart';
import 'package:gastosapp/model/month.dart';
import 'package:gastosapp/model/monthinversion.dart';
import 'package:gastosapp/model/totalpermonth.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:gastosapp/util/months.dart';
import 'package:intl/intl.dart';

class TodayTotal extends StatefulWidget {
  String date;
  TodayTotal(this.date);
  @override
  State<StatefulWidget> createState() => TodayTotalState(date);
}

class TodayTotalState extends State {
  DbHelper helper = DbHelper();
  String date;
  TodayTotalState(this.date);
  PageController _controller = PageController(
    initialPage: 0,
  );
  TotalPerMonth tempTot;
  int status;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getTotal(getDate(date));
    return Scaffold(
        body: PageView(
      controller: _controller,
      children: [
        TotalMoves(),
        TodayTotal3(),
        TodayTotal2(tempTot, status),
      ],
    ));
  }

  String stringToDate(String aux) {
    var newDateTimeObj = new DateFormat().add_yMd().parse(aux);
    return newDateTimeObj.day.toString() +
        '/' +
        newDateTimeObj.month.toString() +
        '/' +
        newDateTimeObj.year.toString();
  }

  int getDate(String dateString) {
    var x = new DateFormat().add_yMd().parse(dateString).year;
    return x;
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
      if (mounted) {
        setState(() {
          tempTot = totalAux;
          status = statusTemp;
        });
      }
    });
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
      getMonthExpenseData();
      getMonthInversionData();
      getMonthIncomeData();
    }
    return Stack(children: <Widget>[
      Image.asset("images/total.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          alignment: Alignment.center),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Hoy"),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          floatingActionButton: FloatingActionButton(
              child: Text("Volver"),
              backgroundColor: Colors.brown,
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
                                    '               -\$' +
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
                                        '                \$' +
                                            calculateTotalExpenses(
                                                incomes, countIncome),
                                        style: TextStyle(
                                            color: Colors.greenAccent)))
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Text("Inversiones del dia: ",
                                        style: TextStyle(color: Colors.white))),
                                Expanded(
                                    child: Text(
                                        '                \$' +
                                            calculateTotalInversions(
                                                inversions, countInversion),
                                        style: TextStyle(
                                            color: Colors.blueAccent)))
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Text("Total (Ingre.-Gasto):",
                                        style:
                                            TextStyle(color: Colors.yellow))),
                                Expanded(
                                    child: Text(
                                        '                \$' +
                                            calculateTotalSimple(
                                                expenses,
                                                countExpense,
                                                incomes,
                                                countIncome),
                                        style: TextStyle(color: Colors.yellow)))
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Text("Gastos ult. 30 dias:",
                                        style: TextStyle(color: Colors.white))),
                                Expanded(
                                    child: Text(
                                        '               -\$' +
                                            calculateTotalExpenses(monthExpense,
                                                monthExpenseCount),
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
                                        '                \$' +
                                            calculateTotalExpenses(
                                                monthIncome, monthIncomeCount),
                                        style: TextStyle(
                                            color: Colors.greenAccent)))
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Text("Inversiones ult. 30 dias:",
                                        style: TextStyle(color: Colors.white))),
                                Expanded(
                                    child: Text(
                                        '                \$' +
                                            calculateTotalInversions(
                                                monthInversion,
                                                monthInversionCount),
                                        style: TextStyle(
                                            color: Colors.blueAccent))),
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Text("Total ult. 30 dias (I-G):",
                                        style:
                                            TextStyle(color: Colors.yellow))),
                                Expanded(
                                    child: Text(
                                        '                \$' +
                                            calculateTotalSimple(
                                                monthExpense,
                                                monthExpenseCount,
                                                monthIncome,
                                                monthIncomeCount),
                                        style: TextStyle(color: Colors.yellow)))
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Text("Gastos Mensuales --->",
                                  style: TextStyle(color: Colors.brown))),
                        ])))),
          ))
    ]);
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
        if (mounted) {
          setState(() {
            expenses = expenseList;
            countExpense = countExpense - notToday;
          });
        }
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
        if (mounted) {
          setState(() {
            incomes = expenseList;
            countIncome = countIncome - notToday;
          });
        }
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
        if (mounted) {
          setState(() {
            inversions = inversionList;
            countInversion = countInversion - notToday;
          });
        }
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
          if (diff.inDays <= 30 &&
              diff.inDays >= 0 &&
              producAux.type == "Income") {
            expenseList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        if (mounted) {
          setState(() {
            monthIncome = expenseList;
            monthIncomeCount = monthIncomeCount - notToday;
          });
        }
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
          if (diff.inDays <= 30 &&
              diff.inDays >= 0 &&
              (producAux.type == "Expense")) {
            expenseList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        if (mounted) {
          setState(() {
            monthExpense = expenseList;
            monthExpenseCount = monthExpenseCount - notToday;
          });
        }
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
          if (diff.inDays >= 0 && diff.inDays <= 30) {
            expenseList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        if (mounted) {
          setState(() {
            monthInversion = expenseList;
            monthInversionCount = monthInversionCount - notToday;
          });
        }
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

class TodayTotal2 extends StatelessWidget {
  TotalPerMonth totalMonth;
  int status;
  TodayTotal2(this.totalMonth, this.status);

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

  @override
  Widget build(BuildContext context) {
    if (status == 0) {
      ejanuaryList = List<Expense>();
      getDataExpense();
      getDataIncome();
      getDataInversion();

      totalMonth.january = calculateTotalSimple(ejanuaryList, eJanuary,
          incomeMonth.januaryList, incomeMonth.notJanuary);
      totalMonth.february = calculateTotalSimple(efebruaryList, eFebruary,
          incomeMonth.februaryList, incomeMonth.notFebruary);
      totalMonth.march = calculateTotalSimple(
          emarchList, eMarch, incomeMonth.marchList, incomeMonth.notMarch);
      totalMonth.april = calculateTotalSimple(
          eaprilList, eApril, incomeMonth.aprilList, incomeMonth.notApril);
      totalMonth.may = calculateTotalSimple(
          emayList, eMay, incomeMonth.mayList, incomeMonth.notMay);
      totalMonth.june = calculateTotalSimple(
          ejuneList, eJune, incomeMonth.juneList, incomeMonth.notJune);
      totalMonth.july = calculateTotalSimple(
          ejulyList, eJuly, incomeMonth.julyList, incomeMonth.notJuly);
      totalMonth.august = calculateTotalSimple(
          eaugustList, eAugust, incomeMonth.augustList, incomeMonth.notAugust);
      totalMonth.september = calculateTotalSimple(eseptemberList, eSeptember,
          incomeMonth.septemberList, incomeMonth.notSeptember);
      totalMonth.october = calculateTotalSimple(eoctoberList, eOctober,
          incomeMonth.octoberList, incomeMonth.notOctober);
      totalMonth.november = calculateTotalSimple(enovemberList, eNovember,
          incomeMonth.novemberList, incomeMonth.notNovember);
      totalMonth.december = calculateTotalSimple(edecemberList, eDecember,
          incomeMonth.decemberList, incomeMonth.notDecember);
      //
    }
    return Stack(children: <Widget>[
      Image.asset("images/total.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          alignment: Alignment.center),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Totales " + DateTime.now().year.toString()),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            bottom: PreferredSize(
                child: Text('Total: \$' + calculateAnualTotal().toString(),
                    style: TextStyle(color: Colors.yellow)),
                preferredSize: null),
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
                              child: Text("Total Enero: ",
                                  style: TextStyle(color: Colors.black)),
                            ),
                            Expanded(
                                child: Text(
                                    '                      \$' +
                                        totalMonth.january.toString(),
                                    style: TextStyle(color: Colors.white)))
                          ]),
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Text("Total Febrero:",
                                        style: TextStyle(color: Colors.black))),
                                Expanded(
                                    child: Text(
                                        '                      \$' +
                                            totalMonth.february.toString(),
                                        style: TextStyle(color: Colors.white)))
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Text("Total Marzo:",
                                        style: TextStyle(color: Colors.black))),
                                Expanded(
                                    child: Text(
                                        '                      \$' +
                                            totalMonth.march.toString(),
                                        style: TextStyle(color: Colors.white)))
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Text("Total Abril:",
                                        style: TextStyle(color: Colors.black))),
                                Expanded(
                                    child: Text(
                                        '                      \$' +
                                            totalMonth.april.toString(),
                                        style: TextStyle(color: Colors.white)))
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Text("Total Mayo:",
                                        style: TextStyle(color: Colors.black))),
                                Expanded(
                                    child: Text(
                                        '                      \$' +
                                            totalMonth.may.toString(),
                                        style: TextStyle(color: Colors.white)))
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Text("Total Junio:",
                                        style: TextStyle(color: Colors.black))),
                                Expanded(
                                    child: Text(
                                        '                      \$' +
                                            totalMonth.june.toString(),
                                        style: TextStyle(color: Colors.white)))
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Text("Total Julio:",
                                        style: TextStyle(color: Colors.black))),
                                Expanded(
                                    child: Text(
                                        '                      \$' +
                                            totalMonth.july.toString(),
                                        style: TextStyle(color: Colors.white)))
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Text("Total Agosto:",
                                        style: TextStyle(color: Colors.black))),
                                Expanded(
                                    child: Text(
                                        '                      \$' +
                                            totalMonth.august.toString(),
                                        style: TextStyle(color: Colors.white)))
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Text("Total Septiembre:",
                                        style: TextStyle(color: Colors.black))),
                                Expanded(
                                    child: Text(
                                        '                      \$' +
                                            totalMonth.september.toString(),
                                        style: TextStyle(color: Colors.white)))
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Text("Total Octubre:",
                                        style: TextStyle(color: Colors.black))),
                                Expanded(
                                    child: Text(
                                        '                      \$' +
                                            totalMonth.october.toString(),
                                        style: TextStyle(color: Colors.white)))
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Text("Total Noviembre:",
                                        style: TextStyle(color: Colors.black))),
                                Expanded(
                                    child: Text(
                                        '                      \$' +
                                            totalMonth.november.toString(),
                                        style: TextStyle(color: Colors.white)))
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Text("Total Diciembre:",
                                        style: TextStyle(color: Colors.black))),
                                Expanded(
                                    child: Text(
                                        '                      \$' +
                                            totalMonth.december.toString(),
                                        style: TextStyle(color: Colors.white)))
                              ])),
                          Padding(
                              padding: EdgeInsets.only(top: 37),
                              child: DotsIndicator(
                                dotsCount: 3,
                                position: 2,
                                decorator: DotsDecorator(
                                  color: Colors.brown,
                                  activeColor: Colors.white,
                                ),
                              ))
                        ])))),
          ))
    ]);
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

        incomeMonth.notJanuary = countIncome - income.notJanuary;
        incomeMonth.notFebruary = countIncome - income.notFebruary;
        incomeMonth.notMarch = countIncome - income.notMarch;
        incomeMonth.notApril = countIncome - income.notApril;
        incomeMonth.notMay = countIncome - income.notMay;
        incomeMonth.notJune = countIncome - income.notJune;
        incomeMonth.notJuly = countIncome - income.notJuly;
        incomeMonth.notAugust = countIncome - income.notAugust;
        incomeMonth.notSeptember = countIncome - income.notSeptember;
        incomeMonth.notOctober = countIncome - income.notOctober;
        incomeMonth.notNovember = countIncome - income.notNovember;
        incomeMonth.notDecember = countIncome - income.notDecember;
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

        inversionMonth.notJanuary = countInversion - inversion.notJanuary;
        inversionMonth.notFebruary = countInversion - inversion.notFebruary;
        inversionMonth.notMarch = countInversion - inversion.notMarch;
        inversionMonth.notApril = countInversion - inversion.notApril;
        inversionMonth.notMay = countInversion - inversion.notMay;
        inversionMonth.notJune = countInversion - inversion.notJune;
        inversionMonth.notJuly = countInversion - inversion.notJuly;
        inversionMonth.notAugust = countInversion - inversion.notAugust;
        inversionMonth.notSeptember = countInversion - inversion.notSeptember;
        inversionMonth.notOctober = countInversion - inversion.notOctober;
        inversionMonth.notNovember = countInversion - inversion.notNovember;
        inversionMonth.notDecember = countInversion - inversion.notDecember;
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

  int calculateTotalSimple(
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

    return (total - totalexpense);
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

  int calculateAnualTotal() {
    return totalMonth.january +
        totalMonth.february +
        totalMonth.march +
        totalMonth.april +
        totalMonth.may +
        totalMonth.june +
        totalMonth.july +
        totalMonth.august +
        totalMonth.september +
        totalMonth.october +
        totalMonth.november +
        totalMonth.december;
  }
}

class TodayTotal3 extends StatefulWidget {
  TodayTotal3();
  @override
  State<StatefulWidget> createState() => TodayTotal3State();
}

class TodayTotal3State extends State {
  DbHelper helper = DbHelper();
  Months month = Months();
  List<Expense> expenses;
  int countExpense = 0;
  int creditCount = 0;
  String totalCreditToPay = "";
  String totalCreditNextMontPay = "";

  //Diferent expenses
  Expense alquiler;
  Expense celular;
  Expense colectivo;
  Expense compra;
  Expense gastos;
  Expense hospedaje;
  Expense impuesto;
  Expense internet;
  Expense nafta;
  Expense otro;
  Expense prestamo;
  Expense regalo;
  Expense salida;
  Expense seguro;
  Expense supermercado;
  Expense tarjeta;
  Expense taxi;
  Expense viaje;
  List<Expense> expenseResume = List<Expense>();
  int countResume = 0;

  TodayTotal3State();

  @override
  Widget build(BuildContext context) {
    if (expenses == null) {
      expenses = List<Expense>();
      getDataExpense();
    }
    return Stack(children: <Widget>[
      Image.asset("images/total.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          alignment: Alignment.center),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Gastos del mes"),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 10.0, left: 5, right: 5),
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.yellow[300],
                        border: Border.all(color: Colors.yellow),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Row(children: <Widget>[
                      Expanded(
                        child: Text("Total a pagar este mes: ",
                            style: TextStyle(color: Colors.black)),
                      ),
                      Expanded(
                          child: Text('                  \$' + totalCreditToPay,
                              style: TextStyle(color: Colors.black)))
                    ])),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.yellow[300],
                          border: Border.all(color: Colors.yellow),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Row(children: <Widget>[
                        Expanded(
                          child: Text("Total del proximo mes: ",
                              style: TextStyle(color: Colors.black)),
                        ),
                        Expanded(
                            child: Text(
                                '                  \$' + totalCreditNextMontPay,
                                style: TextStyle(color: Colors.black)))
                      ]))),
              Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 10),
                  child: Row(children: <Widget>[
                    Expanded(
                      child: Text("Consumos: ",
                          style: TextStyle(color: Colors.yellow)),
                    ),
                    Expanded(child: Text(""))
                  ])),
              Expanded(child: expenseListItems()),
              DotsIndicator(
                dotsCount: 3,
                position: 1,
                decorator: DotsDecorator(
                  color: Colors.brown,
                  activeColor: Colors.white,
                ),
              )
            ]),
          ))
    ]);
  }

  ListView expenseListItems() {
    return ListView.builder(
      itemCount: countResume,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          margin: EdgeInsets.all(2),
          color: Colors.brown[100],
          elevation: 2.0,
          child: ListTile(
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              leading: selectIcon(this.expenseResume[position].article),
              title: Text(this.expenseResume[position].article),
              trailing:
                  Text("\$" + this.expenseResume[position].price.toString()),
              onTap: () {}),
        );
      },
    );
  }

  void getDataExpense() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final expensesFuture = helper.getExpenses();
      expensesFuture.then((result) {
        countExpense = result.length;

        //List
        int expenseCount = 0;
        int futureCount = 0;
        int contTempResume = 0;
        List<Expense> futureCredit = List<Expense>();

        for (int i = 0; i < countExpense; i++) {
          Expense producAux = Expense.fromObject(result[i]);

          if (comparedate(producAux.date, getInitialDate(DateTime.now().month),
                  getEndDate(DateTime.now().month)) &&
              producAux.type == "Expense") {
            switch (producAux.article) {
              case "Alquiler":
                if (alquiler == null) {
                  alquiler = producAux;
                } else {
                  alquiler.price = alquiler.price + producAux.price;
                }
                break;
              case "Colectivo":
                if (colectivo == null) {
                  colectivo = producAux;
                } else {
                  colectivo.price = colectivo.price + producAux.price;
                }
                break;
              case "Celular":
                if (celular == null) {
                  celular = producAux;
                } else {
                  celular.price = celular.price + producAux.price;
                }
                break;

              case "Compra":
                if (compra == null) {
                  compra = producAux;
                } else {
                  compra.price = compra.price + producAux.price;
                }
                break;

              case "Impuesto":
                if (impuesto == null) {
                  impuesto = producAux;
                } else {
                  impuesto.price = impuesto.price + producAux.price;
                }
                break;

              case "Nafta":
                if (nafta == null) {
                  nafta = producAux;
                } else {
                  nafta.price = nafta.price + producAux.price;
                }
                break;

              case "Internet":
                if (internet == null) {
                  internet = producAux;
                } else {
                  internet.price = internet.price + producAux.price;
                }
                break;

              case "Prestamo":
                if (prestamo == null) {
                  prestamo = producAux;
                } else {
                  prestamo.price = prestamo.price + producAux.price;
                }
                break;

              case "Regalo":
                if (regalo == null) {
                  regalo = producAux;
                } else {
                  regalo.price = regalo.price + producAux.price;
                }
                break;

              case "Salida":
                if (salida == null) {
                  salida = producAux;
                } else {
                  salida.price = salida.price + producAux.price;
                }
                break;

              case "Seguro":
                if (seguro == null) {
                  seguro = producAux;
                } else {
                  seguro.price = seguro.price + producAux.price;
                }
                break;

              case "Taxi":
                if (taxi == null) {
                  taxi = producAux;
                } else {
                  taxi.price = taxi.price + producAux.price;
                }
                break;

              case "Gastos comunes":
                if (gastos == null) {
                  gastos = producAux;
                } else {
                  gastos.price = gastos.price + producAux.price;
                }
                break;

              case "Hospedaje":
                if (hospedaje == null) {
                  hospedaje = producAux;
                } else {
                  hospedaje.price = hospedaje.price + producAux.price;
                }
                break;

              case "Supermercado":
                if (supermercado == null) {
                  supermercado = producAux;
                } else {
                  supermercado.price = supermercado.price + producAux.price;
                }
                break;

              case "Viaje":
                if (viaje == null) {
                  viaje = producAux;
                } else {
                  viaje.price = viaje.price + producAux.price;
                }
                break;

              case "Tarjeta":
                if (tarjeta == null) {
                  tarjeta = producAux;
                } else {
                  tarjeta.price = tarjeta.price + producAux.price;
                }
                break;

              case "Otro":
                if (otro == null) {
                  otro = producAux;
                } else {
                  otro.price = otro.price + producAux.price;
                }
                break;
            }
          } else {
            expenseCount = expenseCount + 1;
          }
          if (comparedate(
                  producAux.date,
                  getInitialDate(DateTime.now().month + 1),
                  getEndDate(DateTime.now().month + 1)) &&
              producAux.type == "Expense") {
            futureCredit.add(producAux);
          } else {
            futureCount = futureCount + 1;
          }
        }

        //add to resume the expenses
        if (alquiler != null) {
          expenseResume.add(alquiler);
          contTempResume = contTempResume + 1;
        }
        if (celular != null) {
          expenseResume.add(celular);
          contTempResume = contTempResume + 1;
        }
        if (colectivo != null) {
          expenseResume.add(colectivo);
          contTempResume = contTempResume + 1;
        }
        if (compra != null) {
          expenseResume.add(compra);
          contTempResume = contTempResume + 1;
        }
        if (gastos != null) {
          expenseResume.add(gastos);
          contTempResume = contTempResume + 1;
        }
        if (hospedaje != null) {
          expenseResume.add(hospedaje);
          contTempResume = contTempResume + 1;
        }
        if (impuesto != null) {
          expenseResume.add(impuesto);
          contTempResume = contTempResume + 1;
        }
        if (internet != null) {
          expenseResume.add(internet);
          contTempResume = contTempResume + 1;
        }
        if (nafta != null) {
          expenseResume.add(nafta);
          contTempResume = contTempResume + 1;
        }
        if (otro != null) {
          expenseResume.add(otro);
          contTempResume = contTempResume + 1;
        }
        if (prestamo != null) {
          expenseResume.add(prestamo);
          contTempResume = contTempResume + 1;
        }
        if (regalo != null) {
          expenseResume.add(regalo);
          contTempResume = contTempResume + 1;
        }
        if (salida != null) {
          expenseResume.add(salida);
          contTempResume = contTempResume + 1;
        }
        if (seguro != null) {
          expenseResume.add(seguro);
          contTempResume = contTempResume + 1;
        }
        if (supermercado != null) {
          expenseResume.add(supermercado);
          contTempResume = contTempResume + 1;
        }
        if (tarjeta != null) {
          expenseResume.add(tarjeta);
          contTempResume = contTempResume + 1;
        }
        if (taxi != null) {
          expenseResume.add(taxi);
          contTempResume = contTempResume + 1;
        }
        if (viaje != null) {
          expenseResume.add(viaje);
          contTempResume = contTempResume + 1;
        }

        if (mounted) {
          setState(() {
            countResume = contTempResume;
            totalCreditToPay =
                calculateTotalExpenses(expenseResume, countResume);
            totalCreditNextMontPay = calculateTotalExpenses(
                futureCredit, countExpense - futureCount);
          });
        }
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

  bool comparedate(String date, DateTime dateFrom, DateTime dateTo) {
    DateTime dateD = new DateFormat().add_yMd().parse(date);
    if (dateD.isAfter(dateFrom.add(new Duration(days: -1))) &&
        dateD.isBefore(dateTo.add(new Duration(days: 1)))) {
      return true;
    } else {
      return false;
    }
  }

  Icon selectIcon(String article) {
    switch (article) {
      case "Alquiler":
        return Icon(Icons.home, color: Colors.blue, size: 40);
        break;
      case "Colectivo":
        return Icon(Icons.directions_bus,
            color: Colors.lightBlue[200], size: 40);
        break;
      case "Celular":
        return Icon(Icons.phone_android, color: Colors.white, size: 40);
        break;

      case "Compra":
        return Icon(Icons.shopping_basket, color: Colors.green, size: 40);
        break;

      case "Impuesto":
        return Icon(Icons.money_off, color: Colors.red[400], size: 40);
        break;

      case "Nafta":
        return Icon(Icons.local_gas_station, color: Colors.black, size: 40);
        break;

      case "Internet":
        return Icon(Icons.computer, color: Colors.blueGrey, size: 40);
        break;

      case "Prestamo":
        return Icon(Icons.attach_money, color: Colors.red, size: 40);
        break;

      case "Regalo":
        return Icon(Icons.card_giftcard, color: Colors.cyan, size: 40);
        break;

      case "Salida":
        return Icon(Icons.local_bar, color: Colors.orange, size: 40);
        break;

      case "Seguro":
        return Icon(Icons.security, color: Colors.pink, size: 40);
        break;

      case "Taxi":
        return Icon(Icons.local_taxi, color: Colors.yellow[400], size: 40);
        break;

      case "Gastos comunes":
        return Icon(Icons.local_cafe, color: Colors.grey[600], size: 40);
        break;

      case "Hospedaje":
        return Icon(Icons.hotel, color: Colors.brown[600], size: 40);
        break;

      case "Supermercado":
        return Icon(Icons.local_grocery_store, color: Colors.purple, size: 40);
        break;

      case "Viaje":
        return Icon(Icons.card_travel, color: Colors.orange[200], size: 40);
        break;

      case "Tarjeta":
        return Icon(Icons.credit_card, color: Colors.blueAccent, size: 40);
        break;

      case "Otro":
        return Icon(Icons.add_box, color: Colors.brown[400], size: 40);
        break;

      default:
        return Icon(Icons.add_box, color: Colors.brown[400], size: 40);
    }
  }

  DateTime getInitialDate(int search) {
    switch (search) {
      case 1:
        return month.januaryFrom;
        break;
      case 2:
        return month.februaryFrom;
        break;
      case 3:
        return month.marchFrom;
        break;
      case 4:
        return month.aprilFrom;
        break;
      case 5:
        return month.mayFrom;
        break;
      case 6:
        return month.juneFrom;
        break;
      case 7:
        return month.julyFrom;
        break;
      case 8:
        return month.augustFrom;
        break;
      case 9:
        return month.septemberFrom;
        break;
      case 10:
        return month.octoberFrom;
        break;
      case 11:
        return month.novemberFrom;
        break;
      case 12:
        return month.decemberFrom;
        break;
      default:
        return DateTime.now();
    }
  }

  DateTime getEndDate(int search) {
    switch (search) {
      case 1:
        return month.januaryTo;
        break;
      case 2:
        return month.februaryTo;
        break;
      case 3:
        return month.marchTo;
        break;
      case 4:
        return month.aprilTo;
        break;
      case 5:
        return month.mayTo;
        break;
      case 6:
        return month.juneTo;
        break;
      case 7:
        return month.julyTo;
        break;
      case 8:
        return month.aprilTo;
        break;
      case 9:
        return month.septemberTo;
        break;
      case 10:
        return month.octoberTo;
        break;
      case 11:
        return month.novemberTo;
        break;
      case 12:
        return month.decemberTo;
        break;
      default:
        return DateTime.now();
    }
  }
}

class TotalMoves extends StatefulWidget {
  int count = 0;
  TotalMoves();
  @override
  State<StatefulWidget> createState() => TotalMovesState();
}

class TotalMovesState extends State {
  DbHelper helper = DbHelper();
  List<Expense> expenses;
  List<Expense> expensesTotal;
  List<Expense> incomes;
  List<Inversion> inversions;
  List<Inversion> inversion;
  int countInversion = 0;
  int countExpense = 0;
  int countExpenseTotal = 0;
  int countIncome = 0;
  int countTotal = 0;
  int count = 0;
  DateTime dateTo = DateTime.now();
  DateTime dateFrom = DateTime.now();
  List<Expense> total;
  TotalMovesState();

  @override
  Widget build(BuildContext context) {
    if (expenses == null) {
      expenses = List<Expense>();
      inversion = List<Inversion>();
      getDataExpense();
      getDataInversion();
      getDataExpenseTotal();
      getDataIncome();
    }
    return Stack(children: <Widget>[
      Image.asset("images/total.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          alignment: Alignment.center),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Resumen de hoy"),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 10.0, left: 5, right: 5),
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.yellow[300],
                        border: Border.all(color: Colors.yellow),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Row(children: <Widget>[
                      Expanded(
                        child: Text("Gastos: ",
                            style: TextStyle(color: Colors.black)),
                      ),
                      Expanded(
                          child: Text(
                              '                   \$' +
                                  calculateTotalExpenses(
                                      expensesTotal, countExpenseTotal),
                              style: TextStyle(color: Colors.black)))
                    ])),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.yellow[300],
                          border: Border.all(color: Colors.yellow),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Row(children: <Widget>[
                        Expanded(
                          child: Text("Ingresos: ",
                              style: TextStyle(color: Colors.black)),
                        ),
                        Expanded(
                            child: Text(
                                '                   \$' +
                                    calculateTotalExpenses(
                                        incomes, countIncome),
                                style: TextStyle(color: Colors.black)))
                      ]))),
              Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.yellow[300],
                          border: Border.all(color: Colors.yellow),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Row(children: <Widget>[
                        Expanded(
                          child: Text("Inversiones: ",
                              style: TextStyle(color: Colors.black)),
                        ),
                        Expanded(
                            child: Text(
                                '                   \$' +
                                    calculateTotalInversions(
                                        inversions, countInversion),
                                style: TextStyle(color: Colors.black)))
                      ]))),
              Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 10),
                  child: Row(children: <Widget>[
                    Expanded(
                      child: Text("Movimientos: ",
                          style: TextStyle(color: Colors.yellow)),
                    ),
                    Expanded(child: Text(""))
                  ])),
              Expanded(child: productListItems()),
              DotsIndicator(
                dotsCount: 3,
                position: 0,
                decorator: DotsDecorator(
                  color: Colors.brown,
                  activeColor: Colors.white,
                ),
              )
            ]),
          ))
    ]);
  }

  ListView productListItems() {
    return ListView.builder(
      itemCount: countTotal,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          margin: EdgeInsets.all(2),
          color: Colors.brown[100],
          elevation: 2.0,
          child: ListTile(
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              leading: selectIcon(this.expenses[position].article,
                  this.expenses[position].type),
              title: Text(this.expenses[position].article),
              trailing: Text('\$' + this.expenses[position].price.toString()),
              onTap: () {}),
        );
      },
    );
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
          if (comparedate(producAux.date)) {
            expenseList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        if (mounted) {
          setState(() {
            expenses = expenseList;
            countExpense = countExpense - notToday;
            countTotal = countTotal + countExpense;
          });
        }
      });
    });
  }

  void getDataExpenseTotal() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final expensesFuture = helper.getExpenses();
      expensesFuture.then((result) {
        List<Expense> expenseList = List<Expense>();
        countExpenseTotal = result.length;
        int notToday = 0;
        for (int i = 0; i < countExpenseTotal; i++) {
          Expense producAux = Expense.fromObject(result[i]);
          if (comparedate(producAux.date) && producAux.type == "Expense") {
            expenseList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        if (mounted) {
          setState(() {
            expensesTotal = expenseList;
            countExpenseTotal = countExpenseTotal - notToday;
          });
        }
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
        if (mounted) {
          setState(() {
            incomes = expenseList;
            countIncome = countIncome - notToday;
          });
        }
      });
    });
  }

  void getDataInversion() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final inversionFuture = helper.getInversion();
      inversionFuture.then((result) {
        countInversion = result.length;
        int notToday = 0;
        for (int i = 0; i < countInversion; i++) {
          Inversion producAux = Inversion.fromObject(result[i]);
          if (comparedate(producAux.date)) {
            Expense temp = Expense('', 0, 'Inversion', '', '', 'Efectivo');
            temp.article = producAux.article;
            temp.date = producAux.date;
            temp.description = producAux.description;
            temp.price = producAux.price;
            expenses.add(temp);
            inversion.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        if (mounted) {
          setState(() {
            inversions = inversion;
            countInversion = countInversion - notToday;
            countTotal = countTotal + countInversion;
          });
        }
      });
    });
  }

  String stringToDateConvert(DateTime aux) {
    return aux.day.toString() + '/' + aux.month.toString();
  }

  String stringToDate(String aux) {
    var newDateTimeObj = new DateFormat().add_yMd().parse(aux);
    return newDateTimeObj.day.toString() +
        '/' +
        newDateTimeObj.month.toString() +
        '/' +
        newDateTimeObj.year.toString();
  }

  String convertDatePath(String aux) {
    var newDateTimeObj = new DateFormat().add_yMd().parse(aux);
    return newDateTimeObj.month.toString() +
        '-' +
        newDateTimeObj.day.toString() +
        '-' +
        newDateTimeObj.year.toString();
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

  Icon selectIcon(String article, String type) {
    switch (type) {
      case "Expense":
        switch (article) {
          case "Alquiler":
            return Icon(Icons.home, color: Colors.blue, size: 40);
            break;
          case "Colectivo":
            return Icon(Icons.directions_bus,
                color: Colors.lightBlue[200], size: 40);
            break;
          case "Celular":
            return Icon(Icons.phone_android, color: Colors.white, size: 40);
            break;

          case "Compra":
            return Icon(Icons.shopping_basket, color: Colors.green, size: 40);
            break;

          case "Impuesto":
            return Icon(Icons.money_off, color: Colors.red[400], size: 40);
            break;

          case "Nafta":
            return Icon(Icons.local_gas_station, color: Colors.black, size: 40);
            break;

          case "Internet":
            return Icon(Icons.computer, color: Colors.blueGrey, size: 40);
            break;

          case "Prestamo":
            return Icon(Icons.attach_money, color: Colors.red, size: 40);
            break;

          case "Regalo":
            return Icon(Icons.card_giftcard, color: Colors.cyan, size: 40);
            break;

          case "Salida":
            return Icon(Icons.local_bar, color: Colors.orange, size: 40);
            break;

          case "Seguro":
            return Icon(Icons.security, color: Colors.pink, size: 40);
            break;

          case "Taxi":
            return Icon(Icons.local_taxi, color: Colors.yellow[400], size: 40);
            break;

          case "Gastos comunes":
            return Icon(Icons.local_cafe, color: Colors.grey[600], size: 40);
            break;

          case "Hospedaje":
            return Icon(Icons.hotel, color: Colors.brown[600], size: 40);
            break;

          case "Supermercado":
            return Icon(Icons.local_grocery_store,
                color: Colors.purple, size: 40);
            break;

          case "Viaje":
            return Icon(Icons.card_travel, color: Colors.orange[200], size: 40);
            break;

          case "Tarjeta":
            return Icon(Icons.credit_card, color: Colors.blueAccent, size: 40);
            break;

          case "Otro":
            return Icon(Icons.add_box, color: Colors.brown[400], size: 40);
            break;

          default:
            return Icon(Icons.add_box, color: Colors.brown[400], size: 40);
        }
        break;
      case "Inversion":
        return Icon(
          Icons.score,
          color: Colors.orange,
          size: 40,
        );
        break;
      case "Income":
        return Icon(
          Icons.monetization_on,
          color: Colors.green,
          size: 40,
        );
        break;
      default:
        return Icon(Icons.add_box, color: Colors.brown[400], size: 40);
    }
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
