import 'package:flutter/material.dart';

class Reports extends StatefulWidget {
  static const String routeName = 'reports';

  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: <Widget>[
              Image.asset(
                //'assets/images/logo.png',
                'assets/images/cover-icon.png',
                height: 55,
              ),
              SizedBox(
                width: 30,
              ),
              Text(''),
            ],
          ),
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: Text(
                'Sign Out',
                style: TextStyle(color: Colors.white),
              ),
            )
          ]),
      body: Center(
        child: Column(children: <Widget>[

        ]
        ),
      ),
    );
  }
}