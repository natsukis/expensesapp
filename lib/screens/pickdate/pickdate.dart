import 'package:gastosapp/screens/expense/expensepage.dart';
import 'package:flutter/material.dart';
import 'package:gastosapp/screens/income/incomepage.dart';
import 'package:gastosapp/screens/inversion/inversionpage.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class PickDate extends StatefulWidget {
  String route;
  PickDate(this.route);
  @override
  State<StatefulWidget> createState() => PickDateState(route);
}

class PickDateState extends State {
  String datesText = '';
  String dates = '';
  DateTime dateValidation;
  String route;
  PickDateState(this.route);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Image.asset("images/calendar.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          alignment: Alignment.center),
      Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Ingrese fecha"),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          body: Center(
              child: Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Column(children: <Widget>[
                    RaisedButton(
                        color: Colors.brown[200],
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(28.0),
                            side: BorderSide(color: Colors.brown)),
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2020, 1, 1),
                              maxTime: DateTime(2028, 12, 31),
                              onChanged: (date) {}, onConfirm: (date) {
                            setState(() {
                              datesText = dateToString(date);
                              dates = dateToBd(date);
                              dateValidation = date;
                            });
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.es);
                        },
                        child: Text(
                          'Elegir fecha a buscar',
                          style: TextStyle(color: Colors.white),
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Container(
                            child: Text(datesText,
                                style: TextStyle(decoration: TextDecoration.underline,color:Colors.redAccent[400])))),
                    RaisedButton(
                      color: Colors.brown,
                      child: Text("Buscar"),
                      textColor: Colors.white,
                      onPressed: () {
                        alert();
                      },
                    )
                  ]))))
    ]);
  }

  void navigateToSale(String dates) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ExpensePage(dates)));
  }

  void navigateToIncome(String dates) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => IncomePage(dates)));
  }

  void navigateToInversion(String dates) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => InversionPage(dates)));
  }

  String dateToString(DateTime dateAux) {
    var x = dateAux.day.toString() +
        '/' +
        dateAux.month.toString() +
        '/' +
        dateAux.year.toString();
    return x;
  }

  String dateToBd(DateTime dateAux) {
    var x = dateAux.month.toString() +
        '/' +
        dateAux.day.toString() +
        '/' +
        dateAux.year.toString();
    return x;
  }

  bool checkDates() {
    if (dateValidation == null) {
      return false;
    } else {
      return true;
    }
  }

  Widget alert() {
    if (checkDates()) {
      if (route == "Expense") {
        navigateToSale(dates);
      } else if (route == "Inversion") {
        navigateToInversion(dates);
      } else {
        navigateToIncome(dates);
      }
    } else {
      return showAlertDialog(context);
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text("Elegir fecha correctamente."),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
