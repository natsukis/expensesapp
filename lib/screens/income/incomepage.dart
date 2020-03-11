import 'package:flutter/material.dart';
import 'package:gastosapp/model/expense.dart';
import 'package:gastosapp/screens/income/incomedetails.dart';
import 'package:gastosapp/screens/others/loadandviewcsvpage.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class IncomePage extends StatefulWidget {
  final  String date;
  IncomePage(this.date);
  @override
  State<StatefulWidget> createState() => IncomePageState(date);
}

class IncomePageState extends State {
  DbHelper helper = DbHelper();
  List<Expense> expenses;
  int count = 0;
 String date;
 IncomePageState(this.date);

  @override
  Widget build(BuildContext context) {
    if (expenses == null) {
      expenses = List<Expense>();
      getData();
    }
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        title: Text(stringToDate(date)),
        backgroundColor: Colors.cyan,
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
          onPressed: (){
            navigateToDetail(Expense('Otro', 0, 'Expense', date, ''));
          }, 
          tooltip: "Agregar nuevo gasto", 
          child: new Icon(Icons.add)),
    );
  }

  ListView expenseListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.cyan[200],
          elevation: 2.0,
          child: ListTile(
              leading: CircleAvatar(
                  backgroundColor: getColor(this.expenses[position].article),
                  child: Text(this.expenses[position].article.substring(0, 1))),
               title: Text(this.expenses[position].article.toString() +
                  ': \$' +
                  this.expenses[position].price.toString()),
              subtitle: Text(this.expenses[position].description),
              onTap: () {
                debugPrint("Tapped on " + this.expenses[position].id.toString());
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
          if (producAux.type == "Income") {
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
    });
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
        
      case  "Otro":
        return Colors.grey;
        break;

        default:
        return Colors.grey;
    }
  }

  void navigateToDetail(Expense expense) async{
    bool result = await Navigator.push(context, 
    MaterialPageRoute(builder: (context) => IncomeDetail(expense,date)));
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
      ['Articulo', 'Tipo', 'Descripcion', 'Fecha', 'Precio']
    ];

    for (var item in expenses) {
      aux = [
        item.article,
        'Ingreso',
        item.description,
        convertDatePath(item.date),
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