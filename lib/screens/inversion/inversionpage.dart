import 'package:flutter/material.dart';
import 'package:gastosapp/model/inversion.dart';
import 'package:gastosapp/screens/inversion/inversiondetails.dart';
import 'package:gastosapp/screens/others/loadandviewcsvpage.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class InversionPage extends StatefulWidget {
  final String date;
  InversionPage(this.date);
  @override
  State<StatefulWidget> createState() => InversionPageState(date);
}

class InversionPageState extends State {
  InversionPageState(this.date);
  DbHelper helper = DbHelper();
  List<Inversion> inversions;
  int count = 0;
  String date;
  @override
  Widget build(BuildContext context) {
    if (inversions == null) {
      inversions = List<Inversion>();
      getData();
    }
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        title: Text(stringToDate(date)),
        backgroundColor: Colors.brown,
        centerTitle: true,
        bottom: PreferredSize(
            child: Text('Total: \$' + calculateTotalSales(inversions, count),
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
      body: inversionListItems(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.brown,
          onPressed: () {
            navigateToDetail(Inversion('Otro', 0, date, ''));
          },
          tooltip: "Agregar nueva inversion",
          child: new Icon(Icons.add)),
    );
  }

  ListView inversionListItems() {
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
                Icons.score,
                color: getColor(this.inversions[position].article),
                size: 40,
              ),
              title: Text(this.inversions[position].article.toString()),
              subtitle: Text(this.inversions[position].description),
              trailing: Text("\$" + this.inversions[position].price.toString()),
              onTap: () {
                navigateToDetail(this.inversions[position]);
              }),
        );
      },
    );
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final productsFuture = helper.getInversion();
      productsFuture.then((result) {
        List<Inversion> productList = List<Inversion>();
        count = result.length;
        int notToday = 0;
        for (int i = 0; i < count; i++) {
          Inversion producAux = Inversion.fromObject(result[i]);
          if (producAux.date == date) {
            productList.add(producAux);
          } else {
            notToday = notToday + 1;
          }
        }
        setState(() {
          inversions = productList;
          count = count - notToday;
        });
      });
    });
  }

  Color getColor(String article) {
    switch (article) {
      case "Broker":
        return Colors.blue;
        break;
      case "Plazo Fijo":
        return Colors.yellow;
        break;
      case "Fondo Comun de Inversion":
        return Colors.green;
        break;

      case "Cedears":
        return Colors.lightGreen;
        break;

      case "Futuros":
        return Colors.brown;
        break;

      case "Acciones":
        return Colors.red;
        break;

      case "Bonos":
        return Colors.blueGrey;
        break;

      case "Otro":
        return Colors.grey;
        break;

      default:
        return Colors.grey;
    }
  }

  void navigateToDetail(Inversion inversion) async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InversionDetail(inversion, date)));
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

  String calculateTotalSales(List<Inversion> products, int count) {
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

    for (var item in inversions) {
      aux = [
        item.article,
        'Inversion',
        item.description,
        convertDate(item.date),
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
          '$dir/Inversiones' + convertDatePath(inversions[0].date) + '.csv';

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
