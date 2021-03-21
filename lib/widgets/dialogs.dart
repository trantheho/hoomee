import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppAlertDialog extends StatelessWidget {
  final title;
  final message;

  const AppAlertDialog({Key key, this.title = "Alert", this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}


class ConfirmAlertDialog extends StatelessWidget {
  final title;
  final message;
  final onOkPress;

  const ConfirmAlertDialog({
    Key key,
    this.title = "Alert",
    this.message,
    this.onOkPress,
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(message ?? ''),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('CANCEL'),
        ),
        FlatButton(
          onPressed: () {
            onOkPress();
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}