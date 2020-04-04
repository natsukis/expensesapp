import 'package:flutter/material.dart';
import 'package:gastosapp/model/expense.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:intl/intl.dart';
import 'package:gastosapp/model/inversion.dart';

class TotalMoves extends StatefulWidget {
  int count = 0;
  DateTime dateFrom;
  DateTime dateTo;
  TotalMoves(this.dateFrom, this.dateTo);
  @override
  State<StatefulWidget> createState() => TotalMovesState(dateFrom, dateTo);
}

class TotalMovesState extends State {
  DbHelper helper = DbHelper();
  List<Expense> expenses;
  int countInversion = 0;
  int countExpense = 0;
  int countTotal = 0;
  int count = 0;
  DateTime dateTo;
  DateTime dateFrom;
  List<Expense> total;
  TotalMovesState(this.dateFrom, this.dateTo);

  @override
  Widget build(BuildContext context) {
    if (expenses == null) {
      expenses = List<Expense>();
      getDataExpense();
      getDataInversion();
    }
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        title: Text("Todos los movimientos"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        bottom: PreferredSize(
            child: Text(
                stringToDateConvert(dateFrom) +
                    " a " +
                    stringToDateConvert(dateTo),
                style: TextStyle(color: Colors.white)),
            preferredSize: null),
      ),
      body: Center(child: productListItems()),
    );
  }

  ListView productListItems() {
    return ListView.builder(
      itemCount: countTotal,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.brown[100],
          elevation: 2.0,
          child: ListTile(
              leading: selectIcon(this.expenses[position].article,
                  this.expenses[position].type),
              title: Text(this.expenses[position].article),
              subtitle: Text('Total: \$' +
                  this.expenses[position].price.toString() +
                  '. Dia: ' +
                  stringToDate(this.expenses[position].date)),
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
        setState(() {
          expenses = expenseList;
          countExpense = countExpense - notToday;
          countTotal = countTotal + countExpense;
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
          } else {
            notToday = notToday + 1;
          }
        }
        setState(() {
          countInversion = countInversion - notToday;
          countTotal = countTotal + countInversion;
        });
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
}
