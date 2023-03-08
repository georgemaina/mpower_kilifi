import 'package:flutter/material.dart';
import 'package:mpower_achap/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mpower_achap/screens/mappedList.dart';
import 'household_register.dart';

class MappingVisitType extends StatefulWidget {
  const MappingVisitType({Key? key}) : super(key: key);

  @override
  _MappingVisitTypeState createState() => _MappingVisitTypeState();
}

class _MappingVisitTypeState extends State<MappingVisitType> {
  @override
  Widget build(BuildContext context) {
    bool firstVisit=false;
    bool revisit=false;
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;


    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: secondaryColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: Scaffold(
        appBar: AppBar(
          title:Text("Household Mapping"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              // onPressed: () => Navigator.pop(context, false),
              onPressed: () => Navigator.pop(context, false),
            )
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
            child:Column(
              children: [
              SizedBox(height:20.0),
              FormBuilderRadioGroup(
                  name: 'visitType',
                  options: [
                    FormBuilderFieldOption(value: 'First Visit'),
                    FormBuilderFieldOption(value: 'Revisit'),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Type of Household Mapping',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      if(val=='First Visit'){
                         // firstVisit=true;
                         // revisit=false;
                        Navigator.push(context,MaterialPageRoute(builder: (context) => HouseholdRegister()));
                      }else{
                        // firstVisit=false;
                        // revisit=true;
                        Navigator.push(context,MaterialPageRoute(builder: (context) => MappedList()));
                      }
                      print(val.toString());
                    });
                  }
              ),
            ]
          ),
        ),
        )
      );
  }
}
