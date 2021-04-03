import 'dart:core';
import 'package:flutter/material.dart';
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
          title: Row(
            children: <Widget>[
              Image.asset(
                //'assets/images/logo.png',
                'assets/images/cover-icon.png',
                height: 55,
              ),
              SizedBox(
                width: 30,
              ),
              Text(''),
            ],
          ),
          actions: <Widget>[
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: Text(
                'Sign Out',
                style: TextStyle(color: Colors.white),
              ),
            )
          ]),
      body: Center(
        child: Column(children: <Widget>[
          DropdownButton(
            key: Key('templateFolderDropdown'),
            // hint: new Text("Select a Template"),
            isExpanded: false,
            value: folders.files[0].name,
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
              });
            },
          )
        ]
        ),
      ),
    );
  }
}