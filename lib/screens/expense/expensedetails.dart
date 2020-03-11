import 'package:flutter/material.dart';
import 'package:gastosapp/model/expense.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:intl/intl.dart';

DbHelper helper = new DbHelper();
final List<String> choices = const <String>[
  'Save Expense & Back',
  'Delete Expense Back',
  'Back to List'
];

const mnuSave = 'Save Todo & Back';
const mnuDelete = 'Delete Todo Back';
const mnuBack = 'Back to List';

class ExpenseDetail extends StatefulWidget {
  final Expense expense;
  final String date;
  ExpenseDetail(this.expense, this.date);

  @override
  State<StatefulWidget> createState() => ExpenseDetailState(expense,date);
}

class ExpenseDetailState extends State {
  Expense expense;
    final String date;
  ExpenseDetailState(this.expense,this.date);
  final _articles = [
    "Agua",
    "Luz",
    "Telefono",
    "Internet",
    "Celular",
    "Alquiler",
    "Nafta",
    "Seguro",
    "Gastos comunes",
    "Impuesto",
    "Otro"
  ];
  String _article = "Otro";
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    descriptionController.text = expense.description;
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      backgroundColor: Colors.cyan,
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          automaticallyImplyLeading: false,
          title: Text(expense.description),
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
                  value: expense.article,
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
                          labelText: "Precio",
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
        if (expense.id == null) {
          return;
        }
        result = await helper.deleteExpense(expense.id);
        if (result != 0) {
          Navigator.pop(context, true);
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete Todo"),
            content: Text("The Expense has been deleted"),
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
    expense.date = new DateFormat.yMd().format(DateTime.now());
    expense.type = 'Expense';
    if (expense.id != null) {
      helper.updateExpense(expense);
    } else {
      helper.insertExpense(expense);
    }
    Navigator.pop(context, true);
  }

    void updateArticle(String value) {
    expense.article = value;

    setState(() {
      _article = value;
    });
  }

  // void updateArticle(String value) {
  //   switch (value) {
  //     case "Agua":
  //       expense.article = 1;
  //       break;
  //     case "Luz":
  //       expense.article = 2;
  //       break;
  //     case "Telefono":
  //       expense.article = 3;
  //       break;

  //     case "Celular":
  //       expense.article = 4;
  //       break;

  //     case "Internet":
  //       expense.article = 5;
  //       break;

  //     case "Alquiler":
  //       expense.article = 6;
  //       break;

  //     case "Nafta":
  //       expense.article = 7;
  //       break;

  //     case "Seguro":
  //       expense.article = 8;
  //       break;

  //     case "Gastos comunes":
  //       expense.article = 9;
  //       break;

  //     case "Otro":
  //       expense.article = 10;
  //       break;
  //   }
  //   setState(() {
  //     _article = value;
  //   });
  // }

  String retrieveArticle(int value) {
    return _articles[value - 1];
  }

  void updatePrice() {
    expense.price = int.parse(priceController.text);
  }

  void updateDescription() {
    expense.description = descriptionController.text;
  }

  void navigate(int index) async {
    if (index == 0) {
      save();
    } else if (index == 1) {
      if (expense.id == null) {
        return;
      }
      int result = await helper.deleteExpense(expense.id);
      if (result != 0) {
        Navigator.pop(context, true);
        AlertDialog alertDialog = AlertDialog(
          title: Text("Borrado"),
          content: Text("El gasto fue borrado exitosamente."),
        );
        showDialog(context: context, builder: (_) => alertDialog);
      }
    } else {
      Navigator.pop(context, true);
    }
  }
}
