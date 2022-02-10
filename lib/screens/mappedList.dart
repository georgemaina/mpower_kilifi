import 'package:flutter/material.dart';
import 'package:mpower/models/householdMapping.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:mpower/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mappingVisitType.dart';
import 'household_register.dart';
import 'householdMappingDetails.dart';

class MappedList extends StatefulWidget {
  const MappedList({Key? key}) : super(key: key);

  @override
  _MappedListState createState() => _MappedListState();
}

class _MappedListState extends State<MappedList> {
  final String apiURL =globals.url.toString() + 'getDefaulterList';
  static const _GET_ALL_ACTION = 'GET_ALL';
  late List<HouseholdMapping> _households;

  void initState() {
    super.initState();
    _households = [];
    _getHouseholds();
  }

  _getHouseholds() {
    // _showProgress('Loading Employees...');
    _getHouseholdslist().then((households) {
      setState(() {
        _households = households;
      });
      // _showProgress(widget.title); // Reset the title...
      print("Length ${households.length}");
    });
  }

  static Future<List<HouseholdMapping>> _getHouseholdslist() async {
    // try {
    final String apiURL =globals.url.toString() + 'getHouseholdsList';
    var map = Map<String, dynamic>();
    map['action'] = _GET_ALL_ACTION;
    final response =  await http.get(Uri.parse(apiURL));
    print('getHouseholdslist Response: ${response.body}');
    if (200 == response.statusCode) {
      List<HouseholdMapping> list = parseResponse(response.body);
      return list;
    } else {
      throw Exception('Failed to load data from Server.');

    }
    // } catch (e) {
    //   return List<Client>(); // return an empty list on exception/error
    // }
  }

  static List<HouseholdMapping> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<HouseholdMapping>((json) => HouseholdMapping.fromJson(json)).toList();
  }

  // navigateToNextActivity(BuildContext context, int dataHolder) {
  //   Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) => HouseholdDetails(dataHolder.toString())));
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: secondaryColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: Scaffold(
        appBar: AppBar(
            title: Text('Household Mapping List'),
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              // onPressed: () => Navigator.pop(context, false),
              onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (context)=>MappingVisitType())),
            )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => HouseholdRegister()));
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:DataTable(
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Names')),
                  DataColumn(label: Text('Service')),
                  DataColumn(label: Text('Village')),
                ],
                rows: _households
                    .map((client) => DataRow(cells:[
                  DataCell(
                    Text(client.ID.toString()),
                    onTap: () {
                      // navigateToNextActivity(context, client.ID);
                    },
                  ),
                  DataCell(
                    Text(client.mothersName,style: TextStyle(color: Colors.amber),),
                    onTap: () {
                      // navigateToNextActivity(context, client.ID);
                    },
                  ),
                  DataCell(
                    Text(client.dateContacted,style: TextStyle(color: Colors.amber),),
                    onTap: () {
                      // navigateToNextActivity(context, client.ID);
                    },
                  ),
                  DataCell(
                    Text(client.chuName),
                    onTap: () {
                      // navigateToNextActivity(context, client.ID);
                    },
                  ),
                ]),
                ).toList(),
              ),
            )
        ),
        ),
      );
  }
}
