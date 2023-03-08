import 'package:flutter/material.dart';
import 'package:mpower_achap/models/householdMapping.dart';
import 'globals.dart' as globals;
import 'package:mpower_achap/database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:mpower_achap/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mappingVisitType.dart';
import 'household_register.dart';
import 'householdMappingDetails.dart';
import 'package:mpower_achap/main.dart';

class MappedList extends StatefulWidget {
  const MappedList({Key? key}) : super(key: key);

  @override
  _MappedListState createState() => _MappedListState();
}

class _MappedListState extends State<MappedList>
    with SingleTickerProviderStateMixin {
  final String apiURL = globals.url.toString() + 'getDefaulterList';
  static const _GET_ALL_ACTION = 'GET_ALL';

  late List<HouseholdMapping> _households;

  late AnimationController _animationController;
  // This is used to animate the icon of the main FAB
  late Animation<double> _buttonAnimatedIcon;
  // This is used for the child FABs
  late Animation<double> _translateButton2;
  // This variable determnies whether the child FABs are visible or not
  bool _isExpanded = false;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..addListener(() {
        setState(() {});
      });

    _buttonAnimatedIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _translateButton2 = Tween<double>(
      begin: 100,
      end: -20,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _households = [];
    _getHouseholds();
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // This function is used to expand/collapse the children floating buttons
  // It will be called when the primary FAB (with menu icon) is pressed
  _toggle() {
    if (_isExpanded) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    _isExpanded = !_isExpanded;
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

  static Future<List<HouseholdMapping>> _getHouseholdslist2() async {
    // try {
    final String apiURL = globals.url.toString() + 'getHouseholdList';
    var map = Map<String, dynamic>();
    map['action'] = _GET_ALL_ACTION;
    final response = await http.get(Uri.parse(apiURL));
    print('getHouseholdList Response: ${response.body}');
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

  static Future<List<HouseholdMapping>> _getHouseholdslist() async {
    final db = await DBProvider.db();
    var data = await db.query('household_mapping', orderBy: "ID");
    String households = jsonEncode(data);

    List<HouseholdMapping> list = parseResponse(households);
      return list;
  }

  static List<HouseholdMapping> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<HouseholdMapping>((json) => HouseholdMapping.fromJson(json))
        .toList();
  }

  navigateToNextActivity(BuildContext context, int dataHolder) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HouseholdDetails(dataHolder.toString())));
  }

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
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MappingVisitType())),
            )),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Transform(
              transform: Matrix4.translationValues(
                0.0,
                _translateButton2.value * 4,
                0.0,
              ),
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HouseholdRegister()));
                },
                child: const Icon(
                  Icons.add,
                ),
              ),
            ),
            Transform(
              transform:
                  Matrix4.translationValues(0, _translateButton2.value * 3, 0),
              child: FloatingActionButton(
                backgroundColor: Colors.redAccent,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => myMain()));
                },
                child: const Icon(
                  Icons.home,
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: _toggle,
              child: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: _buttonAnimatedIcon,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Mother')),
                  DataColumn(label: Text('Date Contacted')),
                  DataColumn(label: Text('CHU')),
                ],
                rows: _households
                    .map(
                      (client) => DataRow(cells: [
                        DataCell(
                          Text(client.ID.toString()),
                          onTap: () {
                            navigateToNextActivity(context, client.ID);
                          },
                        ),
                        DataCell(
                          Text(
                            client.mothersName,
                            style: TextStyle(color: Colors.amber),
                          ),
                          onTap: () {
                            navigateToNextActivity(context, client.ID);
                          },
                        ),
                        DataCell(
                          Text(
                            client.dateContacted,
                            style: TextStyle(color: Colors.amber),
                          ),
                          onTap: () {
                            navigateToNextActivity(context, client.ID);
                          },
                        ),
                        DataCell(
                          Text(client.chuName),
                          onTap: () {
                            // navigateToNextActivity(context, client.ID);
                          },
                        ),
                      ]),
                    )
                    .toList(),
              ),
            )),
      ),
    );
  }
}
