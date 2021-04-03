/*This software is free to use by anyone. It comes with no warranties and is provided solely "AS-IS".
It may contain significant bugs, or may not even perform the intended tasks, or fail to be fit for any purpose.
University of Maryland is not responsible for any shortcomings and the user is solely responsible for the use.*/

import 'package:flutter/material.dart';
import 'package:formbot_app/routes/routes.dart';
import 'package:formbot_app/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthDrawer extends StatefulWidget {
  AuthDrawer({Key key}) : super(key: key);

  @override
  _AuthDrawerState createState() => _AuthDrawerState();
}

class _AuthDrawerState extends State<AuthDrawer>{
  GoogleSignInAccount _currentUser;
  String _email;

  @override
  void initState() {
    super.initState();
    _signInSilently();
  }

  Future<void> _signInSilently() async {
    var account = await AuthManager.signInSilently();
    setState(() {
      _currentUser = account;
      _email = _currentUser.email;
    });
  }

  void _logout() {
    setState(() {
      _currentUser = null;
    });
    AuthManager.signOut();
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context){
    return Drawer(
      key: Key('drawer'),
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                //color: Colors.white,
                  //color: Color(0xFFFAFAFA),
                  color: Color(0xFF007fbc),
                  image: DecorationImage(
                      image: AssetImage("assets/images/cover-icon.png"),
                      fit: BoxFit.contain)),
            ),
          ),
          // use _createDrawerItem instead of listing each tile
          //_createDrawerItem(icon: Icons.verified_user, text: '{$_email}'),
          _createDrawerItem(icon: Icons.verified_user, text: '$_email'),  // Removed the curly braces as these appear in the app
          _createDrawerItem(icon: Icons.home,text: 'Home',  uniqueKey: Key("drawerHome"),onTap: () => Navigator.popAndPushNamed(context, Routes.home)),
          _createDrawerItem(icon: Icons.chat,text: 'Begin Conversation', uniqueKey: Key("begin_conversation_tile"), onTap: () => Navigator.popAndPushNamed(context, Routes.conversation)),
          _createDrawerItem(icon: Icons.receipt, text: 'View Reports',uniqueKey: Key("view_reports"), onTap: () => Navigator.popAndPushNamed(context, Routes.reports)),
          _createDrawerItem(icon: Icons.settings, text: 'Settings', onTap: () => Navigator.popAndPushNamed(context, Routes.settings)),
          _createDrawerItem(icon: Icons.help_outline, text: 'Help', onTap: () => Navigator.popAndPushNamed(context, Routes.help)),
          _createDrawerItem(icon: Icons.logout, text: 'Log Out', onTap: () => _logout()),

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
                  // color: Colors.black,
                  image: DecorationImage(
                      image: AssetImage("assets/images/cover-icon.png"),
                      //image: AssetImage("assets/images/cover-icon-new.png"),
                      fit: BoxFit.contain)),
            ),
          ),
          _createDrawerItem(
            uniqueKey: Key("drawerHome"),
            icon: Icons.home,text: 'Home', onTap: () => Navigator.pushNamed(context, Routes.home)),
          //_createDrawerItem(icon: Icons.app_registration,text: 'Sign Up'),
          _createDrawerItem(icon: Icons.chat,text: 'Log In'),
          _createDrawerItem(icon: Icons.help_outline, text: 'Help', onTap: () => Navigator.pushNamed(context, Routes.help)),/*ListTile(
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
Widget _createDrawerItem({Key uniqueKey,IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    key: uniqueKey,
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



// NEW

