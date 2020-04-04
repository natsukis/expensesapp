import 'dart:ffi';

import 'package:gastosapp/model/inversion.dart';
import 'package:gastosapp/model/totalpermonth.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';

class Stadistics extends StatefulWidget {
  final TotalPerMonth tempTot;
  Stadistics(this.tempTot);
  @override
  State<StatefulWidget> createState() => StadisticsState(tempTot);
}

class StadisticsState extends State {
  TotalPerMonth tempTot;
  StadisticsState(this.tempTot);
  DbHelper helper = DbHelper();
  int countInversion = 0;
  int broker = 0;
  int plazo = 0;
  int fondo = 0;
  int cedears = 0;
  int futuros = 0;
  int acciones = 0;
  int bonos = 0;
  int otro = 0;

  bool toggle = false;
  Map<String, double> dataMap = Map();
  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.greenAccent,
    Colors.teal[50],
    Colors.cyan,
    Colors.grey,
    Colors.orange,
    Colors.pink,
    Colors.deepPurple,
    Colors.lightBlue
  ];

  Map<String, double> dataInversionMap = Map();
  List<Color> colorInversionList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.brown,
    Colors.orange,
    Colors.pink,
    Colors.cyan
  ];

  @override
  void initState() {
    super.initState();
    getDataInversion();
    dataMap.putIfAbsent("Enero: \$" + tempTot.january.toString(),
        () => tempTot.january.toDouble() > 0 ? tempTot.january.toDouble() : 0);
    dataMap.putIfAbsent(
        "Febrero: \$" + tempTot.february.toString(),
        () =>
            tempTot.february.toDouble() > 0 ? tempTot.february.toDouble() : 0);
    dataMap.putIfAbsent("Marzo: \$" + tempTot.march.toString(),
        () => tempTot.march.toDouble() > 0 ? tempTot.march.toDouble() : 0);
    dataMap.putIfAbsent("Abril: \$" + tempTot.april.toString(),
        () => tempTot.april.toDouble() > 0 ? tempTot.april.toDouble() : 0);
    dataMap.putIfAbsent("Mayo: \$" + tempTot.may.toString(),
        () => tempTot.may.toDouble() > 0 ? tempTot.may.toDouble() : 0);
    dataMap.putIfAbsent("Junio: \$" + tempTot.june.toString(),
        () => tempTot.june.toDouble() > 0 ? tempTot.june.toDouble() : 0);
    dataMap.putIfAbsent("Julio: \$" + tempTot.july.toString(),
        () => tempTot.july.toDouble() > 0 ? tempTot.july.toDouble() : 0);
    dataMap.putIfAbsent("Agosto: \$" + tempTot.august.toString(),
        () => tempTot.august.toDouble() > 0 ? tempTot.august.toDouble() : 0);
    dataMap.putIfAbsent(
        "Septiembre: \$" + tempTot.september.toString(),
        () => tempTot.september.toDouble() > 0
            ? tempTot.september.toDouble()
            : 0);
    dataMap.putIfAbsent("Octubre: \$" + tempTot.october.toString(),
        () => tempTot.october.toDouble() > 0 ? tempTot.october.toDouble() : 0);
    dataMap.putIfAbsent(
        "Noviembre: \$" + tempTot.november.toString(),
        () =>
            tempTot.november.toDouble() > 0 ? tempTot.november.toDouble() : 0);
    dataMap.putIfAbsent(
        "Diciembre: \$" + tempTot.december.toString(),
        () =>
            tempTot.december.toDouble() > 0 ? tempTot.december.toDouble() : 0);
  }

  @override
  Widget build(BuildContext context) {
    loadData();

    return Stack(children: <Widget>[
      Image.asset("images/stadistic.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          alignment: Alignment.center),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Estadisticas %"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Container(
                child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Center(
              child: Column(children: <Widget>[
            Container(
              child: toggle
                  ? Container(
                      decoration: BoxDecoration(
                          color: Colors.yellow[300],
                          border: Border.all(color: Colors.yellow),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Text(
                        "Resumen de ganancias",
                        style: TextStyle(color: Colors.black),
                      ))
                  : Text(""),
            ),
            Container(
                margin: EdgeInsets.all(0),
                child: Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: toggle
                        ? PieChart(
                            dataMap: dataMap,
                            animationDuration: Duration(milliseconds: 800),
                            chartLegendSpacing: 27.0,
                            legendStyle:
                                TextStyle(fontSize: 12, color: Colors.white),
                            chartRadius:
                                MediaQuery.of(context).size.width / 2.3,
                            showChartValuesInPercentage: true,
                            showChartValues: true,
                            showChartValuesOutside: true,
                            chartValueBackgroundColor: Colors.grey[200],
                            colorList: colorList,
                            showLegends: true,
                            legendPosition: LegendPosition.right,
                            decimalPlaces: 1,
                            showChartValueLabel: false,
                            initialAngle: 0,
                            chartValueStyle: defaultChartValueStyle.copyWith(
                                color: Colors.black.withOpacity(0.9),
                                fontSize: 10),
                            chartType: ChartType.disc,
                          )
                        : Text(
                            "Haga click para generar el grafico",
                            style: TextStyle(color: Colors.black),
                          ))),
            Container(
              child: toggle
                  ? Container(
                      decoration: BoxDecoration(
                          color: Colors.yellow[300],
                          border: Border.all(color: Colors.yellow),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Text("Cartera de inversiones",
                          style: TextStyle(color: Colors.black)),
                    )
                  : Text(""),
            ),
            Container(
                margin: EdgeInsets.all(0),
                child: Padding(
                    padding: EdgeInsets.only(top:20,left: 14),
                    child: toggle
                        ? PieChart(
                            dataMap: dataInversionMap,
                            animationDuration: Duration(milliseconds: 800),
                            chartLegendSpacing: 27.0,
                            legendStyle:
                                TextStyle(fontSize: 12, color: Colors.black),
                            chartRadius:
                                MediaQuery.of(context).size.width / 2.6,
                            showChartValuesInPercentage: true,
                            showChartValues: true,
                            showChartValuesOutside: true,
                            chartValueBackgroundColor: Colors.grey[200],
                            colorList: colorInversionList,
                            showLegends: true,
                            legendPosition: LegendPosition.right,
                            decimalPlaces: 1,
                            showChartValueLabel: false,
                            initialAngle: 0,
                            chartValueStyle: defaultChartValueStyle.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 10),
                            chartType: ChartType.ring,
                          )
                        : Text(""))),
          ])),
        ))),
        floatingActionButton: FloatingActionButton(
          onPressed: togglePieChart,
          backgroundColor: Colors.brown,
          child: Icon(Icons.insert_chart),
        ),
      )
    ]);
  }

  void togglePieChart() {
    setState(() {
      toggle = !toggle;
    });
  }

  void getDataInversion() async {
    final dbFuture = helper.initializeDb();
    int iBroker = 0;
    int iPlazo = 0;
    int iFondo = 0;
    int iCedears = 0;
    int iFuturos = 0;
    int iAcciones = 0;
    int iBonos = 0;
    int iOtro = 0;
    await dbFuture.then((result) async {
      final inversionFuture = helper.getInversion();
      await inversionFuture.then((result) {
        countInversion = result.length;
        for (int i = 0; i < countInversion; i++) {
          Inversion producAux = Inversion.fromObject(result[i]);

          switch (producAux.article) {
            case "Broker":
              iBroker = iBroker + producAux.price;
              break;
            case "Plazo Fijo":
              iPlazo = iPlazo + producAux.price;
              break;
            case "Fondo Comun de Inversion":
              iFondo = iFondo + producAux.price;
              break;
            case "Cedears":
              iCedears = iCedears + producAux.price;
              break;
            case "Futuros":
              iFuturos = iFuturos + producAux.price;
              break;
            case "Acciones":
              iAcciones = iAcciones + producAux.price;
              break;
            case "Otro":
              iOtro = iOtro + producAux.price;
              break;
            case "Bonos":
              iBonos = iBonos + producAux.price;
              break;
            default:
              iOtro = iOtro + producAux.price;
          }
        }
        if (mounted) {
          setState(() {
            broker = iBroker;
            plazo = iPlazo;
            fondo = iFondo;
            cedears = iCedears;
            futuros = iFuturos;
            acciones = iAcciones;
            bonos = iBonos;
            otro = iOtro;
          });
        }
      });
    });
  }

  void loadData() {
    //Inversion map
    if (broker > 0) {
      dataInversionMap.putIfAbsent(
          "Broker: \$" + broker.toString(), () => broker.toDouble());
    }
    if (plazo > 0) {
      dataInversionMap.putIfAbsent(
          "Plazo Fijo: \$" + plazo.toString(), () => plazo.toDouble());
    }
    if (fondo > 0) {
      dataInversionMap.putIfAbsent(
          "Fondo Inv.: \$" + fondo.toString(), () => fondo.toDouble());
    }
    if (cedears > 0) {
      dataInversionMap.putIfAbsent(
          "Cedears: \$" + cedears.toString(), () => cedears.toDouble());
    }
    if (futuros > 0) {
      dataInversionMap.putIfAbsent(
          "Futuros: \$" + futuros.toString(), () => futuros.toDouble());
    }
    if (acciones > 0) {
      dataInversionMap.putIfAbsent(
          "Acciones: \$" + acciones.toString(), () => acciones.toDouble());
    }
    if (bonos > 0) {
      dataInversionMap.putIfAbsent(
          "Bonos: \$" + bonos.toString(), () => bonos.toDouble());
    }
    if (otro > 0) {
      dataInversionMap.putIfAbsent(
          "Otro: \$" + otro.toString(), () => otro.toDouble());
    }
    if (dataInversionMap.isEmpty) {
      dataInversionMap.putIfAbsent("Sin Inversiones: \$0", () => 1);
    }
  }
}
