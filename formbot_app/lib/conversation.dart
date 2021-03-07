import 'package:flutter/material.dart';

import 'widgets/app_drawer.dart';

class ConversationPage extends StatelessWidget {
  static const String routeName = 'conversation';

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

    return new Scaffold(
        appBar: AppBar(
          title: Text("Conversation"),
        ),
        endDrawer: AuthDrawer(),
        body: Center(child: Text("Conversation")));
  }
}