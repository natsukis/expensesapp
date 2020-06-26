import 'package:flutter/material.dart';
import 'package:gastosapp/model/expense.dart';
import 'package:gastosapp/model/totalpermonth.dart';
import 'package:gastosapp/util/dbhelper.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';

DbHelper helper = new DbHelper();

class ExpenseDetail extends StatefulWidget {
  final Expense expense;
  final String date;
  final TotalPerMonth tempTot;
  final TotalPerMonth totalNextYear;
  ExpenseDetail(this.expense, this.date, this.tempTot, this.totalNextYear);

  @override
  State<StatefulWidget> createState() =>
      ExpenseDetailState(expense, date, tempTot, totalNextYear);
}

class ExpenseDetailState extends State {
  Expense expense;
  final String date;
  ExpenseDetailState(this.expense, this.date, this.tempTot, this.totalNextYear);
  int oldExpense = 0;
  final _articles = [
    "Alquiler",
    "Celular",
    "Colectivo",
    "Compra",
    "Gastos comunes",
    "Hospedaje",
    "Impuesto",
    "Internet",
    "Nafta",
    "Otro",
    "Prestamo",
    "Regalo",
    "Salida",
    "Seguro",
    "Supermercado",
    "Tarjeta",
    "Taxi",
    "Viaje",
  ];
  String _article = "Otro";
  final _methods = [
    "Efectivo",
    "Tarjeta 1c",
    "Tarjeta 3c",
    "Tarjeta 6c",
    "Tarjeta 12c",
    "Debito"
  ];
  String _method = "Efectivo";
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TotalPerMonth tempTot;
  TotalPerMonth totalNextYear;
  @override
  Widget build(BuildContext context) {
    if (expense.id != null && oldExpense == 0) {
      oldExpense = expense.price;
    }
    descriptionController.text = expense.description;
    priceController.text = expense.price.toString();
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Stack(children: <Widget>[
      Image.asset("images/total.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          alignment: Alignment.center),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: Text(expense.description == ""
                ? "Nuevo Gasto"
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
                            labelText: "Precio",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  ListTile(
                      title: DropdownButton<String>(
                    items: _methods.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    style: textStyle,
                    value: expense.method,
                    onChanged: (value) => updateMethod(value),
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
          ))
    ]);
  }

  void save() async {
    expense.date = date;
    expense.type = 'Expense';

    //Save in totalmonth table
    var tempDate = new DateFormat().add_yMd().parse(date);
    switch (expense.method) {
      case "Tarjeta 3c":
        if (expense.id != null) {
          tempTot = updateMonth(tempTot, tempDate.month, expense.price);
          helper.updateExpense(expense);
          helper.updateTotal(tempTot);
        } else {
          tempTot = update3Month(tempTot, tempDate.month, expense.price);
          helper.updateTotal(tempTot);
          helper.updateTotal(totalNextYear);
          var tempPrice = expense.price / 3;
          expense.price = tempPrice.toInt();
          String auxDescription = expense.description;
          expense.description = auxDescription + ": Cuot 1/3";
          await helper.insertExpense(expense);
          expense.date = tarjetDate(expense.date);
          expense.description = auxDescription + ": Cuot 2/3";
          await helper.insertExpense(expense);
          expense.date = tarjetDate(expense.date);
          expense.description = auxDescription + ": Cuot 3/3";
          await helper.insertExpense(expense);
        }
        break;
      case "Tarjeta 6c":
        if (expense.id != null) {
          tempTot = updateMonth(tempTot, tempDate.month, expense.price);
          helper.updateExpense(expense);
          helper.updateTotal(tempTot);
        } else {
          tempTot = update6Month(tempTot, tempDate.month, expense.price);
          helper.updateTotal(tempTot);
          helper.updateTotal(totalNextYear);
          var tempPrice = expense.price / 6;
          expense.price = tempPrice.toInt();
          String auxDescription = expense.description;
          expense.description = auxDescription + ": Cuot 1/6";
          await helper.insertExpense(expense);
          expense.date = tarjetDate(expense.date);
          expense.description = auxDescription + ": Cuot 2/6";
          await helper.insertExpense(expense);
          expense.date = tarjetDate(expense.date);
          expense.description = auxDescription + ": Cuot 3/6";
          await helper.insertExpense(expense);
          expense.date = tarjetDate(expense.date);
          expense.description = auxDescription + ": Cuot 4/6";
          await helper.insertExpense(expense);
          expense.date = tarjetDate(expense.date);
          expense.description = auxDescription + ": Cuot 5/6";
          await helper.insertExpense(expense);
          expense.date = tarjetDate(expense.date);
          expense.description = auxDescription + ": Cuot 6/6";
          await helper.insertExpense(expense);
        }
        break;
      case "Tarjeta 12c":
        if (expense.id != null) {
          tempTot = updateMonth(tempTot, tempDate.month, expense.price);
          helper.updateExpense(expense);
          helper.updateTotal(tempTot);
        } else {
          tempTot = update12Month(tempTot, tempDate.month, expense.price);
          helper.updateTotal(tempTot);
          helper.updateTotal(totalNextYear);
          var tempPrice = expense.price / 12;
          expense.price = tempPrice.toInt();
          String auxDescription = expense.description;
          expense.description = auxDescription + ": Cuot 1/12";
          await helper.insertExpense(expense);
          expense.date = tarjetDate(expense.date);
          expense.description = auxDescription + ": Cuot 2/12";
          await helper.insertExpense(expense);
          expense.date = tarjetDate(expense.date);
          expense.description = auxDescription + ": Cuot 3/12";
          await helper.insertExpense(expense);
          expense.date = tarjetDate(expense.date);
          expense.description = auxDescription + ": Cuot 4/12";
          await helper.insertExpense(expense);
          expense.date = tarjetDate(expense.date);
          expense.description = auxDescription + ": Cuot 5/12";
          await helper.insertExpense(expense);
          expense.date = tarjetDate(expense.date);
          expense.description = auxDescription + ": Cuot 6/12";
          await helper.insertExpense(expense);
          expense.date = tarjetDate(expense.date);
          expense.description = auxDescription + ": Cuot 7/12";
          await helper.insertExpense(expense);
          expense.date = tarjetDate(expense.date);
          expense.description = auxDescription + ": Cuot 8/12";
          await helper.insertExpense(expense);
          expense.date = tarjetDate(expense.date);
          expense.description = auxDescription + ": Cuot 9/12";
          await helper.insertExpense(expense);
          expense.date = tarjetDate(expense.date);
          expense.description = auxDescription + ": Cuot 10/12";
          await helper.insertExpense(expense);
          expense.date = tarjetDate(expense.date);
          expense.description = auxDescription + ": Cuot 11/12";
          await helper.insertExpense(expense);
          expense.date = tarjetDate(expense.date);
          expense.description = auxDescription + ": Cuot 12/12";
          await helper.insertExpense(expense);
        }
        break;
      default:
        tempTot = updateMonth(tempTot, tempDate.month, expense.price);
        helper.updateTotal(tempTot);
        if (expense.id != null) {
          helper.updateExpense(expense);
        } else {
          helper.insertExpense(expense);
        }
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

  void updateMethod(String value) {
    expense.method = value;

    setState(() {
      _method = value;
    });
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
          content: Text("El gasto fue borrado exitosamente."),
        );
        showDialog(context: context, builder: (_) => alertDialog);
      }
    } else {
      Navigator.pop(context, true);
    }
  }

