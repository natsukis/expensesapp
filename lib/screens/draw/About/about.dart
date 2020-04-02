import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Image.asset("images/about.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          alignment: Alignment.center),
      Scaffold(
        appBar: AppBar(
          title: Text("Informacion"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
              child: Padding(padding: EdgeInsets.only(top:250, left: 5, right: 5),child:Center(
        child: Container(
          child: Text(
              "Bienvenidos a la app de gastos personales creada para poder tener un control de los gastos de la vida cotidiana, saldos de tarjeta, planeamiento y demas cosas escenciales." +
                  "\n" +
                  "Espero que la disfruten. Hecha desde Rosario para el mundo. \n" +
                  "Saludos, Natsuki."),
        ),
      ))))
    ]);
  }
}
