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
          ModalRoute.withName("/page2")
      );
      return false; // return true if the route to be popped
    }

    // new WillPopScope(child: new Scaffold(), 
    // onWillPop: _willPopCallback);

    return new Scaffold(
      appBar: AppBar(
        title: Text("Help"),
      ),
      endDrawer: UnauthDrawer(),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Help"
            ),
            ElevatedButton(
              key: Key('help_back_btn'),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
            ),
          ]
        )
      )
    );
  }
}

