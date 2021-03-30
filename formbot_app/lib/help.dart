/*This software is free to use by anyone. It comes with no warranties and is provided solely "AS-IS".
It may contain significant bugs, or may not even perform the intended tasks, or fail to be fit for any purpose.
University of Maryland is not responsible for any shortcomings and the user is solely responsible for the use.*/

import 'package:flutter/material.dart';

import 'widgets/app_drawer.dart';

class HelpPage extends StatelessWidget {
  static const String routeName = 'help';

  @override
  Widget build(BuildContext context) {

    Future<bool> _willPopCallback() async {
      Navigator.pushNamedAndRemoveUntil(
          context,
          routeName,
          ModalRoute.withName("/")
      );
      return false; // return true if the route to be popped
    }

    new WillPopScope(child: new Scaffold(), onWillPop: _willPopCallback);

    return new Scaffold(
      appBar: AppBar(
        title: Text("Help"),
        backgroundColor: Color(0xFF007fbc),

      ),
      endDrawer: AuthDrawer(),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Help"
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
              style: ElevatedButton.styleFrom(primary: Color(0xFF007fbc)),
            ),
          ]
        )
      )
    );
  }
}

