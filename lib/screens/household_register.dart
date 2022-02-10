import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mpower/screens/defaulters.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'package:provider/provider.dart';
import 'package:mpower/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import 'package:mpower/screens/dashboard.dart';

class HouseholdRegister extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);

  @override
  _HouseholdRegisterState createState() => _HouseholdRegisterState();
}

class _HouseholdRegisterState extends State<HouseholdRegister> {
  // String _myActivity;
  // String _myActivityResult;
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd H:m:s');
  final String strDate = formatter.format(now);

  // String dateContacted =strDate;
  TextEditingController mothersName = TextEditingController();
  TextEditingController chuName = TextEditingController();
  TextEditingController hhNo = TextEditingController();
  TextEditingController yearBirth = TextEditingController();
  // TextEditingController delivered = TextEditingController();
  TextEditingController dateDelivered = TextEditingController();
  String deliveryPlace ="";
  String sex ="";
  TextEditingController weightAtBirth = TextEditingController();
  String supportGroup = "";
  String married = "";
  TextEditingController spouseName = TextEditingController();
  TextEditingController spouseContact = TextEditingController();
  TextEditingController otherName = TextEditingController();
  TextEditingController otherContact = TextEditingController();

  String delivered="Yes";
  bool showdeliveryOptions=false;
  bool kmc=false;
  bool isMarried=false;
  bool isOther=false;
  String deliveryDate = "";


  final formKey =new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // _myActivity = '';
    // _myActivityResult = '';
  }

  Future registerHousehold()async {
    String url = globals.url.toString() + "registerHousehold";
    var response = await http.post(Uri.parse(url), body: {
      "dateContacted": strDate,
      "mothersName": mothersName.text,
      "chuName": chuName.text,
      "hhNo": hhNo.text,
      "dateDelivered": dateDelivered.text,
      "sex": sex,
      "weightAtBirth": weightAtBirth.text,
      "supportGroup": supportGroup,
      "married": married,
      "spouseName": spouseName,
      "spouseContact": spouseContact,
      "otherName": otherName,
      "otherContact": otherContact,
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

      this.registerHousehold();

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
        title: Text('Household Mapping'),
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
                  Text('Mother/Baby Registration',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold,color:Colors.greenAccent ),),
                  SizedBox(height: 10.0,),
                  TextFormField(
                    controller: mothersName,
                    decoration: InputDecoration(
                      hintText: 'mothers Names',
                      // suffixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Mothers Names';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0,),
                  TextFormField(
                    obscureText: false,
                    controller: chuName,
                    decoration: InputDecoration(
                      hintText: 'CHU Name',
                      // suffixIcon: Icon(Icons.visibility_off),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter CHUs Name';
                        }
                        return null;
                  },
                  ),
                  SizedBox(height: 10.0,),
                  TextFormField(
                    obscureText: false,
                    controller: hhNo,
                    decoration: InputDecoration(
                      hintText: 'HH No',
                      // suffixIcon: Icon(Icons.visibility_off),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter HH No';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0,),
                  TextFormField(
                    obscureText: false,
                    controller: yearBirth,
                    decoration: InputDecoration(
                      hintText: 'Year of Birth',
                      // suffixIcon: Icon(Icons.visibility_off),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the Year of birth';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height:10.0),
                  FormBuilderRadioGroup(
                      name: 'married',
                      options: [
                        FormBuilderFieldOption(value: 'Yes'),
                        FormBuilderFieldOption(value: 'No'),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Married',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          globals.sex = val.toString();
                          if(val=='Yes'){
                            isMarried=true;
                            isOther=false;
                          }else{
                            isOther=true;
                            isMarried=false;
                          }
                          print(val.toString());
                        });
                      }
                  ),
                  Visibility(
                    maintainAnimation: true,
                    maintainState: true,
                    visible: isMarried,
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: spouseName,
                          decoration: InputDecoration(
                            hintText: 'Spouse Name',
                            // suffixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(height:10.0),
                        TextFormField(
                          controller: spouseContact,
                          decoration: InputDecoration(
                            hintText: 'Spouse Contact',
                            // suffixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ],
                    ),),
                  SizedBox(height:10.0),
                  Visibility(
                    maintainAnimation: true,
                    maintainState: true,
                    visible: isOther,
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: otherName,
                          decoration: InputDecoration(
                            hintText: 'Next of Kin/Guardian',
                            // suffixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(height:10.0),
                        TextFormField(
                          controller: otherContact,
                          decoration: InputDecoration(
                            hintText: 'Contacts',
                            // suffixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ],
                    ),),
                  SizedBox(height:10.0),
                  FormBuilderRadioGroup(
                      name: 'contacted',
                      options: [
                        FormBuilderFieldOption(value: 'Yes'),
                        FormBuilderFieldOption(value: 'No'),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Delivered',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          globals.sex = val.toString();
                          if(val=='Yes'){
                            delivered="Yes";
                            showdeliveryOptions=true;
                          }else{
                            delivered="No";
                            showdeliveryOptions=false;
                          }
                          print(val.toString());
                        });
                      }
                  ),
                  SizedBox(height:10.0),
                  Visibility(
                    maintainAnimation: true,
                    maintainState: true,
                    visible: showdeliveryOptions,
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.0),
                        FormBuilderDateTimePicker(
                          name: 'deliveryDate',
                          onChanged: (value){
                            deliveryDate=value.toString();
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
                        SizedBox(height:10.0),
                        DropdownSearch(
                          items: [
                            "Home",
                            "Health Facility"
                          ],
                          mode: Mode.MENU,
                          dropdownSearchDecoration: InputDecoration(
                            hintText: "deliveryPlace",
                            labelText: "deliveryPlace",
                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value){
                            // gathering.text=value.toString();
                          },
                        ),
                        SizedBox(height:10.0),
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
                        SizedBox(height:10.0),
                        TextFormField(
                            controller: weightAtBirth,
                            decoration: InputDecoration(
                              hintText: 'Weight at Birth',
                              // suffixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onChanged: (val) {
                              if(int.parse(val)>2500){
                                kmc=true;
                              }else{
                                kmc=false;
                              }
                            }
                        ),
                      ],
                    ),),
                  SizedBox(height:10.0),
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
                      print(mothersName.text);
                      print(chuName.text);
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

