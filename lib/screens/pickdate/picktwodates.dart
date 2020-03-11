import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gastosapp/screens/income/incomerangeday.dart';
import 'package:gastosapp/screens/inversion/inversionrangeday.dart';
import 'package:gastosapp/screens/total/totalperday.dart';
import 'package:gastosapp/screens/totalmoves.dart';
import 'package:intl/intl.dart';

import 'package:gastosapp/screens/expense/expenserangeday.dart';


class PickTwoDate extends StatefulWidget {
  final String screen;
  @override
  State<StatefulWidget> createState() => PickTwoDateState(this.screen);
  PickTwoDate(this.screen);
}

class PickTwoDateState extends State {
  DateTime dateFrom;
  DateTime dateTo;
  String screen;
  PickTwoDateState(this.screen);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
        appBar: AppBar(
          title: Text("Fecha"),
          centerTitle: true,
          backgroundColor: Colors.cyan,
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            RaisedButton(
              color: Colors.cyan,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(28.0),
                    side: BorderSide(color: Colors.blue)),
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2020, 1, 1),
                      maxTime: DateTime(2028, 12, 31),
                      onChanged: (date) {}, onConfirm: (date) {
                    setState(() {
                      dateFrom = date;
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.es);
                },
                child: Text(
                  'Elegir fecha desde:',
                  style: TextStyle(color: Colors.white),
                )),
            Container(child: Text(convertDateToString(dateFrom),style: TextStyle(color:Colors.white))),
            RaisedButton(
              color: Colors.cyan,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(28.0),
                    side: BorderSide(color: Colors.blue)),
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2020, 1, 1),
                      maxTime: DateTime(2028, 12, 31),
                      onChanged: (date) {}, onConfirm: (date) {
                    setState(() {
                      dateTo = date;
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.es);
                },
                child: Text(
                  'Elegir fecha hasta:',
                  style: TextStyle(color: Colors.white),
                )),
            Container(child: Text(convertDateToString(dateTo),style: TextStyle(color:Colors.white))),
            RaisedButton(
              color: Colors.lightBlue,
              textColor: Colors.white,
              child: Text("Buscar"),
              onPressed: () {
                alert();
              },
            )
          ],
        )));
  }

  String convertDateToString(DateTime datetoconvert) {
    if (datetoconvert == null) {
      return '';
    } else {      
      return datetoconvert.day.toString() +
        '/' +
        datetoconvert.month.toString() +
        '/' +
        datetoconvert.year.toString();
    }
  }

  bool checkDates() {
    if (dateTo == null || dateFrom == null || dateFrom.add(new Duration(days: -1)).isAfter(dateTo.add(new Duration(days: 1)))) {
      return false;
    } else {
      return true;
    }
  }

  // void navigateExcel() async {
  //   bool result = await Navigator.push(context,
  //       MaterialPageRoute(builder: (context) => Excel(dateFrom, dateTo)));
  // }

  void navigateTotalIncome() async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => IncomeRangeDay(dateFrom, dateTo)));
  }

     void navigateExpenseTotal() async {
     bool result = await Navigator.push(context,
         MaterialPageRoute(builder: (context) => ExpenseRangeDay(dateFrom, dateTo)));
   }

        void navigateInversionTotal() async {
     bool result = await Navigator.push(context,
         MaterialPageRoute(builder: (context) => InversionRangeDay(dateFrom, dateTo)));
   }

           void navigateTotalMoves() async {
     bool result = await Navigator.push(context,
         MaterialPageRoute(builder: (context) => TotalMoves(dateFrom, dateTo)));
   }

              void navigateTotalPerDay() async {
     bool result = await Navigator.push(context,
         MaterialPageRoute(builder: (context) => TotalPerDay(dateFrom, dateTo)));
   }

  Widget alert() {
    if (checkDates()) {
      if (screen == "Inversion") {
        navigateInversionTotal();
      }else if(screen == "Expense"){
        navigateExpenseTotal();
      }else if(screen == "TotalMoves"){
        navigateTotalMoves();
      }else if(screen == "TotalPerDay"){
        navigateTotalPerDay();
      }else{
        navigateTotalIncome();
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
      content: Text("Elegir ambas fechas correctamente."),
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
