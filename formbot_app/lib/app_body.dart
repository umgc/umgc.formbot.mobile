import 'package:dialogflow_grpc/generated/google/cloud/dialogflow/v2/intent.pb.dart';
import 'package:flutter/material.dart';

class AppBody extends StatelessWidget {
  final List<Map<String, dynamic>> messages;

  const AppBody({
    Key key,
    this.messages = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, i) {
        var obj = messages[messages.length - 1 - i];
        Intent_Message message = obj['message'];
        bool isUserMessage = obj['isUserMessage'] ?? false;
        return Row(
          mainAxisAlignment:
          isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _MessageContainer(
              message: message,
              isUserMessage: isUserMessage,
            ),
          ],
        );
      },
      separatorBuilder: (_, i) => Container(height: 10),
      itemCount: messages.length,
      reverse: true,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
    );
  }
}

class _MessageContainer extends StatelessWidget {
  final Intent_Message message;
  final bool isUserMessage;

  const _MessageContainer({
    Key key,

    @required
    this.message,
    this.isUserMessage = false,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 250),
      child: LayoutBuilder(
        builder: (context, constrains) {
          if (message.hasCard()) {
            return _CardContainer(card: message.card);
          }  else{
            return Container(
                decoration: BoxDecoration(
                  color: isUserMessage ? Colors.blue : Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(10),
                child: Text(
                  message?.text?.text[0] ?? '',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  final Intent_Message_Card card;

  const _CardContainer({
    Key key,
    @required this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Colors.orange,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints.expand(height: 150),
              child: Image.network(
                card.imageUri,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    card.title,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (card.subtitle != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        card.subtitle,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  if (card.buttons.length > 0)
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: 40,
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        // padding: const EdgeInsets.symmetric(vertical: 5),
                        itemBuilder: (context, i) {
                          Intent_Message_Card_Button button = card.buttons[i];
                          // return FlatButton(
                          return ElevatedButton(
                            child: Text(button.text),
                            onPressed: () {// ScaffoldMessenger.showSnackBar(
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(button.postback),
                              ));
                            },
                          );
                        },
                        separatorBuilder: (_, i) => Container(width: 10),
                        itemCount: card.buttons.length,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}