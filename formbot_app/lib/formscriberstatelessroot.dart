/*This software is free to use by anyone. It comes with no warranties and is provided solely "AS-IS".
It may contain significant bugs, or may not even perform the intended tasks, or fail to be fit for any purpose.
University of Maryland is not responsible for any shortcomings and the user is solely responsible for the use.*/

import 'package:flutter/material.dart';
import 'routes/routes.dart';
import 'loginpage.dart';
import 'homepage.dart';
import 'chat.dart';
import 'help.dart';
class FormScriberStatelessRoot extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Scriber',

      // This is the theme of the application.
      theme: ThemeData(
        primarySwatch: Colors.blue,

        // This makes the visual density adapt to any platform.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(title: 'Form Scriber'),

      //Navigator routes to other pages.
       routes: {
         Routes.help: (context) => HelpPage(),
         Routes.home: (context) => HomePage(),
         Routes.conversation: (context) => Chat(),
         Routes.login:(context) => LoginPage(),
       },
    );
  }
}