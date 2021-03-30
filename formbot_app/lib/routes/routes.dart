/*This software is free to use by anyone. It comes with no warranties and is provided solely "AS-IS".
It may contain significant bugs, or may not even perform the intended tasks, or fail to be fit for any purpose.
University of Maryland is not responsible for any shortcomings and the user is solely responsible for the use.*/

//import 'package:flutter/material.dart';

import 'package:formbot_app/help.dart';
import 'package:formbot_app/homepage.dart';
import 'package:formbot_app/chat.dart';
import 'package:formbot_app/loginpage.dart';

class Routes{
  static const String help = HelpPage.routeName;
  //static const String landing = MyHomePage.routeName;
  static const String home= HomePage.routeName;
  static const String conversation = Chat.routeName;
  static const String login = LoginPage.routeName;
  //static const String settings = SettingsPage.routeName;
  //static const String reports = ReportsPage.routeName;
}