import 'package:flutter/material.dart';
import 'package:gastosapp/model/expense.dart';
import 'package:gastosapp/model/totalpermonth.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:intl/intl.dart';

DbHelper helper = new DbHelper();

class IncomeDetail extends StatefulWidget {
  final Expense expense;
  final String date;
  final TotalPerMonth tempTot;
  IncomeDetail(this.expense, this.date, this.tempTot);

  @override
  State<StatefulWidget> createState() =>
      IncomeDetailState(expense, date, tempTot);
}

class IncomeDetailState extends State {
  Expense expense;
  final String date;
  IncomeDetailState(this.expense, this.date, this.tempTot);
  final _articles = [
    "Ganancias",
    "Inversion",
    "Otro",
    "Prestamo",
    "Sueldo",
    "Venta",
  ];
  String _article = "Otro";
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TotalPerMonth tempTot;

  @override
  Widget build(BuildContext context) {
    descriptionController.text = expense.description;
    priceController.text = expense.price.toString();
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
        backgroundColor: Colors.brown[200],
        appBar: AppBar(
          backgroundColor: Colors.brown,
          automaticallyImplyLeading: false,
          title: Text(expense.description == ""
              ? "Nuevo Ingreso"
              : expense.description + '. ' + stringToDate(expense.date)),
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
                      value: expense.article,
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
    //Save in totalmonth table
    var tempDate = new DateFormat().add_yMd().parse(date);
    tempTot = updateMonth(tempTot, tempDate.month, expense.price);
    helper.updateTotal(tempTot);

    ///
    expense.date = date;
    expense.type = 'Income';
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
      //Delete in totalmonth table
      var tempDate = new DateFormat().add_yMd().parse(date);
      tempTot = updateDeleteMonth(tempTot, tempDate.month, expense.price);
      helper.updateTotal(tempTot);

      ///
      if (result != 0) {
        Navigator.pop(context, true);
        AlertDialog alertDialog = AlertDialog(
          title: Text("Borrado"),
          content: Text("El ingreso fue borrado exitosamente."),
        );
        showDialog(context: context, builder: (_) => alertDialog);
      }
    } else {
      Navigator.pop(context, true);
    }
  }

  TotalPerMonth updateMonth(TotalPerMonth totalToUpdate, int month, int value) {
    switch (month) {
      case 1:
        totalToUpdate.january = totalToUpdate.january + value;
        break;
      case 2:
        totalToUpdate.february = totalToUpdate.february + value;
        break;
      case 3:
        totalToUpdate.march = totalToUpdate.march + value;
        break;
      case 4:
        totalToUpdate.april = totalToUpdate.april + value;
        break;
      case 5:
        totalToUpdate.may = totalToUpdate.may + value;
        break;
      case 6:
        totalToUpdate.june = totalToUpdate.june + value;
        break;
      case 7:
        totalToUpdate.july = totalToUpdate.july + value;
        break;
      case 8:
        totalToUpdate.august = totalToUpdate.august + value;
        break;
      case 9:
        totalToUpdate.september = totalToUpdate.september + value;
        break;
      case 10:
        totalToUpdate.october = totalToUpdate.october + value;
        break;
      case 11:
        totalToUpdate.november = totalToUpdate.november + value;
        break;
      case 12:
        totalToUpdate.december = totalToUpdate.december + value;
        break;
    }
    return totalToUpdate;
  }

  TotalPerMonth updateDeleteMonth(
      TotalPerMonth totalToUpdate, int month, int value) {
    switch (month) {
      case 1:
        totalToUpdate.january = totalToUpdate.january - value;
        break;
      case 2:
        totalToUpdate.february = totalToUpdate.february - value;
        break;
      case 3:
        totalToUpdate.march = totalToUpdate.march - value;
        break;
      case 4:
        totalToUpdate.april = totalToUpdate.april - value;
        break;
      case 5:
        totalToUpdate.may = totalToUpdate.may - value;
        break;
      case 6:
        totalToUpdate.june = totalToUpdate.june - value;
        break;
      case 7:
        totalToUpdate.july = totalToUpdate.july - value;
        break;
      case 8:
        totalToUpdate.august = totalToUpdate.august - value;
        break;
      case 9:
        totalToUpdate.september = totalToUpdate.september - value;
        break;
      case 10:
        totalToUpdate.october = totalToUpdate.october - value;
        break;
      case 11:
        totalToUpdate.november = totalToUpdate.november - value;
        break;
      case 12:
        totalToUpdate.december = totalToUpdate.december - value;
        break;
    }
    return totalToUpdate;
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
