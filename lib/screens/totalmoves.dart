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
              leading: CircleAvatar(
                  backgroundColor: getColor(this.expenses[position].type),
                  child: Text(this.expenses[position].article.substring(0, 1))),
              title: Text(this.expenses[position].article),
              subtitle:
                  Text('Total: \$' + this.expenses[position].price.toString()),
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
            Expense temp = Expense('', 0, 'Inversion', '', '','Efectivo');
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

  Color getColor(String article) {
    switch (article) {
      case "Expense":
        return Colors.blue;
        break;
      case "Inversion":
        return Colors.orange;
        break;
      case "Income":
        return Colors.green;
        break;    
      default:
        return Colors.grey;
    }
  }
}
