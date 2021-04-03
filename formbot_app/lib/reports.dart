import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:dialogflow_grpc/dialogflow_auth.dart';
import 'package:dialogflow_grpc/generated/google/cloud/dialogflow/v2/intent.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_stream/sound_stream.dart';
import 'package:dialogflow_grpc/dialogflow_grpc.dart';
import 'package:dialogflow_grpc/v2.dart';
import 'package:dialogflow_grpc/generated/google/cloud/dialogflow/v2/session.pb.dart'
as pbSession;
import 'app_body.dart';
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

  Widget dropdownButton = DropdownButton(
    key: Key('reportsFolderDropdown'),
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
      templateFolderId =
          templateFolderSelection = await drive.files.get(folders.files.singleWhere((element) => element.name == value).id, $fields: "webViewLink");
      setState(() {

      });
    },
  );

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

        ]
        ),
      ),
    );
  }
}