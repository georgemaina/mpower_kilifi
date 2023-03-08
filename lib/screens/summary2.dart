import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mpower_achap/constants.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:mpower_achap/database.dart';
import 'package:mpower_achap/screens/globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:mpower_achap/screens/defaulters.dart';
import 'package:mpower_achap/screens/completeDefaulters.dart';
import 'package:mpower_achap/models/defaulterTotals.dart';

// import 'package:mpower/screens/awareness_home.dart';

class Summary2 extends StatefulWidget {
  const Summary2({Key? key}) : super(key: key);

  @override
  State<Summary2> createState() => _Summary2State();
}

class _Summary2State extends State<Summary2> {
  // final String idHolder;
  List<Map<String, dynamic>> _records = [];
  int totalRecords = 0;
  late List<DefaulterTotals> _totalServices;
  final String apiURL = globals.url.toString() + 'defaulterNos';

  String Immunization = "";
  String VitaminA = "";
  String Dewarming = "";
  String GrowthMonitoring = "";

  Future<List<DefaulterTotals>> fetchDefaulters() async {
    final db = await DBProvider.db();
    var data = await db.rawQuery(
        'SELECT count(IIF(serviceDefaulted="ANC",1,null)) AS Anc,count(IIF(serviceDefaulted="Immunization",1,null)) AS Immunization,count(IIF(serviceDefaulted="VitaminA",1,NULL)) AS VitaminA,count(IIF(serviceDefaulted="Dewarming",1,NULL)) AS Dewarming,count(IIF(serviceDefaulted="Growth Monitoring",1,NULL)) AS GrowthMonitoring FROM  defaulters');

    String defaulters = jsonEncode(data);
    List<DefaulterTotals> defaulterTotals = parseResponse(defaulters);

    return defaulterTotals;
  }

  static List<DefaulterTotals> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<DefaulterTotals>((json) => DefaulterTotals.fromJson(json))
        .toList();
  }

  _getDefaulterTotals() {
    // _showProgress('Loading Employees...');
    fetchDefaulters().then((services) {
      setState(() {
        _totalServices = services;
      });

      globals.immunization = int.parse(services[0].Immunization.toString());
      globals.vitaminA = int.parse(services[0].VitaminA.toString());
      globals.dewarming = int.parse(services[0].Dewarming.toString());
      globals.growthMonitoring =
          int.parse(services[0].GrowthMonitoring.toString());
      globals.anc = int.parse(services[0].Anc.toString());

      print("Immunization is ${services[0].Immunization}");
    });
  }

  @override
  void initState() {
    fetchDefaulters();
    _getDefaulterTotals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          maintainAnimation: true,
          maintainState: true,
          visible: globals.CU,
          child: Row(
            children: [
              Flexible(
                child: Text(
                  "Defaulter Tracing/Tracking List",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent),
                ),
              ),
              Flexible(
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Defaulters()));
                    print(globals.loggedUser.toString());
                  },
                  child: const Icon(Icons.add),
                  backgroundColor: Colors.green,
                  mini: true,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Visibility(
          maintainAnimation: true,
          maintainState: true,
          visible: globals.healthWorker,
          child: Row(
            children: [
              Flexible(
                child: Text(
                  "Defaulter Defaulters sent to You",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent),
                ),
              ),
              Flexible(
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompleteDefaulters()));
                    print(globals.loggedUser.toString());
                  },
                  child: const Icon(Icons.add),
                  backgroundColor: Colors.green,
                  mini: true,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.0),
          child: Container(
              height: 3.0, width: double.infinity, color: Colors.blue),
        ),
        DataTable(columns: const <DataColumn>[
          DataColumn(
              label: Text('Service Dafaulted',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label:
                  Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
        ], rows: <DataRow>[
          DataRow(cells: <DataCell>[
            DataCell(Text('Total Immunization',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(4282547648)))),
            DataCell(Text(globals.immunization.toString())),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text('Vitamin A',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(4282547648)))),
            DataCell(Text(globals.vitaminA.toString())),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text('De-Worming:',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(4282547648)))),
            DataCell(Text(globals.dewarming.toString())),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text('Growth Monitoring',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(4282547648)))),
            DataCell(Text(globals.growthMonitoring.toString())),
          ]),
          DataRow(cells: <DataCell>[
            DataCell(Text('ANC Mothers',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(4282547648)))),
            DataCell(Text(globals.anc.toString())),
          ])
        ]),
      ],
    );
  }
}
