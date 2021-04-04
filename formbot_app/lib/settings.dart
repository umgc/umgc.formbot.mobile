import 'package:flutter/material.dart';
import 'widgets/app_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'dart:core';
import 'auth.dart';
import 'package:googleapis/drive/v3.dart' as ga;

class SettingsPage extends StatefulWidget {
  static const String routeName = 'settings';
  SettingsPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var authHeaders;
  // custom IOClient from below
  var httpClient;

  ga.DriveApi drive;
  ga.FileList folders;

  var templateFolderId;
  ga.File templateFolderSelection;
  bool _isSet = false;

  var reportsFolderId;


  void initState() {
    super.initState();
    initAuth();

  }

  void initAuth() async{
    authHeaders = await googleSignIn.currentUser.authHeaders;
    print(authHeaders);
    httpClient = GoogleHttpClient(authHeaders);
    setState(() {
      drive = ga.DriveApi(httpClient);
    });
    await getFolders();

  }

  void getFolders() async{
    await drive.files.list(q: "mimeType = 'application/vnd.google-apps.folder'").then((value) {
      setState(() {
        folders = value;
      });
      for (var i = 0; i < folders.files.length; i++) {
        print("Id: ${folders.files[i].id} | File Name:${folders.files[i].name} | mimeType: ${folders.files[i].mimeType}" );
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body:
      Column(children:[
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Google Drive path: '),
          DropdownButton(
            key: Key('templateFolderDropdown'),
            // hint: new Text("Select a Template"),
            isExpanded: true,
            // value: (_isSet? templateFolderSelection.name : "Select a Drive Folder"),
            items: folders.files.map((value) {
              return new DropdownMenuItem(
                value: value.name,
                child: new Text(value.name),
              );
            }).toList(),
            onChanged: (value) async {
              templateFolderSelection = await drive.files.get(folders.files.singleWhere((element) => element.name == value).id);
              setState(() {
                templateFolderSelection.permissions.add(ga.Permission.fromJson({"emailAddress":"formscribermobile@form-bot-1577a.iam.gserviceaccount.com","role":"writer"}));
                _isSet = true;
              });
            },
          ),
        ]),
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