  String tarjetDate(String dateToConvert) {
    var newDateTimeObj = new DateFormat().add_yMd().parse(dateToConvert);
    if (newDateTimeObj.month < 12) {
      return (newDateTimeObj.month + 1).toString() +
          '/' +
          newDateTimeObj.day.toString() +
          '/' +
          newDateTimeObj.year.toString();
    } else {
      return "1" +
          '/' +
          newDateTimeObj.day.toString() +
          '/' +
          (newDateTimeObj.year + 1).toString();
    }
  }

  TotalPerMonth updateMonth(TotalPerMonth totalToUpdate, int month, int value) {
    switch (month) {
      case 1:
        if (oldExpense > 0) {
          totalToUpdate.january = totalToUpdate.january + oldExpense;
        }
        totalToUpdate.january = totalToUpdate.january - value;
        break;
      case 2:
        if (oldExpense > 0) {
          totalToUpdate.february = totalToUpdate.february + oldExpense;
        }
        totalToUpdate.february = totalToUpdate.february - value;
        break;
      case 3:
        if (oldExpense > 0) {
          totalToUpdate.march = totalToUpdate.march + oldExpense;
        }
        totalToUpdate.march = totalToUpdate.march - value;
        break;
      case 4:
        if (oldExpense > 0) {
          totalToUpdate.april = totalToUpdate.april + oldExpense;
        }
        totalToUpdate.april = totalToUpdate.april - value;
        break;
      case 5:
        if (oldExpense > 0) {
          totalToUpdate.may = totalToUpdate.may + oldExpense;
        }
        totalToUpdate.may = totalToUpdate.may - value;
        break;
      case 6:
        if (oldExpense > 0) {
          totalToUpdate.june = totalToUpdate.june + oldExpense;
        }
        totalToUpdate.june = totalToUpdate.june - value;
        break;
      case 7:
        if (oldExpense > 0) {
          totalToUpdate.july = totalToUpdate.july + oldExpense;
        }
        totalToUpdate.july = totalToUpdate.july - value;
        break;
      case 8:
        if (oldExpense > 0) {
          totalToUpdate.august = totalToUpdate.august + oldExpense;
        }
        totalToUpdate.august = totalToUpdate.august - value;
        break;
      case 9:
        if (oldExpense > 0) {
          totalToUpdate.september = totalToUpdate.september + oldExpense;
        }
        totalToUpdate.september = totalToUpdate.september - value;
        break;
      case 10:
        if (oldExpense > 0) {
          totalToUpdate.october = totalToUpdate.october + oldExpense;
        }
        totalToUpdate.october = totalToUpdate.october - value;
        break;
      case 11:
        if (oldExpense > 0) {
          totalToUpdate.november = totalToUpdate.november + oldExpense;
        }
        totalToUpdate.november = totalToUpdate.november - value;
        break;
      case 12:
        if (oldExpense > 0) {
          totalToUpdate.december = totalToUpdate.december + oldExpense;
        }
        totalToUpdate.december = totalToUpdate.december - value;
        break;
    }
    return totalToUpdate;
  }

