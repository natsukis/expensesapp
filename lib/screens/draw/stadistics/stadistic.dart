import 'package:gastosapp/model/totalpermonth.dart';
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

  bool toggle = false;
  Map<String, double> dataMap = Map();
  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.brown,
    Colors.black,
    Colors.cyan,
    Colors.grey,
    Colors.orange,
    Colors.pink,
    Colors.deepPurple,
    Colors.lightBlue
  ];

  @override
  void initState() {
    super.initState();
    dataMap.putIfAbsent("Enero: "+tempTot.january.toString(), () => tempTot.january.toDouble()>0?tempTot.january.toDouble():0);
    dataMap.putIfAbsent("Febrero: "+tempTot.february.toString(), () => tempTot.february.toDouble()>0?tempTot.february.toDouble():0);
    dataMap.putIfAbsent("Marzo: "+tempTot.march.toString(), () => tempTot.march.toDouble()>0?tempTot.march.toDouble():0);
    dataMap.putIfAbsent("Abril: "+tempTot.april.toString(), () => tempTot.april.toDouble()>0?tempTot.april.toDouble():0);
    dataMap.putIfAbsent("Mayo: "+tempTot.may.toString(), () => tempTot.may.toDouble()>0?tempTot.may.toDouble():0);
    dataMap.putIfAbsent("Junio: "+tempTot.june.toString(), () => tempTot.june.toDouble()>0?tempTot.june.toDouble():0);
    dataMap.putIfAbsent("Julio: "+tempTot.july.toString(), () => tempTot.july.toDouble()>0?tempTot.july.toDouble():0);
    dataMap.putIfAbsent("Agosto: "+tempTot.august.toString(), () => tempTot.august.toDouble()>0?tempTot.august.toDouble():0);
    dataMap.putIfAbsent("Septiembre: "+tempTot.september.toString(), () => tempTot.september.toDouble()>0?tempTot.september.toDouble():0);
    dataMap.putIfAbsent("Octubre: "+tempTot.october.toString(), () => tempTot.october.toDouble()>0?tempTot.october.toDouble():0);
    dataMap.putIfAbsent("Noviembre: "+tempTot.november.toString(), () => tempTot.november.toDouble()>0?tempTot.november.toDouble():0);
    dataMap.putIfAbsent("Diciembre: "+tempTot.december.toString(), () => tempTot.december.toDouble()>0?tempTot.december.toDouble():0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text("Ganancias %"),
      ),
      body: SingleChildScrollView(child:Container(
        child: Center(
          child: toggle
              ? PieChart(
                  dataMap: dataMap,
                  animationDuration: Duration(milliseconds: 800),
                  chartLegendSpacing: 37.0,
                  legendStyle: TextStyle(fontSize: 12, color: Colors.white),
                  chartRadius: MediaQuery.of(context).size.width / 2.3,
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
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 10
                  ),
                  chartType: ChartType.disc,
                )
              : Text("Haga click para generar el grafico"),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: togglePieChart,
        backgroundColor: Colors.brown,
        child: Icon(Icons.insert_chart),
      ),
    );
  }

  void togglePieChart() {
    setState(() {
      toggle = !toggle;
    });
  }
}
