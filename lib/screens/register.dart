import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mpower/screens/defaulters.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'package:provider/provider.dart';
import 'package:mpower/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:mpower/screens/dashboard.dart';

class Register extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // String _myActivity;
  // String _myActivityResult;
  TextEditingController names = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController sex = TextEditingController();
  TextEditingController village = TextEditingController();
  TextEditingController guardian = TextEditingController();
  TextEditingController contacts = TextEditingController();
  TextEditingController chvName = TextEditingController();


  final formKey =new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // _myActivity = '';
    // _myActivityResult = '';
  }

  Future registerDefaulter()async {
    String url = globals.url.toString() + "registerDefaulter";
    var response = await http.post(Uri.parse(url), body: {
      "names": names.text,
      "age": age.text,
      "sex": sex.text,
      "serviceDefaulted": globals.serviceDefaulted,
      "village": village.text,
      "guardian": guardian.text,
      "contacts": contacts.text,
      "chvName": chvName.text,
    });

    var data=jsonDecode(response.body);
    if(data=="Error"){
      // Scaffold.of(context).showSnackBar(SnackBar(
        print('Could not save Defaulter');
      // ));
    }else{
      print('Successfully saved defaulter');
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Defaulters()));
    }
  }

  submit(){
    // First validate form.
    var form = formKey.currentState;
 //  if (form.validate()) {
     // form.save();
     // setState(() {
     //   _myActivityResult = _myActivity;
     // });

      this.registerDefaulter();

      // print('Printing the login data.');
      // print('Mobile: ${_data.username}');
      // print('Password: ${_data.password}');

   // }
  }

 // @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;

    return MaterialApp(
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: secondaryColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.white),
          canvasColor: secondaryColor,
        ),
     home:Scaffold(
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
          child:Form(
            key:formKey,

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
                        Text('Defaulter Registration',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  TextFormField(
                    controller: names,
                    decoration: InputDecoration(
                      hintText: 'Names',
                      // suffixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Patient Names';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0,),
                  TextFormField(
                    obscureText: false,
                    controller: age,
                    decoration: InputDecoration(
                      hintText: 'Age',
                      // suffixIcon: Icon(Icons.visibility_off),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Patients Age';
                        }
                        return null;
                  },
                  ),
                  SizedBox(height: 10.0,),
                  DropdownSearch(
                    items: [
                      "Male",
                      "Female"
                    ],
                    mode: Mode.MENU,
                    dropdownSearchDecoration: InputDecoration(
                      hintText: "Sex",
                      labelText: "Sex",
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value){
                      // gathering.text=value.toString();
                    },
                  ),
                  // TextFormField(
                  //   obscureText: false,
                  //   controller: sex,
                  //   decoration: InputDecoration(
                  //     hintText: 'Sex',
                  //     // suffixIcon: Icon(Icons.visibility_off),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(10.0),
                  //     ),
                  //   ),
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please enter Patients Gender(Male or Female)';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  SizedBox(height: 10.0,),
                  DropdownSearch(
                      items: [
                        "VitaminA",
                        "Dewarming",
                        "Immunization",
                        "Growth Monitoring",
                        "ANC"
                      ],
                      mode: Mode.MENU,
                      dropdownSearchDecoration: InputDecoration(
                        hintText: "Please Select Service Defaulted",
                        labelText: "Please Select Service Defaulted",
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value){
                        globals.serviceDefaulted=value.toString();
                      },
                    ),
                  SizedBox(height: 10.0,),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the Village from';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0,),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Patients Guardian';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0,),
                  TextFormField(
                    obscureText: false,
                    controller: contacts,
                    decoration: InputDecoration(
                      hintText: 'Contacts',
                      // suffixIcon: Icon(Icons.visibility_off),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Patients contacts(mobile No)';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0,),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please CHVs Names';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height:20.0),
                  ElevatedButton(
                    child: Text('REGISTER'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.indigo,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        )),
                    onPressed: (){
                      print(names.text);
                      print(chvName.text);
                      this.submit();
                    },
                  ),
                  SizedBox(height:20.0),
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

