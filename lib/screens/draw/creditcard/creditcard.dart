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
            title: Text("Resumen de tarjeta "),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 20.0, left: 5, right: 5),
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
          margin: EdgeInsets.all(1),
          color: Colors.brown[100],
          elevation: 2.0,
          child: ListTile(
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              leading: selectIcon(this.expenses[position].article),
              title: Text(this.expenses[position].article + ':'),
              subtitle: Text(this.expenses[position].description),
              trailing: Text("\$" + this.expenses[position].price.toString()),
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
