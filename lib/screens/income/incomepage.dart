import 'package:flutter/material.dart';
import 'package:gastosapp/model/expense.dart';
import 'package:gastosapp/model/totalpermonth.dart';
import 'package:gastosapp/screens/income/incomedetails.dart';
import 'package:gastosapp/screens/others/loadandviewcsvpage.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class IncomePage extends StatefulWidget {
  final String date;
  IncomePage(this.date);
  @override
  State<StatefulWidget> createState() => IncomePageState(date);
}

class IncomePageState extends State {
  DbHelper helper = DbHelper();
  List<Expense> expenses;
  int count = 0;
  String date;
  TotalPerMonth tempTot;
  IncomePageState(this.date);

  @override
  Widget build(BuildContext context) {
    if (expenses == null) {
      expenses = List<Expense>();
      getData();
    }
    return  Stack(children: <Widget>[
      Image.asset("images/total.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          alignment: Alignment.center),
          Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(stringToDate(date)),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        bottom: PreferredSize(
            child: Text('Total: \$' + calculateTotalSales(expenses, count),
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
      body: expenseListItems(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.brown,
          onPressed: () {
            navigateToDetail(
                Expense('Otro', 0, 'Expense', date, '', 'Efectivo'));
          },
          tooltip: "Agregar nuevo gasto",
          child: new Icon(Icons.add)),
    )]);
  }

  ListView expenseListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          margin: EdgeInsets.all(3),
          color: Colors.brown[100],
          elevation: 2.0,
          child: ListTile(
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              leading: Icon(
                Icons.monetization_on,
                color: getColor(this.expenses[position].article),
                size: 40,
              ),
              title: Text(this.expenses[position].article),
              subtitle: Text(this.expenses[position].description),
              trailing: Text("\$" + this.expenses[position].price.toString()),
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
      final productsFuture = helper.getExpenses();
      productsFuture.then((result) {
        List<Expense> productList = List<Expense>();
        count = result.length;
        int notInRange = 0;
        for (int i = 0; i < count; i++) {
          Expense producAux = Expense.fromObject(result[i]);
          if (producAux.type == "Income" && producAux.date == date) {
            productList.add(producAux);
          } else {
            notInRange = notInRange + 1;
          }
        }
        setState(() {
          expenses = productList;
          count = count - notInRange;
        });
      });

      //Income total
      final total = helper.getTotalYear(getDate(date));
      TotalPerMonth totalAux;
      total.then((result) {
        int count = result.length;

        if (count == 0) {
          totalAux = new TotalPerMonth.withYear(getDate(date));
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
  }

  int getDate(String dateString) {
    var x = new DateFormat().add_yMd().parse(dateString).year;
    return x;
  }

  Color getColor(String article) {
    switch (article) {
      case "Ganancias":
        return Colors.blue;
        break;
      case "Inversion":
        return Colors.yellow;
        break;
      case "Prestamo":
        return Colors.green;
        break;

      case "Sueldo":
        return Colors.lightGreen;
        break;

      case "Otro":
        return Colors.grey;
        break;

      default:
        return Colors.grey;
    }
  }

  void navigateToDetail(Expense expense) async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => IncomeDetail(expense, date, tempTot)));
    if (result == true) {
      getData();
    }
  }

  String stringToDate(String aux) {
    var newDateTimeObj = new DateFormat().add_yMd().parse(aux);
    return newDateTimeObj.day.toString() +
        '/' +
        newDateTimeObj.month.toString() +
        '/' +
        newDateTimeObj.year.toString();
  }

  String calculateTotalSales(List<Expense> products, int count) {
    var total = 0;
    for (var i = 0; i < count; i++) {
      total = total + products[i].price;
    }
    return total.toString();
  }

  Future<void> _generateCSVAndView(context) async {
    List<List<String>> csvData;
    List<String> aux;
    csvData = [
      ['Articulo', 'Tipo', 'Descripcion', 'Fecha', 'Precio', '']
    ];

    for (var item in expenses) {
      aux = [
        item.article,
        'Ingreso',
        item.description,
        convertDatePath(item.date),
        item.price.toString(),
        ''
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
      final String path =
          '$dir/Ingresos' + convertDatePath(expenses[0].date) + '.csv';

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

  String convertDatePath(String aux) {
    var newDateTimeObj = new DateFormat().add_yMd().parse(aux);
    return newDateTimeObj.day.toString() +
        '-' +
        newDateTimeObj.month.toString() +
        '-' +
        newDateTimeObj.year.toString();
  }
}
