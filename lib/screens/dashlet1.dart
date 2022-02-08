import 'package:flutter/material.dart';
import 'package:mpower/screens/globals.dart' as globals;


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome back "+globals.loggedUser,
            style:TextStyle(fontSize: 16,fontWeight:FontWeight.bold ,color: Colors.greenAccent),
          ),
          Text("You are logged in to ",
          style:TextStyle(fontSize: 16,fontWeight:FontWeight.bold,color: Colors.greenAccent),
          ),
          Text( globals.facility +"  as a "+ globals.chw,
          style:TextStyle(fontSize: 16,fontWeight:FontWeight.bold,color: Colors.lightGreenAccent),
          ),
          Padding(
            padding:EdgeInsets.symmetric(horizontal:1.0),
            child:Container(
              height:3.0,
              width:double.infinity,
              color:Colors.blue),),
          SizedBox(height: 10.0,),
          Text("PENDING TASKS: 0",
            style:TextStyle(fontSize: 16,fontWeight:FontWeight.bold,color: Colors.white),
          ),
          ],
      ),
    );

  }
}