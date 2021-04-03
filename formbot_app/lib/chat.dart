/*This software is free to use by anyone. It comes with no warranties and is provided solely "AS-IS".
It may contain significant bugs, or may not even perform the intended tasks, or fail to be fit for any purpose.
University of Maryland is not responsible for any shortcomings and the user is solely responsible for the use.*/

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

// https://pub.dev/packages/dialogflow_grpc/example
class Chat extends StatefulWidget {
  static const String routeName = 'conversation';
  Chat({Key key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _textController = TextEditingController();
  ga.File selection;
  var templateURL;
  bool _isRecording = false;

  ServiceAccount serviceAccount;

  var responseStream;
  var request = StreamController<pbSession.StreamingDetectIntentRequest>();
  RecorderStream _recorder = RecorderStream();
  StreamSubscription _recorderStatus;
  StreamSubscription<List<int>> _audioStreamSubscription;

  // DialogflowGrpc class instance
  DialogflowGrpcV2 dialogflow;
  var authHeaders;

  // custom IOClient from below
  var httpClient;

  ga.FileList folders;
  var templateFolderId;
  ga.FileList docslist;

  @override
  void initState() {
    super.initState();
    initPlugin();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    // _recorderStatus = _recorder.status.listen((status) {
    //   if (mounted)
    //     setState(() {
    //       _isRecording = status == SoundStreamStatus.Playing;
    //     });
    // });
    //
    // await Future.wait([_recorder.initialize()]);

    serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('assets/credentials.json'))}');

    dialogflow = DialogflowGrpcV2.viaServiceAccount(serviceAccount);

    var greeting = await dialogflow.detectIntent('Hi', 'en-US');
    if (greeting.queryResult.fulfillmentMessages == null) return;
    setState(() {
      addMessage(greeting.queryResult.fulfillmentMessages.first);
    });

    _showDialog();
  }

