// import 'package:flutter/material.dart';
//
// class Defaulters extends StatefulWidget {
//   const Defaulters({Key? key}) : super(key: key);
//
//   @override
//   _DefaultersState createState() => _DefaultersState();
// }
//
// class _DefaultersState extends State<Defaulters> {
//   final items = List<String>.generate(10000, (i) => "Item $i");
//   final europeanCountries = ['Albania', 'Andorra', 'Armenia', 'Austria',
//     'Azerbaijan', 'Belarus', 'Belgium', 'Bosnia and Herzegovina', 'Bulgaria',
//     'Croatia', 'Cyprus', 'Czech Republic', 'Denmark', 'Estonia', 'Finland',
//     'France', 'Georgia', 'Germany', 'Greece', 'Hungary', 'Iceland', 'Ireland',
//     'Italy', 'Kazakhstan', 'Kosovo', 'Latvia', 'Liechtenstein', 'Lithuania',
//     'Luxembourg', 'Macedonia', 'Malta', 'Moldova', 'Monaco', 'Montenegro',
//     'Netherlands', 'Norway', 'Poland', 'Portugal', 'Romania', 'Russia',
//     'San Marino', 'Serbia', 'Slovakia', 'Slovenia', 'Spain', 'Sweden',
//     'Switzerland', 'Turkey', 'Ukraine', 'United Kingdom', 'Vatican City'];
//   final icons = [Icons.ac_unit, Icons.access_alarm, Icons.access_time];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('mPower: Defaulters List'),
//         ),
//       body: Padding(
//           padding: EdgeInsets.all(10),
//         child: ListView.builder(
//           itemCount: europeanCountries.length,
//           itemBuilder: (context, index) {
//             return Card(
//                 child:ListTile(
//                   onTap: () {
//                     setState(() {
//                       europeanCountries.add('List' + (europeanCountries.length+1).toString());
//                       // subtitles.add('Here is list' + (europeanCountries.length+1).toString() + ' subtitle');
//                       icons.add(Icons.zoom_out_sharp);
//                     });
//                     Scaffold.of(context).showSnackBar(SnackBar(
//                       content: Text(europeanCountries[index] + ' pressed!'),
//                     ));
//                   },
//                   title: Text(europeanCountries[index]),
//                   trailing: Icon(Icons.star),
//                   subtitle: Text(europeanCountries[index]),
//                 ));
//           },
//         ),
//       ),
//     );
//   }
// }
