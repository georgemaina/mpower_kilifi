import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mpower_achap/database.dart';
import 'package:http/http.dart' as http;
import 'package:mpower_achap/screens/mappedList.dart';
import 'globals.dart' as globals;
import 'package:mpower_achap/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';

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
  String delivered = "";
  String dateDelivered = "";
  String deliveryPlace ="";
  String sex ="";
  TextEditingController weightAtBirth = TextEditingController();
  String supportGroup = "";
  String married = "";
  TextEditingController spouseName = TextEditingController();
  TextEditingController spouseContact = TextEditingController();
  TextEditingController otherName = TextEditingController();
  TextEditingController otherContact = TextEditingController();

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

  Future registerHousehold() async {
    var id = DBProvider.enrollHouseholds(
        globals.mothersName,
        globals.chuName,
        globals.hhNo,
        globals.yearBirth,
        globals.delivered,
        globals.dateDelivered,
        globals.deliveryPlace,
        globals.gender,
        globals.weightAtBirth,
        globals.supportGroup,
        globals.married,
        globals.spouseName,
        globals.spouseContact,
        globals.otherName,
        globals.otherContact);

    print(id);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MappedList()));
  }

  Future registerHousehold2()async {
    String url = globals.url.toString() + "registerHousehold";
    var response = await http.post(Uri.parse(url), body: {
      "dateContacted": strDate,
      "mothersName": mothersName.text,
      "chuName": chuName.text,
      "hhNo": hhNo.text,
      "yearBirth":yearBirth.text,
      "delivered":delivered,
      "dateDelivered": dateDelivered,
      "deliveryPlace":deliveryPlace,
      "sex": sex,
      "weightAtBirth": weightAtBirth.text,
      "supportGroup": supportGroup,
      "married": married,
      "spouseName": spouseName.text,
      "spouseContact": spouseContact.text,
      "otherName": otherName.text,
      "otherContact": otherContact.text,
    });

    var data=jsonDecode(response.body);
    if(data=="Error"){
      // Scaffold.of(context).showSnackBar(SnackBar(
        print('Could not save Defaulter');
      // ));
    }else{
      print('Successfully saved defaulter');
      Navigator.push(context, MaterialPageRoute(builder: (context)=>MappedList()));
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
                      hintText: 'Mothers Names',
                      labelText: 'Mothers Names',
                      // suffixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        globals.mothersName = val.toString();
                        print('Client Names=' + val.toString());
                      });
                    },
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
                      labelText: 'CHU Name',
                      // suffixIcon: Icon(Icons.visibility_off),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        globals.chuName = val.toString();
                        print('Client Names=' + val.toString());
                      });
                    },
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
                      labelText: 'HH No',
                      // suffixIcon: Icon(Icons.visibility_off),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        globals.hhNo = val.toString();
                        print('Client Names=' + val.toString());
                      });
                    },
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
                      labelText: 'Year of Birth',
                      // suffixIcon: Icon(Icons.visibility_off),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        globals.yearBirth = val.toString();
                        print('Client Names=' + val.toString());
                      });
                    },
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
                        hintText: 'Married',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          married = val.toString();
                          globals.married = val.toString();
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
                  SizedBox(height:10.0),
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
                            labelText: 'Spouse Name',
                            // suffixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              globals.spouseName = val.toString();
                              print('Client Names=' + val.toString());
                            });
                          },
                        ),
                        SizedBox(height:10.0),
                        TextFormField(
                          controller: spouseContact,
                          decoration: InputDecoration(
                            hintText: 'Spouse Contact',
                            labelText: 'Spouse Contact',
                            // suffixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              globals.spouseContact = val.toString();
                              print('Spouse Contacts=' + val.toString());
                            });
                          },
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
                            labelText: 'Next of Kin/Guardian',
                            // suffixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              globals.otherName = val.toString();
                              print('Next of Kin Names=' + val.toString());
                            });
                          },
                        ),
                        SizedBox(height:10.0),
                        TextFormField(
                          controller: otherContact,
                          decoration: InputDecoration(
                            hintText: 'Contacts',
                            labelText: 'Contacts',
                            // suffixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              globals.otherContact = val.toString();
                              print('Next of Kin Contacts=' + val.toString());
                            });
                          },
                        ),
                      ],
                    ),),
                  SizedBox(height:10.0),
                  FormBuilderRadioGroup(
                      name: 'delivered',
                      options: [
                        FormBuilderFieldOption(value: 'Yes'),
                        FormBuilderFieldOption(value: 'No'),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Delivered',
                        hintText: 'Delivered',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          globals.delivered = val.toString();
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
                            dateDelivered=value.toString();
                            globals.dateDelivered = value.toString();

                            print(value.toString());
                          },
                          inputType: InputType.date,
                          format: DateFormat('yyyy-MM-dd'),
                          lastDate:DateTime.now(),
                          decoration: InputDecoration(
                            labelText: 'Date Delivered',
                            hintText: 'Date Delivered',
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
                          //mode: Mode.MENU,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            hintText: "deliveryPlace",
                            labelText: "deliveryPlace",
                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                            border: OutlineInputBorder(),
                          ),
                          ),
                          onChanged: (value){
                            globals.deliveryPlace = value.toString();
                            deliveryPlace=value.toString();
                          },
                        ),
                        SizedBox(height:10.0),
                        DropdownSearch(
                          items: [
                            "Male",
                            "Female"
                          ],
                         // mode: Mode.MENU,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            hintText: "Sex",
                            labelText: "Sex",
                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                            border: OutlineInputBorder(),
                          ),
                          ),
                          onChanged: (value){
                            globals.gender = value.toString();
                            sex=value.toString();
                          },
                        ),
                        SizedBox(height:10.0),
                        TextFormField(
                            controller: weightAtBirth,
                            decoration: InputDecoration(
                              hintText: 'Weight at Birth',
                              labelText: 'Weight at Birth',
                              // suffixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onChanged: (val) {
                              globals.weightAtBirth = val.toString();
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

