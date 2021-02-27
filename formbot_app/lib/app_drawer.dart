import 'package:flutter/material.dart';

Widget authDrawer() {
  return Drawer(
    child: Column(
      children: <Widget>[
        DrawerHeader(
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage("images/logo.png"),
                    fit: BoxFit.contain)),
          ),
        ),
        /*ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {},
          ),*/
        ListTile(
          leading: Icon(Icons.chat),
          title: Text('Begin Conversation'),
          onTap: () => {
            //Navigator.of(context).pop()
          },
        ),
        ListTile(
          leading: Icon(Icons.receipt),
          title: Text('View Reports'),
          onTap: () => {
            //Navigator.of(context).pop()
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () => {
            //Navigator.of(context).pop()
          },
        ),
        ListTile(
          leading: Icon(Icons.help_outline),
          title: Text('Help'),
          onTap: () => {
            //Navigator.of(context).pop()
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Log Out'),
          onTap: () => {
            //Navigator.of(context).pop()
          },
        ),
      ],
    ),
  );
}

Widget unauthDrawer(){
  return Drawer(
    child: Column(
      children: <Widget>[
        DrawerHeader(
          child: Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
                image: DecorationImage(
                    image: AssetImage("images/logo.png"),
                    fit: BoxFit.contain)),
          ),
        ),
        /*ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () => {},
        ),*/
        ListTile(
          leading: Icon(Icons.login),
          title: Text('Log In'),
          onTap: () => {
            //Navigator.of(context).pop()
          },
        ),
        ListTile(
          leading: Icon(Icons.help_outline),
          title: Text('Help'),
          onTap: () => {
            //Navigator.of(context).pop()
          },
        ),
      ],
    ),
  );
}
