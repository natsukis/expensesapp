import 'package:flutter/material.dart';
import 'package:gastosapp/model/expense.dart';
import 'package:gastosapp/model/totalpermonth.dart';
import 'package:gastosapp/screens/others/loadandviewcsvpage.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:gastosapp/screens/expense/expensedetails.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class ExpensePage extends StatefulWidget {
  final String date;
  ExpensePage(this.date);
  @override
  State<StatefulWidget> createState() => ExpensePageState(date);
}

class ExpensePageState extends State {
  ExpensePageState(this.date);
  DbHelper helper = DbHelper();
  List<Expense> expenses;
  TotalPerMonth tempTot;
  TotalPerMonth totalNextYear;
  int count = 0;
  String date;
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
          onPressed: () {
            navigateToDetail(
                Expense('Otro', 0, 'Expense', date, '', 'Efectivo'));
          },
          backgroundColor: Colors.brown,
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
              leading: selectIcon(this.expenses[position].article),
              title: Text(this.expenses[position].article ),
              subtitle: Text(this.expenses[position].description),
              trailing:
                  Text("\$" + this.expenses[position].price.toString()),
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
          if (producAux.type == "Expense" && producAux.date == date) {
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

      //total
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

      //total next year
      final totalNext = helper.getTotalYear(getDate(date) + 1);
      TotalPerMonth totalAuxNextYear;
      totalNext.then((result) {
        int count = result.length;
        if (count == 0) {
          totalAuxNextYear = new TotalPerMonth.withYear(getDate(date) + 1);
          helper.insertTotal(totalAuxNextYear);
        } else {
          totalAuxNextYear = TotalPerMonth.fromObject(result[0]);
        }
        if (mounted) {
          setState(() {
            totalNextYear = totalAuxNextYear;
          });
        }
      });
    });
  }

  int getDate(String dateString) {
    var x = new DateFormat().add_yMd().parse(dateString).year;
    return x;
  }

  Icon selectIcon(String article) {
    switch (article) {
      case "Alquiler":
        return Icon(Icons.home, color: Colors.blue, size: 40);
        break;
      case "Colectivo":
        return Icon(Icons.directions_bus, color: Colors.lightBlue[200], size: 40);
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

  void navigateToDetail(Expense expense) async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ExpenseDetail(expense, date, tempTot, totalNextYear)));
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
      ['Articulo', 'Tipo', 'Descripcion', 'Fecha', 'Precio', 'Metodo']
    ];

    for (var item in expenses) {
      aux = [
        item.article,
        'Gasto',
        item.description,
        convertDate(item.date),
        item.price.toString(),
        item.method
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
          '$dir/Gastos' + convertDatePath(expenses[0].date) + '.csv';

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

  String convertDate(String aux) {
    var newDateTimeObj = new DateFormat().add_yMd().parse(aux);
    return newDateTimeObj.day.toString() +
        '/' +
        newDateTimeObj.month.toString() +
        '/' +
        newDateTimeObj.year.toString();
  }
}
