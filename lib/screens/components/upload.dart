import 'package:flutter/material.dart';
import 'package:mpower_achap/database.dart';
import 'package:http/http.dart' as http;
import 'package:mpower_achap/screens/globals.dart' as globals;
import 'dart:convert';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  List<Map<String, dynamic>> _records = [];
  int totalRecords = 0;

  void uploadHealthWorkers() async {
    final bpdata = await DBProvider.getWorkers();
    String url = globals.url.toString() + "uploadHealthWorkers";
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bpdata));
    print(response.body);

    var data = jsonDecode(response.body);
    // print(data);

    if (data == "Error") {
      print('Could not Add Health Workers');
    } else {
      print('Successfully Added Health Workers');
    }
  }

  //
  void uploadDefaulters() async {
    final bpdata = await DBProvider.getDefaulters();
    String url = globals.url.toString() + "uploadDefaulters";
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bpdata));

    var data = jsonDecode(response.body);
    print(data);

    if (data == "Error") {
      print('Could not upload Defaulters');
    } else {
      print('Successfully Uploaded Defaulters');
    }
  }


  void uploadMappingList() async {
    final bpdata = await DBProvider.getHouseHoldMapping();
    String url = globals.url.toString() + "uploadMappingList";
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bpdata));

    var data = jsonDecode(response.body);
    print(data);

    if (data == "Error") {
      print('Could not upload Household Mapping data');
    } else {
      print('Successfully Uploaded Household Mapping data');
    }
  }

  void _getWorkers() async {
    final data = await DBProvider.countRecords();

    setState(() {
      _records = data;
      totalRecords = _records.length;
      print("Total Defaulters $totalRecords");
    });
  }

  static Future<int> deleteRows() async {
    final db = await DBProvider.db();
    db.execute("Delete from defaulters");
    db.execute("Delete from household_mapping");

    return 1;
  }

  @override
  void initState() {
    super.initState();
    _getWorkers();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            child: Text(
          "READY TO UPLOAD : $totalRecords Records",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.yellow),
        )),
        Flexible(
          child: IconButton(
              icon: Icon(Icons.upload),
              iconSize: 35,
              color: Colors.white,
              tooltip: 'Upload Records',
              onPressed: () {
                setState(() {
                  //  _getWorkers();
                  uploadDefaulters();
                  uploadMappingList();
                  // uploadHealthWorkers();
                  deleteRows();
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>Workers()));
                });
              }),
        )
      ],
    );
  }
}
