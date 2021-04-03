/*This software is free to use by anyone. It comes with no warranties and is provided solely "AS-IS".
It may contain significant bugs, or may not even perform the intended tasks, or fail to be fit for any purpose.
University of Maryland is not responsible for any shortcomings and the user is solely responsible for the use.*/

import 'package:flutter/material.dart';
import 'widgets/app_drawer.dart';
import 'routes/routes.dart';

class HomePage extends StatelessWidget {
  static const String routeName = 'homepage';
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

    return Scaffold(
      key: Key('home'),
      appBar: AppBar(
        backgroundColor: Color(0xFF007fbc),
          title: Row(
            children: <Widget>[
              Image.asset(
                'assets/images/cover-icon.png',
                height: 55,
              ),
              SizedBox(
                width: 30,
              ),
              Text(''),
            ],
          ),
/*          actions: <Widget>[
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
          ]*/
      ),
      endDrawer: AuthDrawer(),

      body: Center(
        child: Column(
            children:
            <Widget>[
              SizedBox(height: 200),

              SizedBox(
                width: 230,
                child: ElevatedButton(
                     key: Key('begin_conversation'),
                 style: ElevatedButton.styleFrom(primary: Colors.blue),
                  onPressed: () => {Navigator.pushNamed(context, Routes.conversation)},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Begin Conversation',
                      //style: TextStyle(fontSize: 20),
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),

                  ),
                ),
              ),

              SizedBox(
                width: 230,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                  onPressed: ()  => {Navigator.pushNamed(context, Routes.reports)},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'View Reports',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: 230,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                  onPressed: ()  => {Navigator.pushNamed(context, Routes.settings)},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Settings',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: 230,
                child: ElevatedButton(
                      key: Key('helpFromDrawer'),
                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                  onPressed: () => {Navigator.pushNamed(context, Routes.help)},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Help',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 125),
              /*Container(
                // margin: EdgeInsets.only(top: 100),
                padding: const EdgeInsets.all(20.0),
                alignment: Alignment.bottomCenter,
                child: Text(
                    """This software is free to use by anyone. It comes with no warranties and is provided solely "AS-IS". It may contain significant bugs, or may not even perform the intended tasks, or fail to be fit for any purpose. University of Maryland is not responsible for any shortcomings and the user is solely responsible for the use.
                      """),
              )*/
            ]
        ),
      ),
    );
  }
}