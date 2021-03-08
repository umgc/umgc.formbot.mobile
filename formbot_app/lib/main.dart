import 'package:flutter/material.dart';

import 'widgets/app_drawer.dart';
import 'routes/routes.dart';
import 'homepage.dart';
import 'help.dart';
import 'conversation.dart';

void main() {
  runApp(MyApp()
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        Routes.conversation: (context) => ConversationPage()
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
  // This method is rerun every time setState is called.
  @override
  Widget build(BuildContext context) {
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

            // Login Button
            RaisedButton(
              onPressed: () => {Navigator.pushNamed(context, Routes.page2)},
              shape: const StadiumBorder(),
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(12.0),
                child: const Text('  Login  ', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(height: 30),

            // Help Button
            RaisedButton(
              onPressed: () => {Navigator.pushNamed(context, Routes.help)},
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child:
                const Text('   Help   ', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Main Page
/*class MainPage extends StatelessWidget {
  static const String routeName = 'page2';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Main Menu"),
        ),
        endDrawer: AuthDrawer(),
        body: Center(child: Text("Main Menu")));
  }
}*/
