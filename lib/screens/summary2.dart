import 'package:flutter/material.dart';
import 'package:mpower/database.dart';
import 'dart:convert';
import 'package:mpower/screens/register.dart';
import 'package:mpower/screens/globals.dart' as globals;
import 'package:mpower/screens/defaulters.dart';
import 'package:mpower/screens/completeDefaulters.dart';


// import 'package:mpower/screens/awareness_home.dart';

class Summary2 extends StatefulWidget {
  const Summary2({Key? key}) : super(key: key);

  @override
  State<Summary2> createState() => _Summary2State();
}

class _Summary2State extends State<Summary2> {
  List<Map<String, dynamic>> _records = [];
  int totalRecords=0;

  void _getEnrollments() async{
    final data=await DBProvider.countAwareness();

    setState(() {
      _records=data;
      totalRecords=_records.length;
      //print(jsonEncode(_records));
    });
  }

  @override
  void initState() {
    super.initState();
    _getEnrollments();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // padding: EdgeInsets.all(10),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Visibility(
        maintainAnimation: true,
        maintainState: true,
        visible: globals.CU,
         child:Row(
            children: [
              Flexible(
                child: Text("Defaulter Tracing/Tracking List",
                  style:TextStyle(fontSize: 16,fontWeight:FontWeight.bold,color: Colors.greenAccent),
                ),
              ),
              Flexible(
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => Defaulters()));
                    print(globals.loggedUser.toString());
                  },
                  child: const Icon(Icons.add),
                  backgroundColor: Colors.green,
                  mini: true,
                ),),
            ],
          ),
        ),
          SizedBox(height: 10.0,),
          Visibility(
            maintainAnimation: true,
            maintainState: true,
            visible: globals.healthWorker,
            child:Row(
              children: [
                Flexible(
                  child: Text("Defaulter Defaulters sent to You",
                    style:TextStyle(fontSize: 16,fontWeight:FontWeight.bold,color: Colors.greenAccent),
                  ),
                ),
                Flexible(
                  child:    FloatingActionButton(
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => CompleteDefaulters()));
                      print(globals.loggedUser.toString());
                    },
                    child: const Icon(Icons.add),
                    backgroundColor: Colors.green,
                    mini: true,
                  ),),
              ],
            ),
    ),
          SizedBox(height: 10.0,),
          Padding(
            padding:EdgeInsets.symmetric(horizontal:1.0),
            child:Container(
                height:3.0,
                width:double.infinity,
                color:Colors.blue),),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child:Text("Total Immunization",
                  style:TextStyle(fontSize: 16,fontWeight:FontWeight.bold,color: Color(4282547648)),
                ),
                ),
              Flexible(
                  child: Text(" : "+globals.totalMaleDiabetes,
                style:TextStyle(fontSize: 16,fontWeight:FontWeight.bold ,color: Colors.yellow),
              ))
            ],
          ),
          Row(
            children: [
              Flexible(
                child:Text("Vitamin A",
                  style:TextStyle(fontSize: 16,fontWeight:FontWeight.bold,color: Color(4282547648)),
                ),
              ),
              Flexible(
                  child: Text(" : "+globals.totalMaleHypertension,
                    style:TextStyle(fontSize: 16,fontWeight:FontWeight.bold ,color: Colors.yellow),
                  ))
            ],
          ),

          Row(
            children: [
              Flexible(
                child:Text("De-worming:",
                  style:TextStyle(fontSize: 16,fontWeight:FontWeight.bold,color: Color(4282547648)),
                ),
              ),
              Flexible(
                  child: Text(" : "+globals.totalMaleAnaemia,
                    style:TextStyle(fontSize: 16,fontWeight:FontWeight.bold ,color: Colors.yellow),
                  ))
            ],
          ),
          Row(
            children: [
              Flexible(
                child:Text("Growth Monitoring",
                  style:TextStyle(fontSize: 16,fontWeight:FontWeight.bold,color: Color(4282547648)),
                ),
              ),
              Flexible(
                  child: Text(" : "+globals.totalMaleEpilepsy,
                    style:TextStyle(fontSize: 16,fontWeight:FontWeight.bold ,color: Colors.yellow),
                  ))
            ],
          ),
          Row(
            children: [
              Flexible(
                child:Text("ANC Mothers",
                  style:TextStyle(fontSize: 16,fontWeight:FontWeight.bold,color: Color(4282547648)),
                ),
              ),
              Flexible(
                  child: Text(" : "+globals.totalMaleDiabetes,
                    style:TextStyle(fontSize: 16,fontWeight:FontWeight.bold ,color: Colors.yellow),
                  ))
            ],
          ),

        ],
      ),
    );

  }
}