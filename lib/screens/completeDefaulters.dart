import 'package:flutter/material.dart';
import 'package:mpower/constants.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:mpower/main.dart';
import 'package:mpower/screens/register.dart';
import 'globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mpower/models/facilities.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';

class CompleteDefaulters extends StatelessWidget {
  const CompleteDefaulters({Key? key}) : super(key: key);

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
            title: Text('Complete Defaulters'),
            // automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => myMain()));
              },
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => Register()));
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
        body: MainListView(),
      ),
    );
  }
}

class Client {
  int ID;
  String names;
  String age;
  String sex;
  String serviceDefaulted;
  String village;
  String guardian;
  String contacts;
  String chvName;
  String contacted;

  Client({
    required this.ID,
    required this.names,
    required this.age,
    required this.sex,
    required this.serviceDefaulted,
    required this.village,
    required this.guardian,
    required this.contacts,
    required this.chvName,
    required this.contacted,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      ID: json["ID"],
      names: json["names"],
      age: json["age"],
      sex: json["sex"],
      serviceDefaulted: json["serviceDefaulted"],
      village: json["village"],
      guardian: json["guardian"],
      contacts: json["contacts"],
      chvName: json["chvName"],
      contacted: json['contacted'],
    );
  }
}

class MainListView extends StatefulWidget {
  @override
  _MainListViewState createState() => _MainListViewState();
}

class _MainListViewState extends State {
  final String apiURL =globals.url.toString() + 'getDefaulterList';

  Future<List<Client>> fetchClients() async {
    // print(apiURL);
    var response = await http.get(Uri.parse(apiURL));
    // print(response.statusCode);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      print(items);
      List<Client> clientList = items.map<Client>((json) {
        return Client.fromJson(json);
      }).toList();
      print(clientList.length);

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

        print(snapshot.hasData);

        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());


        // print(!snapshot.data.names.length);
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
                      // if (Responsive.isDesktop(context))
                      //   Expanded(
                      //     // default flex = 1
                      //     // and it takes 1/6 part of the screen
                      //     child: SideMenu(),
                      //   ),

                      Padding(
                          padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                          child: Text(
                              '${data.ID}  ${data.names}',
                              style: TextStyle(fontSize: 13),
                              textAlign: TextAlign.left)),
                      Expanded(
                          child:Padding(
                            padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                            child: Text(
                              ' - Service Defaulted ${data.serviceDefaulted}',
                              style: TextStyle(fontSize: 13,color:Colors.yellow),
                              textAlign: TextAlign.left,
                            ),
                          )
                      ),

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

  String contacted="";
  TextEditingController reasonNotContacted = TextEditingController();
  TextEditingController serviceOffered = TextEditingController();
  TextEditingController hwRecommendation = TextEditingController();

  String isDefaulter="";
  String serviceLocation="";
  String serviceDate="";
  String referTo="";
  String dateContacted ="";
  String facility="";
  String mflcode="";


  final String apiURL =globals.url.toString() + 'getDefaulter';
  int _radioValue1 = -1;
  int correctScore = 0;
  int _radioValue2 = -1;
  final formKey =new GlobalKey<FormState>();

  bool defaultedVisible = false ;
  bool reasonNotContactedVisible = false ;
  bool serviceReceivedVisible = false ;
  bool referToVisible = false ;

  void showWidget(){
    setState(() {
      defaultedVisible = true ;
      reasonNotContactedVisible=false;
    });
  }

  void hideWidget(){
    setState(() {
      defaultedVisible = false;
      reasonNotContactedVisible=true;
    });
  }

  void showWidget2(){
    setState(() {
       serviceReceivedVisible=true;
      referToVisible=false;
    });
  }

