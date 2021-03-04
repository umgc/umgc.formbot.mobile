import 'package:flutter/material.dart';
import 'package:formbot_app/routes/routes.dart';

class AuthDrawer extends StatelessWidget{

  @override
  Widget build(BuildContext context)
  {
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
                      image: AssetImage("images/cover-icon.png"),
                      fit: BoxFit.contain)),
            ),
          ),
          // use _createDrawerItem instead of listing each tile
          _createDrawerItem(icon: Icons.home,text: 'Home'),
          _createDrawerItem(icon: Icons.chat,text: 'Begin Conversation'),
          _createDrawerItem(icon: Icons.receipt, text: 'View Reports'),
          _createDrawerItem(icon: Icons.settings, text: 'Settings'),
          _createDrawerItem(icon: Icons.help_outline, text: 'Help', onTap: () => Navigator.pushReplacementNamed(context, Routes.help)),
          _createDrawerItem(icon: Icons.logout, text: 'Log Out'),

        ],
      ),
    );
  }
}

class UnauthDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
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
                      image: AssetImage("images/cover-icon.png"),
                      fit: BoxFit.contain)),
            ),
          ),
          _createDrawerItem(icon: Icons.home,text: 'Home'),
          _createDrawerItem(icon: Icons.app_registration,text: 'Sign Up'),
          _createDrawerItem(icon: Icons.chat,text: 'Log In'),
          _createDrawerItem(icon: Icons.help_outline, text: 'Help', onTap: () => Navigator.pushReplacementNamed(context, Routes.help)),/*ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () => {},
        ),*/

        ],
      ),
    );
  }
}

// https://medium.com/flutter-community/flutter-vi-navigation-drawer-flutter-1-0-3a05e09b0db9
Widget _createDrawerItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}
