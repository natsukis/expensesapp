import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(
            "Bienvenidos a la app de gastos personales creada para poder tener un control de los gastos de la vida cotidiana, saldos de tarjeta, planeamiento y demas cosas escenciales." +
                "\n" +
                "Espero que la disfruten. Hecha por un Rosarino para el mundo. \n" +
                "Saludos, Natsuki."),
      ),
    );
  }
}
