import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mpower_achap/constants.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:mpower_achap/database.dart';
import 'package:mpower_achap/main.dart';
import 'globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'household_register.dart';
import 'mappedList.dart';
import 'package:mpower_achap/models/householdMapping.dart';
import 'package:intl/intl.dart';

class HouseholdDetails extends StatefulWidget {
  final String idHolder;
  const HouseholdDetails(this.idHolder);

  @override
  State<StatefulWidget> createState() {
    return _HouseholdDetailsState(this.idHolder);
  }
}

class _HouseholdDetailsState extends State<HouseholdDetails>
    with SingleTickerProviderStateMixin {
  final String idHolder;
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd H:m:s');
  final String strDate = formatter.format(now);

  late AnimationController _animationController;
  // This is used to animate the icon of the main FAB
  late Animation<double> _buttonAnimatedIcon;
  // This is used for the child FABs
  late Animation<double> _translateButton;
  // This variable determnies whether the child FABs are visible or not
  bool _isExpanded = false;

  _HouseholdDetailsState(this.idHolder);

  final String apiURL =globals.url.toString() + 'getHouseholdList';
  String dateContacted="";
  String mothersName="";
  String chuName="";
  int hhNo=0;
  int yearBirth=1900;
  String delivered="";
  String dateDelivered="";
  String deliveryPlace="";
  String sex="";
  String weightAtBirth="";
  String supportGroup="";
  String married="";
  String spouseName="";
  String spouseContact="";
  String otherName="";
  String otherContact="";

  @override
  initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..addListener(() {
        setState(() {});
      });

    _buttonAnimatedIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _translateButton = Tween<double>(
      begin: 100,
      end: -20,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    super.initState();
  }

  // dispose the animation controller
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

  Future<List<HouseholdMapping>> fetchClient2() async {
    var data = {'ID': int.parse(idHolder)};

    var response = await http.post(Uri.parse(apiURL), body: json.encode(data));

    if (response.statusCode == 200) {
      // print(response.statusCode);

      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<HouseholdMapping> clientList = items.map<HouseholdMapping>((json) {
        return HouseholdMapping.fromJson(json);
      }).toList();
      //print(clientList.length);

      return clientList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  Future<List<HouseholdMapping>> fetchClient(String id) async {
    final db = await DBProvider.db();
    var data = await db.query('household_mapping',
        where: "ID = ?", whereArgs: [id], limit: 1);
    // var data = await DBProvider.getDefaulters();

    String households = jsonEncode(data);
    List<HouseholdMapping> clientList = parseResponse(households);

      return clientList;
  }

  static List<HouseholdMapping> parseResponse(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<HouseholdMapping>((json) => HouseholdMapping.fromJson(json)).toList();
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
      home:Scaffold(
        appBar: AppBar(
          title: Text("Household Mapping Details"),
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              // onPressed: () => Navigator.pop(context, false),
              onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (context)=>MappedList())),
            )
        ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Transform(
                transform: Matrix4.translationValues(
                    0.0,
                    _translateButton.value * 4,
                    0.0,
                ),
                child: FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => HouseholdRegister()));
                  },
                  child: const Icon(
                    Icons.add,
                  ),
                ),
              ),
              Transform(
                transform: Matrix4.translationValues(
                    0,
                    _translateButton.value * 3,
                    0
                ),
                child: FloatingActionButton(
                  backgroundColor: Colors.redAccent,
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => myMain()));
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

        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.push(context,MaterialPageRoute(builder: (context) => HouseholdRegister()));
        //   },
        //   child: const Icon(Icons.add),
        //   backgroundColor: Colors.green,
        // ),

        body:FutureBuilder<List<HouseholdMapping>>(
          future:fetchClient(idHolder),
          builder: (context, snapshot){
            print(snapshot.hasData);
            if(!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            return ListView(
              children: snapshot.data!
                  .map((data) => Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onTap: () {
                            print(data.mothersName);
                          },
                          child: Column(
                              crossAxisAlignment:CrossAxisAlignment.start,
                              children: [
                                Text('ID = ' + data.ID.toString(), style: TextStyle(fontSize: 18,color: Colors.red)),
                                Text('Mothers Name = ' + data.mothersName,style: TextStyle(fontSize: 16,color: Colors.amber)),
                                Text('Date Contacted = ' +data.dateContacted,style: TextStyle(fontSize: 16,color: Colors.amber)),
                                Text('CHU Name = ' +data.chuName,style: TextStyle(fontSize: 16,color: Colors.amber)),
                                Text('Year of Birth = ' + data.yearBirth.toString(),style: TextStyle(fontSize: 16,color: Colors.amber)),
                                SizedBox(height: 10.0),
                                Text('Has She Delivered = ' + data.delivered,style: TextStyle(fontSize: 16,color: Colors.amber)),
                                Text('Delivered Date = ' + data.dateDelivered,style: TextStyle(fontSize: 16,color: Colors.amber)),
                                Text('Delivery Place = ' + data.deliveryPlace,style: TextStyle(fontSize: 16,color: Colors.amber)),
                                Text('Sex = ' + data.sex,style: TextStyle(fontSize: 16,color: Colors.amber)),
                                Text('Weight At Birth = ' + data.weightAtBirth,style: TextStyle(fontSize: 16,color: Colors.amber)),
                                SizedBox(height: 10.0),
                                Text('Support Group = ' + data.supportGroup,style: TextStyle(fontSize: 16,color: Colors.amber)),
                                SizedBox(height: 10.0),
                                Text('Married = ' + data.married,style: TextStyle(fontSize: 16,color: Colors.amber)),
                                Text('Spouse Name = ' + data.spouseName,style: TextStyle(fontSize: 16,color: Colors.amber)),
                                Text('Spouse Contact = ' + data.spouseContact,style: TextStyle(fontSize: 16,color: Colors.amber)),
                                Text('If Others Name = ' + data.otherName,style: TextStyle(fontSize: 16,color: Colors.amber)),
                                Text('If Others Contact = ' + data.otherContact,style: TextStyle(fontSize: 16,color: Colors.amber)),
                                SizedBox(height: 10.0),

                              ])),
                    )]))
                  .toList(),
            );
          },
        )
      )
    );
  }
}
