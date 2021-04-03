import 'package:flutter/material.dart';
import 'widgets/app_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.red,
      primaryColor: isDarkTheme ? Colors.black : Colors.white,
      backgroundColor: isDarkTheme ? Colors.black : Color(0xffF1F5FB),
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
      hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),
      highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
      ),
    );
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = Settings.darkMode;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}

class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}

class Settings {
  static var saveForm = true;
  static var darkMode = false;
  static var fontFamily = 'Roboto';
  static var fontSize = '12';
}

class SettingsPage extends StatefulWidget {
  static const String routeName = 'Settings';
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body:
      Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Google Drive path: Not set yet.'),
          TextButton(onPressed: (){}, child: Text('Set')),
        ]
        ),
        Container(
          child: CheckboxListTile(
            title: const Text('Enable dark mode?'),
            value: Settings.darkMode,
            onChanged: (bool value) {
              setState(() {
                Settings.darkMode = value;
              });
            },
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(child: Text('Font: ')),
          Container(child: DropDownList()),
          Container(child: Text('Font Size: ')),
          Container(child: DropDownList2())
        ])
      ]),
      endDrawer: AuthDrawer(),
    );
  }
}

class DropDownList extends StatefulWidget {
  @override
  _DropDownListState createState() => _DropDownListState();
}

class _DropDownListState extends State<DropDownList> {
  String dropdownValue = 'First';
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: Settings.fontFamily,
      onChanged: (String newValue) {
        setState(() {
          Settings.fontFamily = newValue;
        });
      },
      items: <String>['Roboto', 'Raleway', 'Lato', 'Oswald']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class DropDownList2 extends StatefulWidget {
  @override
  _DropDownList2State createState() => _DropDownList2State();
}

class _DropDownList2State extends State<DropDownList2> {
  String dropdownValue = 'First';
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: Settings.fontSize,
      onChanged: (String newValue) {
        setState(() {
          Settings.fontSize = newValue;
        });
      },
      items: <String>['12', '13', '14', '15']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
