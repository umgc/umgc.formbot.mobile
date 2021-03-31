
import 'package:flutter/material.dart';
import 'routes/routes.dart';
import 'signInPage.dart';
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
      home: SignInPage(title: 'Form Scriber'),

      //Navigator routes to other pages.
       routes: {
         Routes.help: (context) => HelpPage(),
         Routes.home: (context) => HomePage(),
         Routes.conversation: (context) => Chat(),
         Routes.signIn:(context) => SignInPage(),
       },
    );
  }
}