import 'package:flutter/material.dart';
import 'package:mpower_achap/constants.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:mpower_achap/main.dart';
import 'package:mpower_achap/screens/register.dart';
import 'globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mpower_achap/models/facilities.dart';
import 'package:mpower_achap/models/defaulters.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';

class Defaulters extends StatelessWidget {
  const Defaulters({Key? key}) : super(key: key);

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
            title: Text('List of Defaulters'),
            // automaticallyImplyLeading: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => myMain()));
              },
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Register()));
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
        body: MainListView(),
      ),
    );
  }
}

class MainListView extends StatefulWidget {
  @override
  _MainListViewState createState() => _MainListViewState();
}

class _MainListViewState extends State {
  final String apiURL = globals.url.toString() + 'getDefaulterList';

  bool loading = true;

  Future<List<Client>> fetchClients() async {
    // print(apiURL);
    var response = await http.get(Uri.parse(apiURL));
    print(response.statusCode);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      print(items);
      List<Client> clientList = items.map<Client>((json) {
        return Client.fromJson(json);
      }).toList();

      return clientList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  navigateToNextActivity(BuildContext context, int dataHolder) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SecondScreenState(dataHolder.toString())));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Client>>(
      future: fetchClients(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView(
          children: snapshot.data!
              .map((data) => Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          navigateToNextActivity(context, data.ID);
                        },
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                  child: Text('${data.ID}  ${data.names}',
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.left)),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                                child: Text(
                                  ' - Service Defaulted ${data.serviceDefaulted}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.yellow),
                                  textAlign: TextAlign.left,
                                ),
                              )),
                            ]),
                      ),
                      Divider(color: Colors.black),
                    ],
                  ))
              .toList(),
        );
      },
    );
  }
}

class SecondScreenState extends StatefulWidget {
  final String idHolder;

  const SecondScreenState(this.idHolder);

  @override
  State<StatefulWidget> createState() {
    return SecondScreen(this.idHolder);
  }
}

class SecondScreen extends State<SecondScreenState> {
  final String idHolder;

  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd H:m:s');
  final String strDate = formatter.format(now);

  String contacted = "";
  TextEditingController reasonNotContacted = TextEditingController();
  String serialNo = "";
  String isDefaulter = "";
  String serviceLocation = "";
  String serviceDate = "";
  String referTo = "";
  String dateContacted = "";
  String facility = "";
  String referfacility = "";
  String mflcode = "";

  final String apiURL = globals.url.toString() + 'getDefaulter';
  int _radioValue1 = -1;
  int correctScore = 0;
  int _radioValue2 = -1;
  final formKey = new GlobalKey<FormState>();

  bool defaultedVisible = false;
  bool reasonNotContactedVisible = false;
  bool serviceReceivedVisible = false;
  bool referToVisible = false;

  void showWidget() {
    setState(() {
      defaultedVisible = true;
      reasonNotContactedVisible = false;
    });
  }

  void hideWidget() {
    setState(() {
      defaultedVisible = false;
      reasonNotContactedVisible = true;
    });
  }

  void showWidget2() {
    setState(() {
      serviceReceivedVisible = true;
      referToVisible = false;
    });
  }

  void hideWidget2() {
    setState(() {
      serviceReceivedVisible = false;
      referToVisible = true;
    });
  }

  SecondScreen(this.idHolder);

  Future<List<Client>> fetchClient() async {
    var data = {'ID': int.parse(idHolder)};

    var response = await http.post(Uri.parse(apiURL), body: json.encode(data));

    if (response.statusCode == 200) {
      // print(response.statusCode);

      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<Client> clientList = items.map<Client>((json) {
        return Client.fromJson(json);
      }).toList();

      return clientList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  submit() {
    // First validate form.
    var form = formKey.currentState;
    if (form!.validate()) {
      // form.save();
      // setState(() {
      //   _myActivityResult = _myActivity;
      // });

      this.updateRegister();

      // print('Printing the login data.');
      // print('Mobile: ${_data.username}');
      // print('Password: ${_data.password}');
    }
  }

  Future updateRegister() async {
    String url = globals.url.toString() + "updateDefaulter";

    var response = await http.post(Uri.parse(url), body: {
      "contacted": contacted,
      "reasonNotContacted": reasonNotContacted.text,
      "isDefaulter": isDefaulter,
      "serviceLocation": serviceLocation,
      "serviceDate": serviceDate,
      "referTo": referfacility,
      "mohSerialNo": serialNo,
      "dateContacted": dateContacted,
      "ID": idHolder,
    });

    print(response.body);
    var data = jsonDecode(response.body);

    if (data == "Error") {
      // Scaffold.of(context).showSnackBar(SnackBar(
      print('Could not save Defaulter');
      // ));
    } else {
      print('Successfully saved defaulter');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => myMain()));
    }
  }

