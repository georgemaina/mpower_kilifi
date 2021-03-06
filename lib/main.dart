import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'screens/globals.dart' as globals;
import 'package:mpower/main.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:mpower/models/users.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:mpower/controllers/MenuController.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mpower/constants.dart';
import 'package:mpower/screens/main_screen.dart';
import 'package:mpower/models/facilities.dart';


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) {
        if (host == globals.ip) {
          return true;
        } else {
          return false;
        }
      });
  }
}

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

// import 'package:flutter/material.dart';
class myMain extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CHAK mpower App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuController(),
          ),
        ],
        child: MainScreen(),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _LoginData {
  String username = '';
  String password = '';
}


class _State extends State<MyApp> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  // TextEditingController location = TextEditingController();
  String facility = "";
  String mflcode = "";
  String chuNames = "";

  bool chu=false;
  bool facilities=false;

  String _chosenValue="";
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    print(await Geolocator.getCurrentPosition());
    return await Geolocator.getCurrentPosition();
  }

  bool _isObscure=true;

  Future<Users> login() async{
    var value;
    String url=globals.url.toString() + "login";

    var response=await http.post(Uri.parse(url),body: {
      "username":username.text,
      "password":password.text,
      "userGroup":"Admin",
    });

    var data=jsonDecode(response.body);
    String user=username.text;
    if(data=="Error"){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid Username and Password.'),
        ),
      );
      value='Error';
    }else{
      globals.isLoggedIn = true;
      globals.loggedUser =username.text;
      value=new Users.fromJson(data);
      globals.loggedUser=value.names;
      globals.mflcode=mflcode;
      globals.facility=facility;
      globals.phone=username.text;
      print(facility);
      // print(location.text);
      print(globals.chw);
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>myMain())
      );
      if(globals.chw=='Health Facility'){
        globals.healthWorker=true;

        globals.CU=false;
      }
      if(globals.chw=='CU'){
        globals.CU =true;
        globals.healthWorker=false;
      }
      globals.isLoggedIn = true;
    }
    return value;
  }


  final formKey =new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // _myActivity = '';
    // _myActivityResult = '';
  }

  _LoginData _data = new _LoginData();


  // Map<String, dynamic> formData;
  void submit(){
    // First validate form.
    if (this.formKey.currentState!.validate()) {
      _determinePosition();
      this.login();
      formKey.currentState!.save(); // Save our form now.

      // print('Printing the login data.');
      // print('Mobile: ${_data.username}');
      // print('Password: ${_data.password}');

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

  Future<List<ChuModel>> getChu(filter) async {
    var response = await http.post(
        Uri.parse(globals.url.toString() + "getChu"));

    final data = json.decode(response.body);
    //print(data);
    if (data != null) {
      //print(data.length);
      return ChuModel.fromJsonList(data);
    }

    return [];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('mPower'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child:Form(
                key:formKey,
                child: ListView(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'CHAK mPower',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 30),
                        )),
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(fontSize: 20),
                        )),
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                      child: TextField(
                        controller: username,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Mobile Phone Number',
                        ),
                      ),
                    ),
                    SizedBox(height:5.0),
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                      child: TextField(
                        obscureText: _isObscure,
                        controller: password,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure?Icons.visibility:Icons.visibility_off,
                              ),
                              onPressed: (){
                                setState(() {
                                  _isObscure=!_isObscure;
                                });
                              },
                            )
                        ),
                      ),
                    ),
                    SizedBox(height:10.0),
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: DropdownSearch(
                        items: [
                          "CU",
                          "Health Facility"
                        ],
                        mode: Mode.MENU,
                        dropdownSearchDecoration: InputDecoration(
                          hintText: "Location Type",
                          labelText: "Location Type",
                          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value){
                          setState(() {
                            globals.chw=value.toString();
                            if(value=="CU"){
                              chu=true;
                              facilities=false;
                            }
                            if(value=="Health Facility"){
                              facilities=true;
                              chu=false;
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(height:10.0),
                    // SizedBox(height:10.0),
                    Visibility(
                        maintainAnimation: true,
                        maintainState: true,
                        visible: chu,
                        child:  Container(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: DropdownSearch<ChuModel>(
                            maxHeight: 300,
                            onFind:(filter)=>getChu(filter),
                            dropdownSearchDecoration: InputDecoration(
                              labelText: " Community Health Units",
                              contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value){
                              // ID=value!.ID.toString();
                              chuNames=value!.chuNames.toString();
                            },
                            showSearchBox: true,
                          ),
                        )
                    ),
                    // SizedBox(height:10.0),
                    Visibility(
                        maintainAnimation: true,
                        maintainState: true,
                        visible: facilities,
                        child:  Container(
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: DropdownSearch<FacilityModel>(
                            maxHeight: 300,
                            onFind:(filter)=>getFacilities(filter),
                            dropdownSearchDecoration: InputDecoration(
                              labelText: "Link Facility ",
                              contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value){
                              mflcode=value!.mflcode.toString();
                              facility=value.facilityname.toString();
                            },
                            showSearchBox: true,
                          ),
                        )
                    ),
                    SizedBox(height:10.0),
                    // Container(
                    //   padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                    //   child: TextField(
                    //     controller: location,
                    //     decoration: InputDecoration(
                    //       border: OutlineInputBorder(),
                    //       labelText: 'Location',
                    //     ),
                    //   ),
                    // ),
                    // // FlatButton(
                    // //   onPressed: (){
                    // //     //forgot password screen
                    // //   },
                    // //   // textColor: Colors.blue,
                    // //   child: Text('Forgot Password'),
                    // // ),
                    // SizedBox(height:10.0),
                    Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.blue,
                          child: Text('LOGIN'),
                          onPressed: () {
                            print(username.text);
                            print(password.text);
                            this.submit();
                          },
                        )),
                    // Container(
                    //     child: Row(
                    //       children: <Widget>[
                    //         Text('Does not have account?'),
                    //         FlatButton(
                    //           textColor: Colors.blue,
                    //           child: Text(
                    //             'Sign in',
                    //             style: TextStyle(fontSize: 20),
                    //           ),
                    //           onPressed: () {
                    //             //signup screen
                    //           },
                    //         )
                    //       ],
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //     ))
                  ],
                ))));
  }
}
