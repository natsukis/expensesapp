import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

class LoadAndViewCsvPage extends StatelessWidget {
  final String path;
  const LoadAndViewCsvPage({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CSV generado exitosamente!'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: _loadCsvData(),
        builder: (_, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(5),
              child: SingleChildScrollView(
                child:Column(
                children: snapshot.data
                    .map(
                      (row) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(row[0]),
                            Text(row[1]),
                            Text(row[2]),
                            Text(row[3]),
                            Text(row[4].toString()),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ));
          }

          return Center(
            child: Text('no data found !!!'),
          );
        },
      ),
    );
  }

  Future<List<List<dynamic>>> _loadCsvData() async {
    final file = new File(path).openRead();
    return await file
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
  }
}