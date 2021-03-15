import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'app_body.dart';

class ConversationPage extends StatefulWidget {
  static const String routeName = 'conversation';
  ConversationPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {

  DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  SpeechToText _speech;
  bool _isListening = false;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  int resultListened = 0;
  String _words = '';
  String dropdownValue = 'URL 1';
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    _speech = SpeechToText();
    _showDialog();
  }

  _showDialog() async {
    await Future.delayed(Duration(milliseconds: 50));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: AlertDialog(
            title: Text('Step 1: Select Form Template'),
            content:
            DropdownButton<String>(
              items: <String>['A', 'B', 'C', 'D'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
            actions: [
              FlatButton(
                textColor: Colors.black,
                onPressed: () {},
                child: Text('Cancel'),
              ),
              FlatButton(
                textColor: Colors.black,
                onPressed: () {},
                child: Text('Proceed'),
              ),],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation'),
      ),

      body: Column(
        children: [
          Expanded(child: AppBody(messages: messages)),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            color: Colors.blue,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                FloatingActionButton(
                  child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: _listen,
                  hoverColor: Colors.red,
                  splashColor: Colors.blue,
                  backgroundColor: Colors.grey,
                ),
                IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _listen() async {
    String result = '';
    if (!_isListening) {
      bool available = await _speech.initialize(
          onError: errorListener, onStatus: statusListener, debugLogging: false
      );

      if (available) {
        log('started, time: ${DateTime.now()}', time: DateTime.now());
        setState(() => _isListening = true);
        _speech.listen(
          cancelOnError: true,
          onResult: resultListener,
          partialResults: false,
        );
        return result;
      }
    } else {
      stopListening();
      log('stopped, time: ${DateTime.now()}', time: DateTime.now());
      return result;
    }
    return result;
  }

  Future<void> complete() async {
    if (!_speech.isListening && (_speech.lastStatus == 'isListening') && _controller.text.isNotEmpty) {
      log('completing, time: ${DateTime.now()}', time: DateTime.now());
      stopListening();
      sendMessage(_controller.text);
      _controller.clear();
    }
  }

  void stopListening() {
    log('stopping, time: ${DateTime.now()}', time: DateTime.now());
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    log("speech error status: $error, listening: ${_speech.isListening}, time: ${DateTime.now()}", time: DateTime.now());
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    log('speech listener Status: $status, time: ${DateTime.now()}', time: DateTime.now());
    setState(() {
      lastStatus = '$status';
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    ++resultListened;
    print('Result listener $resultListened');
    setState(() {
      lastWords = '${result.recognizedWords} - ${result.finalResult}';
      log('result ${result.recognizedWords}, time: ${DateTime.now()}', time: DateTime.now());
      log('finalResult ${result.finalResult}, time: ${DateTime.now()}', time: DateTime.now());
      log('lastWords $lastWords, time: ${DateTime.now()}', time: DateTime.now());
      _controller.text = result.recognizedWords;

      stopListening();
      log('auto stopped, time: ${DateTime.now()}', time: DateTime.now());
    }
    );
    sendMessage(_controller.text);
    _controller.clear();
  }

  void sendMessage(String text) async {
    if (text.isEmpty) return;
    setState(() {
      addMessage(
        Message(text: DialogText(text: [text])),
        true,
      );
    });

    dialogFlowtter.projectId = "form-bot-1577a";

    DetectIntentResponse response = await dialogFlowtter.detectIntent(
      queryInput: QueryInput(text: TextInput(text: text)),
    );

    if (response.message == null) return;
    setState(() {
      addMessage(response.message);
    });
  }

  void addMessage(Message message, [bool isUserMessage]) {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage ?? false,
    });
  }

  @override
  void dispose() {
    dialogFlowtter.dispose();
    super.dispose();
  }
}

