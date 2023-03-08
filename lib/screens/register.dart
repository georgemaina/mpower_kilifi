import 'dart:convert';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mpower_achap/database.dart';
import 'package:mpower_achap/screens/defaulters.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'package:mpower_achap/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Register extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // String _myActivity;
  // String _myActivityResult;
  TextEditingController names = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController sex = TextEditingController();
  TextEditingController village = TextEditingController();
  TextEditingController guardian = TextEditingController();
  TextEditingController contacts = TextEditingController();
  TextEditingController chvName = TextEditingController();

  final formKey = new GlobalKey<FormState>();

  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd H:m:s');
  final String formatted = formatter.format(now);

  @override
  void initState() {
    super.initState();
    // _myActivity = '';
    // _myActivityResult = '';
  }

  Future registerDefaulter2() async {
    var id = DBProvider.enrollDefaulter(
        globals.names,
        globals.dob,
        globals.sex,
        globals.serviceDefaulted,
        globals.village,
        globals.guardian,
        globals.contacts,
        globals.chvName,
        "",
        globals.contacted,
        globals.reasonNotContacted,
        globals.isDefaulter,
        globals.serviceLocation,
        globals.serviceDate,
        globals.referTo,
        globals.dateContacted);

    print(id);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Defaulters()));
  }

  Future registerDefaulter() async {
    String url = globals.url.toString() + "registerDefaulter";
    var response = await http.post(Uri.parse(url), body: {
      "names": names.text,
      "dob": dob.text,
      "sex": sex.text,
      "serviceDefaulted": globals.serviceDefaulted,
      "village": village.text,
      "guardian": guardian.text,
      "contacts": contacts.text,
      "chvName": chvName.text,
    });

    var data = jsonDecode(response.body);
    if (data == "Error") {
      // Scaffold.of(context).showSnackBar(SnackBar(
      print('Could not save Defaulter');
      // ));
    } else {
      print('Successfully saved defaulter');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Defaulters()));
    }
  }

  submit() {
    // First validate form.
    var form = formKey.currentState;

    this.registerDefaulter2();
  }

  // @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: secondaryColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Defaulters Register'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: Container(
          height: height,
          width: width,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Defaulter Registration',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    controller: names,
                    decoration: InputDecoration(
                      hintText: 'Names',
                      // suffixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        globals.names = val.toString();
                        print('Client Names=' + val.toString());
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Client Names';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  FormBuilderDateTimePicker(
                    name: 'dob',
                    onChanged: (value) {
                      globals.dob = value.toString();
                      print(value.toString());
                    },
                    inputType: InputType.date,
                    format: DateFormat('yyyy-MM-dd'),
                    lastDate: DateTime.now(),
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    //initialTime: TimeOfDay(hour: 8, minute: 0),
                    //initialValue: DateTime.now(),
                    enabled: true,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  DropdownSearch(
                    items: ["Male", "Female"],
                    //mode: Mode.MENU,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: "Sex",
                        labelText: "Sex",
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        globals.sex = val.toString();
                        print('Sex=' + val.toString());
                      });
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  DropdownSearch(
                    items: [
                      "VitaminA",
                      "Dewarming",
                      "Immunization",
                      "Growth Monitoring",
                      "ANC"
                    ],
                    //mode: Mode.MENU,
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        hintText: "Please Select Service Defaulted",
                        labelText: "Please Select Service Defaulted",
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    onChanged: (value) {
                      globals.serviceDefaulted = value.toString();
                    },
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter the Service defaulted';
                        }
                        return null;
                      },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    obscureText: false,
                    controller: village,
                    decoration: InputDecoration(
                      hintText: 'Village',
                      // suffixIcon: Icon(Icons.visibility_off),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        globals.village = val.toString();
                        print('Village=' + val.toString());
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the Village from';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    obscureText: false,
                    controller: guardian,
                    decoration: InputDecoration(
                      hintText: 'Mother/Guardian',
                      // suffixIcon: Icon(Icons.visibility_off),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        globals.guardian = val.toString();
                        print('Guardian=' + val.toString());
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Patients Guardian';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    obscureText: false,
                    controller: contacts,
                    decoration: InputDecoration(
                      hintText: 'Guardian Contacts',
                      // suffixIcon: Icon(Icons.visibility_off),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        globals.contacts = val.toString();
                        print('Contact=' + val.toString());
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Patients contacts(mobile No)';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    obscureText: false,
                    controller: chvName,
                    decoration: InputDecoration(
                      hintText: 'CHV Name',
                      // suffixIcon: Icon(Icons.visibility_off),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        globals.chvName = val.toString();
                        print('CHV Name=' + val.toString());
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please CHVs Names';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    child: Text('REGISTER'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.indigo,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    onPressed: () {
                      this.submit();
                    },
                  ),
                  SizedBox(height: 20.0),
                  // Container(
                  //   padding: EdgeInsets.all(16),
                  //   child: Text("_myActivityResult"),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
