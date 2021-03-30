/*This software is free to use by anyone. It comes with no warranties and is provided solely "AS-IS".
It may contain significant bugs, or may not even perform the intended tasks, or fail to be fit for any purpose.
University of Maryland is not responsible for any shortcomings and the user is solely responsible for the use.*/

import 'package:flutter/material.dart';

import 'widgets/app_drawer.dart';
import 'routes/routes.dart';
import 'auth.dart';



// This widget is the home page of the application. It is stateful.
class LoginPage extends StatefulWidget {
  //Navigator route name.
  static const String routeName = 'loginpage';


  // This class is the configuration for the state.
  // It holds the values provided by the parent and
  // used by the build method of the State.
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {


  Future<void> _handleSignIn() async {
    bool isSignedIn = await AuthManager.signIn();
    if (isSignedIn) {
      Navigator.pushReplacementNamed(context, Routes.home);
    }
  }

  Future<void> _signInSilently() async {
    var account = await AuthManager.signInSilently();
    if (account != null) {
      Navigator.pushReplacementNamed(context, Routes.home);
    }
  }

  _logout() {
    AuthManager.signOut();
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  // This method is rerun every time setState is called.
  @override
  Widget build(BuildContext context) {

    Future<bool> _willPopCallback() async {
      Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.login,
          ModalRoute.withName("/")
      );
      return false; // return true if the route to be popped
    }

    new WillPopScope(child: new Scaffold(), onWillPop: _willPopCallback);
    ElevatedButton logInButton = ElevatedButton(
        onPressed: _handleSignIn,
        child: Text('Log In')
    );

    ElevatedButton helpButton = ElevatedButton(
        onPressed: (){
          _logout();
        },
        child: Text('Help')
    );

    return Scaffold(
      // Select the drawer that is needed
      //  AuthDrawer - Authorized Users
      //  UnauthDrawer - Unauthorized Users
      endDrawer: AuthDrawer(),

      // Set appbar title from the value of title in MyHomePage object that was
      // created by the App.build method.
      appBar: AppBar(
        title: Text(widget.title),
          //backgroundColor: Color(0xFF007fbc)
        backgroundColor: (Colors.white),
        iconTheme: (IconThemeData(color: Colors.black)),
      ),

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Image.asset('assets/images/cover.png'),
            new Text('Login with your Google credentials to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,),
            ),
            const SizedBox(height: 50, width: 10.0,),
            logInButton,
            helpButton,

            SizedBox(height: 100),
            Container(
              // margin: EdgeInsets.only(top: 100),
              padding: const EdgeInsets.all(20.0),
              alignment: Alignment.bottomCenter,
              child: Text(
                  """This software is free to use by anyone. It comes with no warranties and is provided solely "AS-IS". It may contain significant bugs, or may not even perform the intended tasks, or fail to be fit for any purpose. University of Maryland is not responsible for any shortcomings and the user is solely responsible for the use.
                      """),
            ),
          ],
        ),
      ),
    );
  }
}
