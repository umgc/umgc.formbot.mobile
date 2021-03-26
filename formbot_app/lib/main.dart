import 'package:flutter/material.dart';

import 'widgets/app_drawer.dart';
import 'routes/routes.dart';
import 'homepage.dart';
import 'help.dart';
import 'chat.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';

void main() {
  runApp(MyApp()
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: Key('app'),
      title: 'Form Scriber',

      // This is the theme of the application.
      theme: ThemeData(
        primarySwatch: Colors.blue,

        // This makes the visual density adapt to any platform.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Form Scriber'),

      //Navigator routes to other pages.
      routes: {
        //Routes.landing: (context) => MyHomePage(),
        Routes.help: (context) => HelpPage(),
        Routes.page2: (context) => HomePage(),
        Routes.conversation: (context) => Chat()
      },
    );
  }
}

// This widget is the home page of the application. It is stateful.
class MyHomePage extends StatefulWidget {
  //Navigator route name.
  //static const String routeName = 'landing';

  // This class is the configuration for the state.
  // It holds the values provided by the parent and
  // used by the build method of the State.
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currentUser;

  Future<void> _handleSignIn() async {
    var account = await AuthManager.signIn();
    if (account != null) {
      Navigator.pushReplacementNamed(context, Routes.page2);
    }
  }

  Future<void> _signInSilently() async {
    var account = await AuthManager.signInSilently();
    if (account != null) {
      Navigator.pushReplacementNamed(context, Routes.page2);
    }
  }

  _logout() {
    // setState(() {
    //   _currentUser = null;
    // });
    // AuthManager.signOut();
    Navigator.pushNamed(context, Routes.help);
  }

  // This method is rerun every time setState is called.
  @override
  Widget build(BuildContext context) {

    ElevatedButton logInButton = ElevatedButton(
        key: Key('login_btn'),
        onPressed: _handleSignIn,
        child: Text('Log In')
    );

    ElevatedButton helpButton = ElevatedButton(
       key: Key('help_btn'),
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
            const SizedBox(height: 30, width: 10.0,),
            logInButton,
            helpButton,
          ],
        ),
      ),
    );
  }
}
