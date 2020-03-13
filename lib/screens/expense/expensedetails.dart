import 'package:flutter/material.dart';
import 'package:gastosapp/model/expense.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';

DbHelper helper = new DbHelper();

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
    "Alquiler",
    "Celular",
    "Colectivo",
    "Compra",
    "Gastos comunes",
    "Impuesto",
    "Internet",  
    "Nafta",        
    "Otro",
    "Prestamo",
    "Regalo",
    "Salida",
    "Seguro",
    "Taxi",
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
          title: Text(expense.description == "" ? "Nuevo Gasto" : expense.description),          
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10),
          child: ListView(children: <Widget>[
            Column(
              children: <Widget>[
                 Padding(
                  padding:EdgeInsets.only(top: 20),
                  child:ListTile(
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
                ))),
                 Padding(
                  padding:EdgeInsets.only(top: 20, bottom:20),
                  child:TextField(
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

  void save() {
    expense.date = date;
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
