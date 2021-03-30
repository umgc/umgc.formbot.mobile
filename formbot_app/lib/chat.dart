/*This software is free to use by anyone. It comes with no warranties and is provided solely "AS-IS".
It may contain significant bugs, or may not even perform the intended tasks, or fail to be fit for any purpose.
University of Maryland is not responsible for any shortcomings and the user is solely responsible for the use.*/

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
import 'app_body.dart' as dialog_flow;

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
  String selection = '';
  String templateURL = '';
  bool _isRecording = false;

  ServiceAccount serviceAccount;


  var responseStream;
  dynamic request;
  RecorderStream _recorder = RecorderStream();
  StreamSubscription _recorderStatus;
  StreamSubscription<List<int>> _audioStreamSubscription;

  // DialogflowGrpc class instance
  DialogflowGrpcV2 dialogflow;

  @override
  void initState() {
    super.initState();
    initPlugin();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    _recorderStatus = _recorder.status.listen((status) {
      if (mounted)
        setState(() {
          _isRecording = status == SoundStreamStatus.Playing;
        });
    });

    await Future.wait([_recorder.initialize()]);

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
    await Future.delayed(Duration(milliseconds: 500));

    Widget dropdownButton = DropdownButton<String>(
      key: Key('templateDropdown'),
      hint: new Text("Select a Template"),
      onChanged: (value) {
        setState(() {
          selection = value;
        });
      },
      items: <String>[
        'Vaccination Record',
        'New Prescription',
        'Medical History',
        'D'
      ].map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(value),
        );
      }).toList(),
    );

    Widget cancelButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text('Cancel'),
    );

    Widget proceedButton = TextButton(
      key: Key('proceedBtn'),
        onPressed: () {
          Navigator.of(context).pop();
          setState(() {
            // templateURL = 'https://docs.google.com/document/d/1yQyeG1vwL3D5vfDZV3INv5syqNUWu_Xl26QyVbTUrSE/edit?usp=drivesdk';
            templateURL =
                'https://docs.google.com/document/d/1o525SlozEGxS-d4PVp_GsDt6j8C9L6W8U5J63CFB6gU/edit?usp=sharing';
          });
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

  void handleStream() async {
    log('entering handleStream');
    _recorder.start();
    _isRecording = true;

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

    pbSession.QueryInput queryInput = pbSession.QueryInput()..audioConfig = config.cast();
    request = StreamController<pbSession.StreamingDetectIntentRequest>();
    request.add(pbSession.StreamingDetectIntentRequest()
      ..queryInput = queryInput
      ..session = DialogflowAuth.session
    );

    _audioStreamSubscription = _recorder.audioStream.listen((audio) {
      // Add audio content when stream changes.
      request.add(pbSession.StreamingDetectIntentRequest()
        ..inputAudio = audio);
    }, onDone: () {
      request.close();
      log('closed request');}
    );

    responseStream = dialogflow.client.streamingDetectIntent(request.stream);
    String transcript;
    String queryText;
    String fulfillmentText;

    // Get the transcript and detectedIntent and show on screen
    responseStream.listen((data) {
      log('---- responseStream ----');
      // if(data.recognitionResult.)
      setState(() {
        print(data);
        transcript = data.recognitionResult.transcript;
        // log('transcript, $transcript');
        queryText = data.queryResult.queryText;
        // log('queryText, $queryText');
        fulfillmentText = data.queryResult.fulfillmentText;
        // log('fulfillmentText, $fulfillmentText');

        if (fulfillmentText.isNotEmpty) {
          Intent_Message_Text intentMessageText = Intent_Message_Text(text: [data.queryResult.queryText]);
          Intent_Message intentMessage = Intent_Message(text: intentMessageText);
          messages.add({
            'message': intentMessage,
            'isUserMessage': true,
          });
          messages.add({
            'message': data.queryResult.fulfillmentMessages.first,
            'isUserMessage': false,
          });
        }
        if (transcript.isNotEmpty) {
          _textController.text = transcript;
        }
      });
    }, onError: (e) {
      print('grpc error: $e');
    }, onDone: () {
      log('done');
      log('transcript, $transcript');
      _textController.clear();
    });
  }

  Future<void> stopRequest(StreamController<pbSession.StreamingDetectIntentRequest> request) async{
    request.close();
  }

  void stopStream() async {
    _recorder.stop();
    log('_recorder.stop() called, recorder stopped');

    await Future.delayed(Duration(milliseconds: 100));
    request.close();
    request = null;
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