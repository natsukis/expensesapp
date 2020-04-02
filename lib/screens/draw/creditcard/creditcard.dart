import 'package:flutter/material.dart';
import 'package:gastosapp/model/expense.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:gastosapp/util/months.dart';
import 'package:intl/intl.dart';

class CreditCard extends StatefulWidget {
  CreditCard();
  @override
  State<StatefulWidget> createState() => CreditCardState();
}

class CreditCardState extends State {
  DbHelper helper = DbHelper();
  Months month = Months();
  List<Expense> expenses;
  int countExpense = 0;
  int creditCount = 0;
  String totalCreditToPay = "";
  String totalCreditNextMontPay = "";

  CreditCardState();

  @override
  Widget build(BuildContext context) {
    if (expenses == null) {
      expenses = List<Expense>();
      getDataExpense();
    }
    return Stack(children: <Widget>[
      Image.asset("images/creditcard.jpg",
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
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 20.0, left: 10),
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
                          child: Text(
                              '                     \$' + totalCreditToPay,
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
                                '                     \$' +
                                    totalCreditNextMontPay,
                                style: TextStyle(color: Colors.black)))
                      ]))),
              Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20),
                  child: Row(children: <Widget>[
                    Expanded(
                      child: Text("Consumos: ",
                          style: TextStyle(color: Colors.yellow)),
                    ),
                    Expanded(child: Text(""))
                  ])),
              Expanded(child: expenseListItems())
            ]),
          ))
    ]);
  }

  ListView expenseListItems() {
    return ListView.builder(
      itemCount: creditCount,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.brown[100],
          elevation: 2.0,
          child: ListTile(
              leading: CircleAvatar(
                  child: Text(this.expenses[position].article.substring(0, 1))),
              title: Text(this.expenses[position].article.toString() +
                  ': \$' +
                  this.expenses[position].price.toString()),
              subtitle: Text(this.expenses[position].description),
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
        List<Expense> futureCredit = List<Expense>();

        for (int i = 0; i < countExpense; i++) {
          Expense producAux = Expense.fromObject(result[i]);

          if (comparedate(producAux.date, getInitialDate(DateTime.now().month),
                  getEndDate(DateTime.now().month)) &&
              producAux.type == "Expense" &&
              (producAux.method == "Tarjeta 1c" ||
                  producAux.method == "Tarjeta 3c" ||
                  producAux.method == "Tarjeta 6c" ||
                  producAux.method == "Tarjeta 12c")) {
            expenses.add(producAux);
          } else {
            expenseCount = expenseCount + 1;
          }
          if (comparedate(
                  producAux.date,
                  getInitialDate(DateTime.now().month + 1),
                  getEndDate(DateTime.now().month + 1)) &&
              producAux.type == "Expense" &&
              (producAux.method == "Tarjeta 1c" ||
                  producAux.method == "Tarjeta 3c" ||
                  producAux.method == "Tarjeta 6c" ||
                  producAux.method == "Tarjeta 12c")) {
            futureCredit.add(producAux);
          } else {
            futureCount = futureCount + 1;
          }
        }

        setState(() {
          creditCount = countExpense - expenseCount;
          totalCreditToPay = calculateTotalExpenses(expenses, creditCount);
          totalCreditNextMontPay =
              calculateTotalExpenses(futureCredit, countExpense - futureCount);
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

  bool comparedate(String date, DateTime dateFrom, DateTime dateTo) {
    DateTime dateD = new DateFormat().add_yMd().parse(date);
    if (dateD.isAfter(dateFrom.add(new Duration(days: -1))) &&
        dateD.isBefore(dateTo.add(new Duration(days: 1)))) {
      return true;
    } else {
      return false;
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
        return month.mayFrom;
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
