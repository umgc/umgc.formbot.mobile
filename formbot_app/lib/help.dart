import 'package:flutter/material.dart';

import 'widgets/app_drawer.dart';

class HelpPage extends StatelessWidget {
  static const String routeName = 'help';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Help"),
        ),
        endDrawer: UnauthDrawer(),
        body: Center(child: Text("Help")));
  }
}