  TotalPerMonth update3Month(
      TotalPerMonth totalToUpdate, int month, int value) {
    var y = (value / 3);
    var x = y.toInt();
    switch (month) {
      case 1:
        totalToUpdate.january = totalToUpdate.january - x;
        totalToUpdate.february = (totalToUpdate.february - x);
        totalToUpdate.march = (totalToUpdate.march - x);
        break;
      case 2:
        totalToUpdate.february = (totalToUpdate.february - (x));
        totalToUpdate.march = (totalToUpdate.march - (x));
        totalToUpdate.april = (totalToUpdate.april - (x));
        break;
      case 3:
        totalToUpdate.march = (totalToUpdate.march - (x));
        totalToUpdate.april = (totalToUpdate.april - (x));
        totalToUpdate.may = (totalToUpdate.may - (x));
        break;
      case 4:
        totalToUpdate.april = (totalToUpdate.april - (x));
        totalToUpdate.may = (totalToUpdate.may - (x));
        totalToUpdate.june = (totalToUpdate.june - (x));
        break;
      case 5:
        totalToUpdate.may = (totalToUpdate.may - (x));
        totalToUpdate.june = (totalToUpdate.june - (x));
        totalToUpdate.july = (totalToUpdate.july - (x));
        break;
      case 6:
        totalToUpdate.june = (totalToUpdate.june - (x));
        totalToUpdate.july = (totalToUpdate.july - (x));
        totalToUpdate.august = (totalToUpdate.august - (x));
        break;
      case 7:
        totalToUpdate.july = (totalToUpdate.july - (x));
        totalToUpdate.august = (totalToUpdate.august - (x));
        totalToUpdate.september = (totalToUpdate.september - (x));
        break;
      case 8:
        totalToUpdate.august = (totalToUpdate.august - (x));
        totalToUpdate.september = (totalToUpdate.september - (x));
        totalToUpdate.october = (totalToUpdate.october - (x));
        break;
      case 9:
        totalToUpdate.september = (totalToUpdate.september - (x));
        totalToUpdate.october = (totalToUpdate.october - (x));
        totalToUpdate.november = (totalToUpdate.november - (x));
        break;
      case 10:
        totalToUpdate.october = (totalToUpdate.october - (x));
        totalToUpdate.november = (totalToUpdate.november - (x));
        totalToUpdate.december = (totalToUpdate.december - (x));
        break;
      case 11:
        totalToUpdate.november = (totalToUpdate.november - (x));
        totalToUpdate.december = (totalToUpdate.december - (x));
        totalNextYear.january = (totalNextYear.january - (x));
        break;
      case 12:
        totalToUpdate.december = (totalToUpdate.december - (x));
        totalNextYear.january = (totalNextYear.january - (x));
        totalNextYear.february = (totalNextYear.february - (x));
        break;
    }
    return totalToUpdate;
  }

