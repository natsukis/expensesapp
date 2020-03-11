import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:gastosapp/model/expense.dart';
import 'package:gastosapp/model/inversion.dart';



class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();

  String tblExpense = "expense";
  String tblInversion = "inversion";
  String colId = "id";
  String colArticle = "article";
  String colDescription = "description";
  String colPrice = "price";
  String colDate = "date";
  String colType = "type";

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "expenses.db";
    var dbExpenses = await openDatabase(path, version: 1, onCreate: _create);
    return dbExpenses;
  }

  void _create(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tblExpense($colId INTEGER PRIMARY KEY, $colArticle TEXT, " +
            "$colDescription TEXT, $colPrice INTEGER, $colType TEXT, $colDate TEXT)");
    await db.execute(
        "CREATE TABLE $tblInversion($colId INTEGER PRIMARY KEY, $colArticle TEXT, " +
            "$colDescription TEXT, $colPrice INTEGER, $colDate TEXT)");
  }

  //<--Expense block-->

  Future<int> insertExpense(Expense expense) async {
    Database db = await this.db;
    var result = await db.insert(tblExpense, expense.toMap());
    return result;
  }

  Future<List> getExpenses() async {
    Database db = await this.db;
    var result =
        await db.rawQuery("SELECT * FROM $tblExpense order by $colArticle ASC");
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("Select count (*) from $tblExpense"));
    return result;
  }

  Future<int> updateExpense(Expense expense) async {
    Database db = await this.db;
    var result = await db.update(tblExpense, expense.toMap(),
        where: "$colId = ?", whereArgs: [expense.id]);
    return result;
  }

  Future<int> deleteExpense(int id) async {
    int result;
    Database db = await this.db;
    result = await db.rawDelete('DELETE FROM $tblExpense WHERE $colId = $id');
    return result;
  }
  //<--Expense block-->

  //<--Inversion block-->
    Future<int> insertInversion(Inversion inversion) async {
    Database db = await this.db;
    var result = await db.insert(tblInversion, inversion.toMap());
    return result;
  }

  Future<List> getInversion() async {
    Database db = await this.db;
    var result =
        await db.rawQuery("SELECT * FROM $tblInversion order by $colArticle ASC");
    return result;
  }

  Future<int> getInversionCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("Select count (*) from $tblInversion"));
    return result;
  }

  Future<int> updateInversion(Inversion inversion) async {
    Database db = await this.db;
    var result = await db.update(tblInversion, inversion.toMap(),
        where: "$colId = ?", whereArgs: [inversion.id]);
    return result;
  }

  Future<int> deleteInversion(int id) async {
    int result;
    Database db = await this.db;
    result = await db.rawDelete('DELETE FROM $tblInversion WHERE $colId = $id');
    return result;
  }
  //<--Inversion block-->

}
