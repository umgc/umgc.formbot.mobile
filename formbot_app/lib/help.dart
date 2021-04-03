/*This software is free to use by anyone. It comes with no warranties and is provided solely "AS-IS".
It may contain significant bugs, or may not even perform the intended tasks, or fail to be fit for any purpose.
University of Maryland is not responsible for any shortcomings and the user is solely responsible for the use.*/

import 'package:flutter/material.dart';
import 'widgets/app_drawer.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';


class HelpPage extends StatefulWidget {
  static const String routeName = 'help';

  @override
  State<StatefulWidget> createState() {
    return _HelpPageState();
  }
}

class _HelpPageState extends State<HelpPage> {
  //
  WebViewController _webViewController;
  String filePath = 'assets/files/help.html';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Help')),
        body: WebView(
          initialUrl: 'https://duchesam.github.io/HelpPage/help.html',
          javascriptMode: JavascriptMode.unrestricted,

        )
    );
  }

  _loadHtmlFromAssets() async {
    String fileHtmlContents = await rootBundle.loadString(filePath);
    _webViewController.loadUrl(Uri.dataFromString(fileHtmlContents,
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());

    _webViewController.loadUrl("http://google.com");


  }
}

