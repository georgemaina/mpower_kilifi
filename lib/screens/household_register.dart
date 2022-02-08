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
import 'package:mpower/screens/dashboard.dart';

class HouseholdRegister extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);

  @override
  _HouseholdRegisterState createState() => _HouseholdRegisterState();
}

class _HouseholdRegisterState extends State<HouseholdRegister> {
  // String _myActivity;
  // String _myActivityResult;
  TextEditingController names = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController sex = TextEditingController();
  TextEditingController spouseContact = TextEditingController();
  TextEditingController spouse = TextEditingController();
  TextEditingController contacts = TextEditingController();
  TextEditingController chvName = TextEditingController();
  TextEditingController deliveryDate = TextEditingController();
  TextEditingController birthweight = TextEditingController();
  TextEditingController othersContact = TextEditingController();
  TextEditingController notMarried = TextEditingController();
  String delivered="Yes";
  bool showdeliveryOptions=false;
  bool kmc=false;
  bool isMarried=false;
  bool isOther=false;


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
      "village": spouse.text,
      "guardian": spouseContact.text,
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
                    controller: names,
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
                    controller: age,
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
                    controller: age,
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
                    controller: age,
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
                        TextFormField(
                          controller: deliveryDate,
                          decoration: InputDecoration(
                            hintText: 'Delivery Date',
                            // suffixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
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
                          controller: deliveryDate,
                          decoration: InputDecoration(
                            hintText: 'Delivery Date',
                            // suffixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(height:10.0),
                        FormBuilderRadioGroup(
                            name: 'Sex',
                            options: [
                              FormBuilderFieldOption(value: 'Male'),
                              FormBuilderFieldOption(value: 'Female'),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Sex',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onChanged: (val) {

                            }
                        ),
                        SizedBox(height:10.0),
                        TextFormField(
                            controller: birthweight,
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
                          controller: spouse,
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
                  Visibility(
                    maintainAnimation: true,
                    maintainState: true,
                    visible: isOther,
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: notMarried,
                          decoration: InputDecoration(
                            hintText: 'Not Married/Other',
                            // suffixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(height:10.0),
                        TextFormField(
                          controller: othersContact,
                          decoration: InputDecoration(
                            hintText: 'Others Contact',
                            // suffixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
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

