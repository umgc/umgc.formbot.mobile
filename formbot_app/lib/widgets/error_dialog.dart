import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class FormSciberErrorDialog  extends StatelessWidget {
   FormScriberError _errorToDisplay;

    FormSciberErrorDialog(this._errorToDisplay);

   @override
   Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_errorToDisplay._errorTitle),
      content: SingleChildScrollView(
        child: ListBody(
        children: <Widget>[Text(_errorToDisplay._errorDescription)]
        ),
      ),
      actions:  <Widget>[ElevatedButton(onPressed: () {
        Navigator.of(context).pop();
      })]
     );
    }
  }

class FormScriberError {
  String _errorTitle;
  String _errorDescription;
  FormScriberError(this._errorTitle, this._errorDescription);
}