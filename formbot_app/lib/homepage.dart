import 'package:flutter/material.dart';
import './conversation.dart';

class Homepage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
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
          SizedBox(height: 200),
          SizedBox(
            width: 230,
            child: RaisedButton(
              color: Colors.blue,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Conversation()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Begin Conversation',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 230,
            child: RaisedButton(
              onPressed: () {},
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
            child: RaisedButton(
              onPressed: () {},
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
            child: RaisedButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Help',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          SizedBox(height: 190),
          Container(
            // margin: EdgeInsets.only(top: 100),
            padding: const EdgeInsets.all(20.0),
            alignment: Alignment.bottomCenter,
            child: Text(
                """This software is free to use by anyone. It comes with no warranties and is provided solely "AS-IS". It may contain significant buts, or may not even perform the intended tasks, or fail to be fit for any purpose. University of Mary is not responsible for any shortcomings and the user is solely responsible for the use.
                  """),
          )
        ]),
      ),
    );
  }
}
