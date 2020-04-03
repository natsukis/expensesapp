import 'package:flutter/material.dart';
import 'package:gastosapp/model/inversion.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:intl/intl.dart';

DbHelper helper = new DbHelper();

class InversionDetail extends StatefulWidget {
  final Inversion inversion;
  final String date;
  InversionDetail(this.inversion, this.date);

  @override
  State<StatefulWidget> createState() => InversionDetailState(inversion, date);
}

class InversionDetailState extends State {
  Inversion inversion;
  final String date;
  InversionDetailState(this.inversion, this.date);
  final _articles = [
    "Broker",
    "Plazo Fijo",
    "Fondo Comun de Inversion",
    "Cedears",
    "Futuros",
    "Acciones",
    "Bonos",
    "Otro"
  ];
  String _article = "Otro";
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    descriptionController.text = inversion.description;
    priceController.text = inversion.price.toString();
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
        backgroundColor: Colors.brown[200],
        appBar: AppBar(
          backgroundColor: Colors.brown,
          automaticallyImplyLeading: false,
          title: Text(inversion.description == ""
              ? "Nueva Inversion"
              : inversion.description + '. ' + stringToDate(inversion.date)),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10),
          child: ListView(children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: ListTile(
                        title: DropdownButton<String>(
                      items: _articles.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      style: textStyle,
                      value: inversion.article,
                      onChanged: (value) => updateArticle(value),
                    ))),
                Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: TextField(
                      controller: descriptionController,
                      style: textStyle,
                      onChanged: (value) => this.updateDescription(),
                      decoration: InputDecoration(
                          labelStyle: textStyle,
                          labelText: "Descripcion",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: priceController,
                      style: textStyle,
                      onChanged: (value) => this.updatePrice(),
                      decoration: InputDecoration(
                          labelStyle: textStyle,
                          labelText: "Saldo",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
              ],
            )
          ]),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.brown,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.save),
              title: Text('Guardar'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.delete),
              title: Text('Borrar'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_back),
              title: Text('Volver'),
            ),
          ],
          selectedItemColor: Colors.amber[800],
          onTap: navigate,
        ));
  }

  void save() {
    inversion.date = date;
    if (inversion.id != null) {
      helper.updateInversion(inversion);
    } else {
      helper.insertInversion(inversion);
    }
    Navigator.pop(context, true);
  }

  void updateArticle(String value) {
    inversion.article = value;

    setState(() {
      _article = value;
    });
  }

  String retrieveArticle(int value) {
    return _articles[value - 1];
  }

  void updatePrice() {
    inversion.price = int.parse(priceController.text);
  }

  void updateDescription() {
    inversion.description = descriptionController.text;
  }

  void navigate(int index) async {
    if (index == 0) {
      save();
    } else if (index == 1) {
      if (inversion.id == null) {
        return;
      }
      int result = await helper.deleteInversion(inversion.id);
      if (result != 0) {
        Navigator.pop(context, true);
        AlertDialog alertDialog = AlertDialog(
          title: Text("Borrado"),
          content: Text("La inversion fue borrada exitosamente."),
        );
        showDialog(context: context, builder: (_) => alertDialog);
      }
    } else {
      Navigator.pop(context, true);
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
}