  _showDialog() async {
    authHeaders = await googleSignIn.currentUser.authHeaders;
    print(authHeaders);
    httpClient = GoogleHttpClient(authHeaders);
    // print(httpClient);
    await Future.delayed(Duration(milliseconds: 500));

    var drive = ga.DriveApi(httpClient);

    await drive.files.list(spaces: 'drive', q: "mimeType = 'application/vnd.google-apps.folder'").then((value) {
      setState(() {
        folders = value;
      });
      for (var i = 0; i < folders.files.length; i++) {
        print("Id: ${folders.files[i].id} | File Name:${folders.files[i].name} | mimeType: ${folders.files[i].mimeType}" );
        if(folders.files[i].name == "formscriber-templates"){
          print("----- found folder ------");
          print(folders.files[i].toJson());
          templateFolderId = folders.files[i].id;
        }
      }
    });

    print(templateFolderId);

    await drive.files.list(q: "'$templateFolderId' in parents").then((value) {
      setState(() {
        docslist = value;
      });
      for (var i = 0; i < docslist.files.length; i++) {
          print(docslist.files[i].toJson());
        }
    });

    Widget dropdownButton = DropdownButton(
      key: Key('templateDropdown'),
      // hint: new Text("Select a Template"),
      isExpanded: false,
      value: docslist.files[0].name,
      items: docslist.files.map((value) {
        return new DropdownMenuItem(
          value: value.name,
          child: new Text(value.name),
        );
      }).toList(),
      onChanged: (value) async {
        selection = await drive.files.get(docslist.files.singleWhere((element) => element.name == value).id, $fields: "webViewLink");
        setState(() {
          templateURL = selection.webViewLink;
          print(templateURL);
        });
      },
    );

    Widget cancelButton = TextButton(
      onPressed: () {
        // Navigator.of(context).popUntil(ModalRoute.withName('/home'));
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
      child: Text('Cancel'),
    );

    Widget proceedButton = TextButton(
      key: Key('proceedBtn'),
        onPressed: () {
          Navigator.of(context).pop();
          _greeting(templateURL);
        },
        child: Text('Proceed'));

    AlertDialog templateSelector = AlertDialog(
      title: Text('Step 1: Select Form Template'),
      content: dropdownButton,
      actions: [
        cancelButton,
        proceedButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return templateSelector;
      },
    );
  }

  _greeting(String url) {
    handleSubmitted(url);
  }

  void handleSubmitted(text) async {
    if (text.isEmpty) return;
    Intent_Message_Text intentMessageText = Intent_Message_Text(text: [text]);
    Intent_Message intentMessage = Intent_Message(text: intentMessageText);
    log('hasCard: ${intentMessage.hasCard()}');
    setState(() {
      messages.add({
        'message': intentMessage,
        'isUserMessage': true,
      });
    });

    var data = await dialogflow.detectIntent(text, 'en-US');

    if (data.queryResult.fulfillmentMessages == null) return;
    setState(() {
      addMessage(data.queryResult.fulfillmentMessages.first);
    });
  }

  void addMessage(Intent_Message message, [bool isUserMessage]) {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage ?? false,
    });
  }

  void startRecord() async {
    _recorderStatus = _recorder.status.listen((status) {
      if (mounted)
        setState(() {
          _isRecording = status == SoundStreamStatus.Playing;
        });
    });

    await Future.wait([_recorder.initialize()]);

    _recorder.start();
    _isRecording = true;
  }

  void handleStream() async {
    log('entering handleStream');
    // _recorder.start();
    // _isRecording = true;
    await startRecord();
    print('recorder started');

    // Create and audio InputConfig
    //  See: https://cloud.google.com/dialogflow/es/docs/reference/rpc/google.cloud.dialogflow.v2#google.cloud.dialogflow.v2.InputAudioConfig
    var config = InputConfigV2(
        encoding: 'AUDIO_ENCODING_LINEAR_16',
        languageCode: 'en-US',
        sampleRateHertz: 16000);
    if (Platform.isIOS) {
      config = InputConfigV2(
          encoding: 'AUDIO_ENCODING_LINEAR_16',
          languageCode: 'en-US',
          sampleRateHertz: 16000);
    }
    print('config created, $config');

    pbSession.QueryInput queryInput = pbSession.QueryInput()..audioConfig = config.cast();
    print('queryInput created, $queryInput');


    print('request state before init: $request');
    setState(() {
      request = null;
      request = new StreamController<pbSession.StreamingDetectIntentRequest>();
    });
    print('request state after init: $request');

    request.add(pbSession.StreamingDetectIntentRequest()
      ..queryInput = queryInput
      ..session = DialogflowAuth.session
    );

    print('request state after first add: $request');

    _audioStreamSubscription = _recorder.audioStream.listen((audio) {
      // Add audio content when stream changes.
      request.add(pbSession.StreamingDetectIntentRequest()
        ..inputAudio = audio);
      // print('adding audio to request stream');
    }
    // , onDone: () {
    //   request.close();
    //   log('closed request');}
    );

    responseStream = dialogflow.client.streamingDetectIntent(request.stream);
    var transcript;
    var fulfillmentText;

    // Get the transcript and detectedIntent and show on screen
    responseStream.listen((data) {
      log('---- responseStream ----');
      setState(() {
        print(data);
        transcript = data.recognitionResult.transcript;
        fulfillmentText = data.queryResult.fulfillmentText;

        if (fulfillmentText.isNotEmpty) {
          Intent_Message_Text intentMessageText = Intent_Message_Text(text: [data.queryResult.queryText]);
          Intent_Message intentMessage = Intent_Message(text: intentMessageText);
          messages.add({
            'message': intentMessage,
            'isUserMessage': true,
          });
          addMessage(data.queryResult.fulfillmentMessages.first);

        }
        if (transcript.isNotEmpty) {
          _textController.text = transcript;
        }
      });
    }, onError: (e) {
      print('grpc error: $e');
    }, onDone: () {
      log('done');
      log('transcript: $transcript');
      _textController.clear();
    });
  }

  // Future<void> stopRequest(StreamController<pbSession.StreamingDetectIntentRequest> request) async{
  //   request.close();
  // }

  void stopStream() async {
    _recorder.stop();
    log('_recorder.stop() called, recorder stopped');

    await Future.delayed(Duration(milliseconds: 100));
    await Future.wait([request.close()]);
    log('request.close() called, request closed');
    _isRecording = false;
  }

  @override
  void dispose() {
    _recorderStatus?.cancel();
    _audioStreamSubscription?.cancel();
    super.dispose();
  }

  // The chat interface
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('chat_page'),
      appBar: AppBar(
        title: Text('Conversation'),
        backgroundColor: Color(0xFF007fbc),
      ),
      body: Column(children: <Widget>[
        Expanded(child: AppBody(messages: messages)),
        Divider(height: 1.0),
        Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: IconTheme(
              data: IconThemeData(color: Theme.of(context).accentColor),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        key: Key('msgTextfield'),controller: _textController,
                        onSubmitted: handleSubmitted,
                        decoration: InputDecoration.collapsed(
                            hintText: "Send a message"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconButton(key:  Key('msgSendBtn'),
                          icon: Icon(Icons.send),
                          onPressed: () {
                            handleSubmitted(_textController.text);
                            _textController.clear();
                          }),
                    ),
                    IconButton(
                      iconSize: 30.0,
                      icon: Icon(_isRecording ? Icons.mic_off : Icons.mic),
                      onPressed: _isRecording ? stopStream : handleStream,
                    ),
                  ],
                ),
              ),
            )),
      ]),
    );
  }
}