  Future<List<FacilityModel>> getFacilities(filter) async {
    var response =
        await http.post(Uri.parse(globals.url.toString() + "getFacilities"));

    final data = json.decode(response.body);
    //print(data);
    if (data != null) {
      //print(data.length);
      return FacilityModel.fromJsonList(data);
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController Reason = new TextEditingController();
    //String serviceDate = "";

    return MaterialApp(
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: secondaryColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.white),
          canvasColor: secondaryColor,
        ),
        home: Scaffold(
          appBar: AppBar(
              title: Text('Showing Defaulter Details'),
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                // onPressed: () => Navigator.pop(context, false),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Defaulters())),
              )),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Register()));
            },
            child: const Icon(Icons.add),
            backgroundColor: Colors.green,
          ),
          body: FutureBuilder<List<Client>>(
            future: fetchClient(),
            builder: (context, snapshot) {
              print(snapshot.hasData);
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              return ListView(
                children: snapshot.data!
                    .map((data) => Column(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: () {
                                  print(data.names);
                                },
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('ID = ' + data.ID.toString(),
                                          style: TextStyle(fontSize: 14)),
                                      Text('Name = ' + data.names,
                                          style: TextStyle(fontSize: 14)),
                                      // Text('Phone Number = ' +data.contacts,style: TextStyle(fontSize: 21))),
                                      Text(
                                          'Service Defaulted = ' +
                                              data.serviceDefaulted,
                                          style: TextStyle(fontSize: 14)),
                                      Text('Village = ' + data.village,
                                          style: TextStyle(fontSize: 14)),
                                      // Text('Guardian = ' + data.guardian,
                                      //     style: TextStyle(fontSize: 14)),
                                      // Text('CHV Name = ' + data.chvName,
                                      //     style: TextStyle(fontSize: 14)),
                                      SizedBox(height: 10.0),
                                      Text('Has the Patient been Contacted',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.greenAccent,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 5.0),
                                      Form(
                                          key: formKey,
                                          child: Column(children: [
                                            FormBuilderRadioGroup(
                                                name: 'contacted',
                                                options: [
                                                  FormBuilderFieldOption(
                                                      value: 'Yes'),
                                                  FormBuilderFieldOption(
                                                      value: 'No'),
                                                ],
                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Patient Contacted',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                                onChanged: (val) {
                                                  setState(() {
                                                    globals.sex =
                                                        val.toString();
                                                    if (val == 'Yes') {
                                                      contacted = "Yes";
                                                      dateContacted = strDate;
                                                      this.showWidget();
                                                      this.hideWidget2();
                                                      referToVisible = false;
                                                    } else {
                                                      contacted = "No";
                                                      this.hideWidget();
                                                      this.hideWidget2();
                                                      referToVisible = false;
                                                    }
                                                    print(val.toString());
                                                  });
                                                }),
                                            SizedBox(height: 10.0),
                                            Visibility(
                                              maintainAnimation: true,
                                              maintainState: true,
                                              visible: defaultedVisible,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'Has the Patient defaulted',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors
                                                              .greenAccent,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(height: 10.0),
                                                  FormBuilderRadioGroup(
                                                      name: 'isDefaulted',
                                                      options: [
                                                        FormBuilderFieldOption(
                                                            value: 'Yes'),
                                                        FormBuilderFieldOption(
                                                            value: 'No'),
                                                      ],
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            'Patient Defaulted',
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                      ),
                                                      onChanged: (val) {
                                                        setState(() {
                                                          globals.sex =
                                                              val.toString();
                                                          if (val == 'Yes') {
                                                            isDefaulter = "Yes";
                                                            this.hideWidget2();
                                                          } else {
                                                            isDefaulter = "No";
                                                            this.showWidget2();
                                                          }
                                                          print(val.toString());
                                                        });
                                                      }),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 5.0),
                                            Visibility(
                                              maintainAnimation: true,
                                              maintainState: true,
                                              visible:
                                                  reasonNotContactedVisible,
                                              child: TextFormField(
                                                controller: reasonNotContacted,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Reason not Contacted',
                                                  // suffixIcon: Icon(Icons.email),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5.0),
                                            Visibility(
                                              maintainAnimation: true,
                                              maintainState: true,
                                              visible: serviceReceivedVisible,
                                              child: Column(
                                                children: [
                                                  DropdownSearch<FacilityModel>(
                                                    // maxHeight: 300,
                                                    //onFind:(filter)=>getFacilities(filter),
                                                    asyncItems: (String?
                                                            filter) =>
                                                        getFacilities(filter),
                                                    dropdownDecoratorProps:
                                                        DropDownDecoratorProps(
                                                      dropdownSearchDecoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Facility patient received service",
                                                        contentPadding:
                                                            EdgeInsets.fromLTRB(
                                                                12, 12, 0, 0),
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),
                                                    onChanged: (value) {
                                                      mflcode = value!.mflcode
                                                          .toString();
                                                      serviceLocation = value
                                                          .facilityname
                                                          .toString();
                                                    },
                                                    popupProps: PopupProps.menu(
                                                        showSearchBox: true),
                                                    //showSearchBox: true,
                                                  ),
                                                  SizedBox(height: 10.0),
                                                  FormBuilderDateTimePicker(
                                                    name: 'serviceDate',
                                                    onChanged: (value) {
                                                      serviceDate =
                                                          value.toString();
                                                      print(value.toString());
                                                    },
                                                    inputType: InputType.date,
                                                    format: DateFormat(
                                                        'yyyy-MM-dd'),
                                                    lastDate: DateTime.now(),
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Date received service',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                    ),
                                                    //initialTime: TimeOfDay(hour: 8, minute: 0),
                                                    //initialValue: DateTime.now(),
                                                    enabled: true,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // SizedBox(height:5.0),
                                            Visibility(
                                              maintainAnimation: true,
                                              maintainState: true,
                                              visible: referToVisible,
                                              child: Column(
                                                children: [
                                                  DropdownSearch<FacilityModel>(
                                                    //maxHeight: 300,
                                                    //onFind:(filter)=>getFacilities(filter),
                                                    asyncItems: (String?
                                                            filter) =>
                                                        getFacilities(filter),
                                                    dropdownDecoratorProps:
                                                        DropDownDecoratorProps(
                                                      dropdownSearchDecoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Refer patient to Facility",
                                                        contentPadding:
                                                            EdgeInsets.fromLTRB(
                                                                12, 12, 0, 0),
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),
                                                    onChanged: (value) {
                                                      mflcode = value!.mflcode
                                                          .toString();
                                                      referfacility =
                                                          value.facilityname;
                                                    },
                                                    //showSearchBox: true,
                                                    popupProps: PopupProps.menu(
                                                        showSearchBox: true),
                                                  ),
                                                  SizedBox(height: 5.0),
                                                  TextFormField(
                                                    //controller: serialNo,
                                                    decoration: InputDecoration(
                                                      hintText: 'MOH Serial No',
                                                      // suffixIcon: Icon(Icons.email),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                    ),
                                                    onChanged: (value) {
                                                      serialNo =
                                                          value.toString();
                                                      // referfacility=value.facilityname;
                                                    },
                                                    validator: (value) {
                                                      if (referfacility != "") {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please enter MOH Serial No';
                                                        }
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10.0),
                                            Container(
                                              child: ElevatedButton(
                                                child: Text('Save'),
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.indigo,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 50,
                                                            vertical: 20),
                                                    textStyle: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white)),
                                                onPressed: () {
                                                  // print(serialNo);
                                                  this.submit();
                                                },
                                              ),
                                            )
                                          ])),
                                    ])),
                          )
                        ]))
                    .toList(),
              );
            },
          ),
        ));
  }
}
