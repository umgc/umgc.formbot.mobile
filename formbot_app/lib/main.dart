import 'package:flutter/material.dart';
import 'package:formbot_app/widgets/app_drawer.dart';
import 'package:formbot_app/routes/routes.dart';
import 'help.dart';


void main() {
  runApp(MyApp()
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Scriber',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Form Scriber'),
      routes: {
        Routes.help: (context) => HelpPage(),
      },

    );
  }
}

class MyHomePage extends StatefulWidget {
  static const String routeName = '/help';

  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      // Select the drawer that is needed
      //  AuthDrawer - Authorized Users
      //  UnauthDrawer - Unauthorized Users
      endDrawer: AuthDrawer(),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Image.asset('images/cover.png'),
            new Text('Login with your Google credentials to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,),
            ),
            const SizedBox(height: 30, width: 10.0,),

            RaisedButton(
              onPressed: () => {Navigator.pushReplacementNamed(context, Routes.page2)},
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

            RaisedButton(
              onPressed: () {},
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
                child: const Text('Sign up', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(height: 30),

            RaisedButton(
              onPressed: () => {Navigator.pushReplacementNamed(context, Routes.help)},
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

class MainPage extends StatelessWidget {
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
}
