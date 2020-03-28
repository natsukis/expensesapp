import 'package:flutter/material.dart';
import 'package:gastosapp/model/expense.dart';
import 'package:gastosapp/model/totalpermonth.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:gastosapp/screens/expense/expensedetails.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:gastosapp/screens/others/loadandviewcsvpage.dart';

class ExpenseRangeDay extends StatefulWidget {
  int count = 0;
  final DateTime dateFrom;
  final DateTime dateTo;
  ExpenseRangeDay(this.dateFrom, this.dateTo);
  @override
  State<StatefulWidget> createState() => ExpenseRangeDayState(dateFrom, dateTo);
}

class ExpenseRangeDayState extends State {
  DbHelper helper = DbHelper();
  List<Expense> expenses;
  int count = 0;
  DateTime dateTo;
  DateTime dateFrom;
  TotalPerMonth tempTot;
  ExpenseRangeDayState(this.dateFrom, this.dateTo);

  @override
  Widget build(BuildContext context) {
    if (expenses == null) {
      expenses = List<Expense>();
      getData();
    }
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        title: Text("Gastos totales"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        bottom: PreferredSize(
            child: Text(
                stringToDateConvert(dateFrom) +
                    " a " +
                    stringToDateConvert(dateTo),
                style: TextStyle(color: Colors.white)),
            preferredSize: null),
        actions: <Widget>[
          InkWell(
            onTap: () => _generateCSVAndView(context),
            child: Align(
              alignment: Alignment.center,
              child: Text('CSV'),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Center(child: productListItems()),
    );
  }

  ListView productListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.brown[100],
          elevation: 2.0,
          child: ListTile(
              leading: CircleAvatar(
                  backgroundColor: getColor(this.expenses[position].article),
                  child: Text(this.expenses[position].article.substring(0, 1))),
              title: Text(this.expenses[position].article),
              subtitle:
                  Text('Total: \$' + this.expenses[position].price.toString()),
              onTap: () {
                navigateToDetail(this.expenses[position]);
              }),
        );
      },
    );
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final expensesFuture = helper.getExpenses();
      expensesFuture.then((result) {
        List<Expense> productList = List<Expense>();
        count = result.length;
        int notInRange = 0;
        for (int i = 0; i < count; i++) {
          Expense producAux = Expense.fromObject(result[i]);
          if (comparedate(producAux.date) && (producAux.type == "Expense")) {
            productList.add(producAux);
          } else {
            notInRange = notInRange + 1;
          }
        }
        setState(() {
          expenses = productList;
          count = count - notInRange;
        });

        //total
        final total = helper.getTotalYear(dateFrom.year);
        TotalPerMonth totalAux;
        total.then((result) {
          int count = result.length;
          if (count == 0) {
            totalAux = new TotalPerMonth.withYear(dateFrom.year);
            helper.insertTotal(totalAux);
          } else {
            totalAux = TotalPerMonth.fromObject(result[0]);
          }
          if (mounted) {
            setState(() {
              tempTot = totalAux;
            });
          }
        });
      });
    });
  }

  void navigateToDetail(Expense expense) async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ExpenseDetail(expense, expense.date, tempTot)));
    if (result == true) {
      getData();
    }
  }

  String stringToDateConvert(DateTime aux) {
    return aux.day.toString() + '/' + aux.month.toString();
  }

  String stringToDateConvertCsv(DateTime aux) {
    return aux.day.toString() +
        '-' +
        aux.month.toString() +
        '-' +
        aux.year.toString();
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
      case "Luz":
        return Colors.blue;
        break;
      case "Impuesto":
        return Colors.yellow;
        break;
      case "Agua":
        return Colors.green;
        break;

      case "Telefono":
        return Colors.lightGreen;
        break;

      case "Internet":
        return Colors.brown;
        break;

      case "Celular":
        return Colors.red;
        break;

      case "Alquiler":
        return Colors.blueGrey;
        break;

      case "Nafta":
        return Colors.orange;
        break;

      case "Seguro":
        return Colors.cyan;
        break;

      case "Gastos comunes":
        return Colors.grey;
        break;

      case "Otro":
        return Colors.grey;
        break;

      default:
        return Colors.grey;
    }
  }

  Future<void> _generateCSVAndView(context) async {
    List<List<String>> csvData;
    List<String> aux;
    csvData = [
      ['Articulo', 'Tipo', 'Descripcion', 'Fecha', 'Precio']
    ];

    for (var item in expenses) {
      aux = [
        item.article,
        'Gasto',
        item.description,
        convertDate(item.date),
        item.price.toString(),
      ];
      csvData = csvData + [aux];
    }

    String csv = const ListToCsvConverter().convert(csvData);

    final PermissionHandler _permissionHandler = PermissionHandler();
    var result =
        await _permissionHandler.requestPermissions([PermissionGroup.storage]);

    if (result[PermissionGroup.storage] == PermissionStatus.granted) {
      // permission was granted
      final String dir = (await DownloadsPathProvider.downloadsDirectory).path;
      final String path = '$dir/Gastos' +
          stringToDateConvertCsv(dateFrom) +
          "a" +
          stringToDateConvertCsv(dateTo) +
          '.csv';

      // create file
      final File file = File(path);
      await file.writeAsString(csv);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => LoadAndViewCsvPage(path: path),
        ),
      );
    }
  }

  String convertDate(String aux) {
    var newDateTimeObj = new DateFormat().add_yMd().parse(aux);
    return newDateTimeObj.day.toString() +
        '/' +
        newDateTimeObj.month.toString() +
        '/' +
        newDateTimeObj.year.toString();
  }
}
