import 'package:mpower_achap/controllers/MenuController.dart';
import 'package:mpower_achap/responsive.dart';
import 'package:mpower_achap/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'side_menu.dart';

class MainScreen extends StatelessWidget {
  static const String kMessage = '"Talk less. Smile more." - A. Burr';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // key: context.read<MenuController>().scaffoldKey,
      drawer: MyMenuBar(message: kMessage),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: MyMenuBar(message: kMessage),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: DashboardScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
