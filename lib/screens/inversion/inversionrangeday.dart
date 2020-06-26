import 'package:flutter/material.dart';
import 'package:gastosapp/model/inversion.dart';
import 'package:gastosapp/screens/others/loadandviewcsvpage.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:gastosapp/screens/inversion/Inversiondetails.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class InversionRangeDay extends StatefulWidget {
  int count = 0;
  DateTime dateFrom;
  DateTime dateTo;
  InversionRangeDay(this.dateFrom, this.dateTo);
  @override
  State<StatefulWidget> createState() =>
      InversionRangeDayState(dateFrom, dateTo);
}

class InversionRangeDayState extends State {
  DbHelper helper = DbHelper();
  List<Inversion> inversions;
  int count = 0;
  DateTime dateTo;
  DateTime dateFrom;
  InversionRangeDayState(this.dateFrom, this.dateTo);

  @override
  Widget build(BuildContext context) {
    if (inversions == null) {
      inversions = List<Inversion>();
      getData();
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
          title: Text("Inversiones en fechas"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
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
      )
    ]);
  }

  ListView productListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.brown[100],
          margin: EdgeInsets.all(3),
          elevation: 2.0,
          child: ListTile(
              contentPadding: EdgeInsets.only(left: 5, right: 5),
              leading: Icon(
                Icons.score,
                color: getColor(this.inversions[position].article),
                size: 40,
              ),
              title: Text(this.inversions[position].article),
              subtitle: Text(this.inversions[position].description),
              trailing: Text('\$' + this.inversions[position].price.toString()),
              onTap: () {
                navigateToInversionDetail(this.inversions[position]);
              }),
        );
      },
    );
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final inversionsFuture = helper.getInversion();
      inversionsFuture.then((result) {
        List<Inversion> productList = List<Inversion>();
        count = result.length;
        int notInRange = 0;
        for (int i = 0; i < count; i++) {
          Inversion producAux = Inversion.fromObject(result[i]);
          if (comparedate(producAux.date)) {
            productList.add(producAux);
          } else {
            notInRange = notInRange + 1;
          }
        }
        setState(() {
          inversions = productList;
          count = count - notInRange;
        });
      });
    });
  }

  void navigateToInversionDetail(Inversion inversion) async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InversionDetail(inversion, inversion.date)));
    if (result == true) {
      getData();
    }
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

  Future<void> _generateCSVAndView(context) async {
    List<List<String>> csvData;
    List<String> aux;
    csvData = [
      ['Articulo', 'Tipo', 'Descripcion', 'Fecha', 'Precio']
    ];

    for (var item in inversions) {
      aux = [
        item.article,
        'Inversion',
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
      final String path = '$dir/Inversiones' +
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

  String stringToDateConvertCsv(DateTime aux) {
    return aux.day.toString() +
        '-' +
        aux.month.toString() +
        '-' +
        aux.year.toString();
  }
}
