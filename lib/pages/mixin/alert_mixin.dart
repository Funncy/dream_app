import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

mixin AlertMixin<T extends StatefulWidget> on State<T> {
  void showAlert(
      {@required String title,
      @required String content,
      bool isFunction = false,
      Function function}) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            if (isFunction)
              FlatButton(
                child: Text('OK'),
                onPressed: () async {
                  function();
                  Navigator.pop(context, "OK");
                },
              ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, "Cancel");
              },
            ),
          ],
        );
      },
    );
  }
}