  TotalPerMonth update6Month(
      TotalPerMonth totalToUpdate, int month, int valuex) {
    var x = (valuex / 6);
    int value = x.toInt();

    switch (month) {
      case 1:
        totalToUpdate.january = totalToUpdate.january - value;
        totalToUpdate.february = totalToUpdate.february - value;
        totalToUpdate.march = totalToUpdate.march - value;
        totalToUpdate.april = totalToUpdate.april - value;
        totalToUpdate.may = totalToUpdate.may - value;
        totalToUpdate.june = totalToUpdate.june - value;
        break;
      case 2:
        totalToUpdate.february = totalToUpdate.february - value;
        totalToUpdate.march = totalToUpdate.march - value;
        totalToUpdate.april = totalToUpdate.april - value;
        totalToUpdate.may = totalToUpdate.may - value;
        totalToUpdate.june = totalToUpdate.june - value;
        totalToUpdate.july = totalToUpdate.july - value;
        break;
      case 3:
        totalToUpdate.march = totalToUpdate.march - value;
        totalToUpdate.april = totalToUpdate.april - value;
        totalToUpdate.may = totalToUpdate.may - value;
        totalToUpdate.june = totalToUpdate.june - value;
        totalToUpdate.july = totalToUpdate.july - value;
        totalToUpdate.august = totalToUpdate.august - value;
        break;
      case 4:
        totalToUpdate.april = totalToUpdate.april - value;
        totalToUpdate.may = totalToUpdate.may - value;
        totalToUpdate.june = totalToUpdate.june - value;
        totalToUpdate.july = totalToUpdate.july - value;
        totalToUpdate.august = totalToUpdate.august - value;
        totalToUpdate.september = totalToUpdate.september - value;
        break;
      case 5:
        totalToUpdate.may = totalToUpdate.may - value;
        totalToUpdate.june = totalToUpdate.june - value;
        totalToUpdate.july = totalToUpdate.july - value;
        totalToUpdate.august = totalToUpdate.august - value;
        totalToUpdate.september = totalToUpdate.september - value;
        totalToUpdate.october = totalToUpdate.october - value;
        break;
      case 6:
        totalToUpdate.june = totalToUpdate.june - value;
        totalToUpdate.july = totalToUpdate.july - value;
        totalToUpdate.august = totalToUpdate.august - value;
        totalToUpdate.september = totalToUpdate.september - value;
        totalToUpdate.october = totalToUpdate.october - value;
        totalToUpdate.november = totalToUpdate.november - value;
        break;
      case 7:
        totalToUpdate.july = totalToUpdate.july - value;
        totalToUpdate.august = totalToUpdate.august - value;
        totalToUpdate.september = totalToUpdate.september - value;
        totalToUpdate.october = totalToUpdate.october - value;
        totalToUpdate.november = totalToUpdate.november - value;
        totalToUpdate.december = totalToUpdate.december - value;
        break;
      case 8:
        totalToUpdate.august = totalToUpdate.august - value;
        totalToUpdate.september = totalToUpdate.september - value;
        totalToUpdate.october = totalToUpdate.october - value;
        totalToUpdate.november = totalToUpdate.november - value;
        totalToUpdate.december = totalToUpdate.december - value;
        totalNextYear.january = totalNextYear.january - value;
        break;
      case 9:
        totalToUpdate.september = totalToUpdate.september - value;
        totalToUpdate.october = totalToUpdate.october - value;
        totalToUpdate.november = totalToUpdate.november - value;
        totalToUpdate.december = totalToUpdate.december - value;
        totalNextYear.january = totalNextYear.january - value;
        totalNextYear.february = totalNextYear.february - value;
        break;
      case 10:
        totalToUpdate.october = totalToUpdate.october - value;
        totalToUpdate.november = totalToUpdate.november - value;
        totalToUpdate.december = totalToUpdate.december - value;
        totalNextYear.january = totalNextYear.january - value;
        totalNextYear.february = totalNextYear.february - value;
        totalNextYear.march = totalNextYear.march - value;
        break;
      case 11:
        totalToUpdate.november = totalToUpdate.november - value;
        totalToUpdate.december = totalToUpdate.december - value;
        totalNextYear.january = totalNextYear.january - value;
        totalNextYear.february = totalNextYear.february - value;
        totalNextYear.march = totalNextYear.march - value;
        totalNextYear.april = totalNextYear.april - value;
        break;
      case 12:
        totalToUpdate.december = totalToUpdate.december - value;
        totalNextYear.january = totalNextYear.january - value;
        totalNextYear.february = totalNextYear.february - value;
        totalNextYear.march = totalNextYear.march - value;
        totalNextYear.april = totalNextYear.april - value;
        totalNextYear.may = totalNextYear.may - value;
        break;
    }
    return totalToUpdate;
  }