  void hideWidget2(){
    setState(() {
      serviceReceivedVisible=false;
      referToVisible=true;
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
      //print(clientList.length);

      return clientList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  submit(){
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
    String url = globals.url.toString() +"updateHwResults";
    var response = await http.post(Uri.parse(url), body: {
      "clientStatus":"Complete",
      "serviceOffered": serviceOffered.text,
      "hwRecommendation": hwRecommendation.text,
      "serviceLocation": serviceLocation,
      "completionDate": strDate,
      "ID":idHolder,
    });

    print(response.body);
    var data=jsonDecode(response.body);

    if(data=="Error"){
      // Scaffold.of(context).showSnackBar(SnackBar(
      print('Could not save Defaulter');
      // ));
    }else{
      print('Successfully saved defaulter');
      Navigator.push(context, MaterialPageRoute(builder: (context)=>myMain()));
    }
  }

  Future<List<FacilityModel>> getFacilities(filter) async {
    var response = await http.post(
        Uri.parse(globals.url.toString() + "getFacilities"));

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
    String serviceDate = "";

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
                onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (context)=>CompleteDefaulters())),
              )),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => Register()));
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
                    .map((data) => Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onTap: () {
                              print(data.names);
                            },
                            child: Column(
                                crossAxisAlignment:CrossAxisAlignment.start,
                                children: [
                                  Text('ID = ' + data.ID.toString(),
                                      style: TextStyle(fontSize: 14)),
                                  Text('Name = ' + data.names,
                                      style: TextStyle(fontSize: 14)),
                                  // Text('Phone Number = ' +data.contacts,style: TextStyle(fontSize: 21))),
                                  Text('Service Defaulted = ' +data.serviceDefaulted,style: TextStyle(fontSize: 14)),
                                  Text('Village = ' + data.village,style: TextStyle(fontSize: 14)),
                                  Text('Guardian = ' + data.guardian,style: TextStyle(fontSize: 14)),
                                  Text('CHV Name = ' + data.chvName,style: TextStyle(fontSize: 14)),
                                  SizedBox(height: 10.0),
                                  Text('Has the Patient been Contacted',
                                      style: TextStyle(fontSize: 14,
                                          color: Colors.greenAccent,
                                          fontWeight:FontWeight.bold)),
                                  SizedBox(height:5.0),
                                  Form(
                                      key:formKey,
                                      child: Column(
                                          children:[
                                            SizedBox(height:10.0),
                                            Visibility(
                                              maintainAnimation: true,
                                              maintainState: true,
                                              visible: true,
                                              child:Column(
                                                children: [
                                                  DropdownSearch<FacilityModel>(
                                                    maxHeight: 300,
                                                    onFind:(filter)=>getFacilities(filter),
                                                    dropdownSearchDecoration: InputDecoration(
                                                      labelText: "Facility patient received service",
                                                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                                      border: OutlineInputBorder(),
                                                    ),
                                                    onChanged: (value){
                                                      mflcode=value!.mflcode.toString();
                                                      serviceLocation=value.facilityname.toString();
                                                    },
                                                    showSearchBox: true,
                                                  ),
                                                  SizedBox(height: 10.0),
                                                  TextFormField(
                                                    controller: serviceOffered,
                                                    decoration: InputDecoration(
                                                      hintText: 'Services Offered',
                                                      // suffixIcon: Icon(Icons.email),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.0),
                                                  TextFormField(
                                                    controller: hwRecommendation,
                                                    decoration: InputDecoration(
                                                      hintText: 'Health Worker Recommendation',
                                                      // suffixIcon: Icon(Icons.email),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.0),
                                                  FormBuilderDateTimePicker(
                                                    name: 'serviceDate',
                                                     onChanged: (value){
                                                      serviceDate=value.toString();
                                                      print(value.toString());
                                                     },
                                                    inputType: InputType.date,
                                                    format: DateFormat('yyyy-MM-dd'),
                                                    lastDate:DateTime.now(),
                                                    decoration: InputDecoration(
                                                      labelText: 'Date received service',
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                      ),
                                                    ),
                                                    //initialTime: TimeOfDay(hour: 8, minute: 0),
                                                     //initialValue: DateTime.now(),
                                                     enabled: true,

                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height:5.0),
                                            Visibility(
                                              maintainAnimation: true,
                                              maintainState: true,
                                              visible: referToVisible,
                                              child: DropdownSearch<FacilityModel>(
                                                // items: [
                                                //   FacilityModel(facilityname: "Offline name1", mflcode: 999),
                                                //   FacilityModel(facilityname: "Offline name2", mflcode: 101)
                                                // ],
                                                maxHeight: 300,
                                                onFind:(filter)=>getFacilities(filter),
                                                dropdownSearchDecoration: InputDecoration(
                                                  labelText: "Refer patient to Facility",
                                                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                                  border: OutlineInputBorder(),
                                                ),
                                                onChanged: (value){
                                                  mflcode=value!.mflcode.toString();
                                                  facility=value.facilityname.toString();
                                                },
                                                showSearchBox: true,
                                              ),
                                            ),
                                            SizedBox(height: 10.0),
                                            Container(
                                              child:ElevatedButton(
                                                child: Text('Save'),
                                                style: ElevatedButton.styleFrom(
                                                    primary: Colors.indigo,
                                                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                                    textStyle: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white
                                                    )),
                                                onPressed: (){
                                                  this.submit();

                                                },
                                              ),
                                            )
                                          ])),
                                ])),
                      )]))
                    .toList(),
              );
            },
          ),
        ));
  }
}


