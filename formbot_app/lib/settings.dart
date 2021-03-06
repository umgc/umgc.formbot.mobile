import 'package:flutter/material.dart';
import 'widgets/app_drawer.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = 'Settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      endDrawer: AuthDrawer(),
    );
  }
}
