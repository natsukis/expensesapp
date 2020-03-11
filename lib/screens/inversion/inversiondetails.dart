import 'package:flutter/material.dart';
import 'package:gastosapp/model/inversion.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:intl/intl.dart';

DbHelper helper = new DbHelper();
final List<String> choices = const <String>[
  'Save inversion & Back',
  'Delete inversion Back',
  'Back to List'
];

const mnuSave = 'Save Todo & Back';
const mnuDelete = 'Delete Todo Back';
const mnuBack = 'Back to List';

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
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      backgroundColor: Colors.cyan,
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          automaticallyImplyLeading: false,
          title: Text(inversion.description),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: select,
              itemBuilder: (BuildContext context) {
                return choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10),
          child: ListView(children: <Widget>[
            Column(
              children: <Widget>[
                ListTile(
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
                )),
                TextField(
                  controller: descriptionController,
                  style: textStyle,
                  onChanged: (value) => this.updateDescription(),
                  decoration: InputDecoration(
                      labelStyle: textStyle,
                      labelText: "Descripcion",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
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

  void select(String value) async {
    int result;
    switch (value) {
      case mnuSave:
        save();
        break;
      case mnuDelete:
        if (inversion.id == null) {
          return;
        }
        result = await helper.deleteInversion(inversion.id);
        if (result != 0) {
          Navigator.pop(context, true);
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete Todo"),
            content: Text("The inversion has been deleted"),
          );
          showDialog(context: context, builder: (_) => alertDialog);
        }
        break;
      case mnuBack:
        Navigator.pop(context, true);
        break;
    }
  }

  void save() {
    inversion.date = new DateFormat.yMd().format(DateTime.now());
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
}