  TotalPerMonth update12Month(
      TotalPerMonth totalToUpdate, int month, int valuex) {
    var x = (valuex / 12);
    int value = x.toInt();
    switch (month) {
      case 1:
        totalToUpdate.january = totalToUpdate.january - value;
        totalToUpdate.february = totalToUpdate.february - value;
        totalToUpdate.march = totalToUpdate.march - value;
        totalToUpdate.april = totalToUpdate.april - value;
        totalToUpdate.may = totalToUpdate.may - value;
        totalToUpdate.june = totalToUpdate.june - value;
        totalToUpdate.july = totalToUpdate.july - value;
        totalToUpdate.august = totalToUpdate.august - value;
        totalToUpdate.september = totalToUpdate.september - value;
        totalToUpdate.october = totalToUpdate.october - value;
        totalToUpdate.november = totalToUpdate.november - value;
        totalToUpdate.december = totalToUpdate.december - value;
        break;
      case 2:
        totalToUpdate.february = totalToUpdate.february - value;
        totalToUpdate.march = totalToUpdate.march - value;
        totalToUpdate.april = totalToUpdate.april - value;
        totalToUpdate.may = totalToUpdate.may - value;
        totalToUpdate.june = totalToUpdate.june - value;
        totalToUpdate.july = totalToUpdate.july - value;
        totalToUpdate.august = totalToUpdate.august - value;
        totalToUpdate.september = totalToUpdate.september - value;
        totalToUpdate.october = totalToUpdate.october - value;
        totalToUpdate.november = totalToUpdate.november - value;
        totalToUpdate.december = totalToUpdate.december - value;
        totalNextYear.january = totalNextYear.january - value;

        break;
      case 3:
        totalToUpdate.march = totalToUpdate.march - value;
        totalToUpdate.april = totalToUpdate.april - value;
        totalToUpdate.may = totalToUpdate.may - value;
        totalToUpdate.june = totalToUpdate.june - value;
        totalToUpdate.july = totalToUpdate.july - value;
        totalToUpdate.august = totalToUpdate.august - value;
        totalToUpdate.september = totalToUpdate.september - value;
        totalToUpdate.october = totalToUpdate.october - value;
        totalToUpdate.november = totalToUpdate.november - value;
        totalToUpdate.december = totalToUpdate.december - value;
        totalNextYear.january = totalNextYear.january - value;
        totalNextYear.february = totalNextYear.february - value;
        break;
      case 4:
        totalToUpdate.april = totalToUpdate.april - value;
        totalToUpdate.may = totalToUpdate.may - value;
        totalToUpdate.june = totalToUpdate.june - value;
        totalToUpdate.july = totalToUpdate.july - value;
        totalToUpdate.august = totalToUpdate.august - value;
        totalToUpdate.september = totalToUpdate.september - value;
        totalToUpdate.october = totalToUpdate.october - value;
        totalToUpdate.november = totalToUpdate.november - value;
        totalToUpdate.december = totalToUpdate.december - value;
        totalNextYear.january = totalNextYear.january - value;
        totalNextYear.february = totalNextYear.february - value;
        totalNextYear.march = totalNextYear.march - value;
        break;
      case 5:
        totalToUpdate.may = totalToUpdate.may - value;
        totalToUpdate.june = totalToUpdate.june - value;
        totalToUpdate.july = totalToUpdate.july - value;
        totalToUpdate.august = totalToUpdate.august - value;
        totalToUpdate.september = totalToUpdate.september - value;
        totalToUpdate.october = totalToUpdate.october - value;
        totalToUpdate.november = totalToUpdate.november - value;
        totalToUpdate.december = totalToUpdate.december - value;
        totalNextYear.january = totalNextYear.january - value;
        totalNextYear.february = totalNextYear.february - value;
        totalNextYear.march = totalNextYear.march - value;
        totalNextYear.april = totalNextYear.april - value;
        break;
      case 6:
        totalToUpdate.june = totalToUpdate.june - value;
        totalToUpdate.july = totalToUpdate.july - value;
        totalToUpdate.august = totalToUpdate.august - value;
        totalToUpdate.september = totalToUpdate.september - value;
        totalToUpdate.october = totalToUpdate.october - value;
        totalToUpdate.november = totalToUpdate.november - value;
        totalToUpdate.december = totalToUpdate.december - value;
        totalNextYear.january = totalNextYear.january - value;
        totalNextYear.february = totalNextYear.february - value;
        totalNextYear.march = totalNextYear.march - value;
        totalNextYear.april = totalNextYear.april - value;
        totalNextYear.may = totalNextYear.may - value;
        break;
      case 7:
        totalToUpdate.july = totalToUpdate.july - value;
        totalToUpdate.august = totalToUpdate.august - value;
        totalToUpdate.september = totalToUpdate.september - value;
        totalToUpdate.october = totalToUpdate.october - value;
        totalToUpdate.november = totalToUpdate.november - value;
        totalToUpdate.december = totalToUpdate.december - value;
        totalNextYear.january = totalNextYear.january - value;
        totalNextYear.february = totalNextYear.february - value;
        totalNextYear.march = totalNextYear.march - value;
        totalNextYear.april = totalNextYear.april - value;
        totalNextYear.may = totalNextYear.may - value;
        totalNextYear.june = totalNextYear.june - value;
        break;
      case 8:
        totalToUpdate.august = totalToUpdate.august - value;
        totalToUpdate.september = totalToUpdate.september - value;
        totalToUpdate.october = totalToUpdate.october - value;
        totalToUpdate.november = totalToUpdate.november - value;
        totalToUpdate.december = totalToUpdate.december - value;
        totalNextYear.january = totalNextYear.january - value;
        totalNextYear.february = totalNextYear.february - value;
        totalNextYear.march = totalNextYear.march - value;
        totalNextYear.april = totalNextYear.april - value;
        totalNextYear.may = totalNextYear.may - value;
        totalNextYear.june = totalNextYear.june - value;
        totalNextYear.july = totalNextYear.july - value;
        break;
      case 9:
        totalToUpdate.september = totalToUpdate.september - value;
        totalToUpdate.october = totalToUpdate.october - value;
        totalToUpdate.november = totalToUpdate.november - value;
        totalToUpdate.december = totalToUpdate.december - value;
        totalNextYear.january = totalNextYear.january - value;
        totalNextYear.february = totalNextYear.february - value;
        totalNextYear.march = totalNextYear.march - value;
        totalNextYear.april = totalNextYear.april - value;
        totalNextYear.may = totalNextYear.may - value;
        totalNextYear.june = totalNextYear.june - value;
        totalNextYear.july = totalNextYear.july - value;
        totalNextYear.august = totalNextYear.august - value;
        break;
      case 10:
        totalToUpdate.october = totalToUpdate.october - value;
        totalToUpdate.november = totalToUpdate.november - value;
        totalToUpdate.december = totalToUpdate.december - value;
        totalNextYear.january = totalNextYear.january - value;
        totalNextYear.february = totalNextYear.february - value;
        totalNextYear.march = totalNextYear.march - value;
        totalNextYear.april = totalNextYear.april - value;
        totalNextYear.may = totalNextYear.may - value;
        totalNextYear.june = totalNextYear.june - value;
        totalNextYear.july = totalNextYear.july - value;
        totalNextYear.august = totalNextYear.august - value;
        totalNextYear.september = totalNextYear.september - value;
        break;
      case 11:
        totalToUpdate.november = totalToUpdate.november - value;
        totalToUpdate.december = totalToUpdate.december - value;
        totalNextYear.january = totalNextYear.january - value;
        totalNextYear.february = totalNextYear.february - value;
        totalNextYear.march = totalNextYear.march - value;
        totalNextYear.april = totalNextYear.april - value;
        totalNextYear.may = totalNextYear.may - value;
        totalNextYear.june = totalNextYear.june - value;
        totalNextYear.july = totalNextYear.july - value;
        totalNextYear.august = totalNextYear.august - value;
        totalNextYear.september = totalNextYear.september - value;
        totalNextYear.october = totalNextYear.october - value;
        break;
      case 12:
        totalToUpdate.december = totalToUpdate.december - value;
        totalNextYear.january = totalNextYear.january - value;
        totalNextYear.february = totalNextYear.february - value;
        totalNextYear.march = totalNextYear.march - value;
        totalNextYear.april = totalNextYear.april - value;
        totalNextYear.may = totalNextYear.may - value;
        totalNextYear.june = totalNextYear.june - value;
        totalNextYear.july = totalNextYear.july - value;
        totalNextYear.august = totalNextYear.august - value;
        totalNextYear.september = totalNextYear.september - value;
        totalNextYear.october = totalNextYear.october - value;
        totalNextYear.november = totalNextYear.november - value;
        break;
    }
    return totalToUpdate;
  }

  TotalPerMonth updateDeleteMonth(
      TotalPerMonth totalToUpdate, int month, int value) {
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

  String stringToDate(String aux) {
    var newDateTimeObj = new DateFormat().add_yMd().parse(aux);
    return newDateTimeObj.day.toString() +
        '/' +
        newDateTimeObj.month.toString() +
        '/' +
        newDateTimeObj.year.toString();
  }
}
