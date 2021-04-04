import 'dart:core';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:googleapis/drive/v3.dart' as ga;

class Reports extends StatefulWidget {
  static const String routeName = 'reports';

  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
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
    // templateFolderId =
    //     templateFolderSelection = await drive.files.get(folders.files.singleWhere((element) => element.name == value).id, $fields: "webViewLink");
    // folders.files[0].name,


  }

  void getFolders() async{
    await drive.files.list(q: "mimeType = 'application/vnd.google-apps.folder'").then((value) {
      setState(() {
        folders = value;
      });
      for (var i = 0; i < folders.files.length; i++) {
        print("Id: ${folders.files[i].id} | File Name:${folders.files[i].name} | mimeType: ${folders.files[i].mimeType}" );
        if(folders.files[i].name == "formscriber-reports"){
          print("----- found folder ------");
          print(folders.files[i].toJson());
          templateFolderId = folders.files[i].id;
        }
      }
    });
  }
  Widget table = Table(
    key: Key('reportsTable'),
    children: [
      TableRow(
          children: [
            Text("Report Name",textScaleFactor: 1.5,),
            Text("Link",textScaleFactor: 1.5),
            Text("Last Modified",textScaleFactor: 1.5),
          ]
      ),
      TableRow(
          children: [
            Text("Report 1",textScaleFactor: 1.5),
            Text("Open",textScaleFactor: 1.5),
            Text("Mar 3, 2021",textScaleFactor: 1.5),
          ]
      ),
      TableRow(
          children: [
            Text("Report 2",textScaleFactor: 1.5),
            Text("Open",textScaleFactor: 1.5),
            Text("Mar 3, 2021",textScaleFactor: 1.5),
          ]
      ),
      TableRow(
          children: [
            Text("Report 3",textScaleFactor: 1.5),
            Text("Open",textScaleFactor: 1.5),
            Text("Mar 3, 2021",textScaleFactor: 1.5),
          ]
      ),
    ],
  );

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
          Row(
            children: [Text(
          'Reports',
          style: TextStyle(
              fontSize: 25,
              color: Colors.black),
            )],
          ),
          table
        ]
        ),
      ),
    );
  }
}