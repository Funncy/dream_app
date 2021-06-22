import 'package:dream/app/core/error/failure.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

mixin AlertMixin<T extends StatefulWidget> on State<T> {
  void alertWithString(String title, String content) {
    showAlert(title: title, content: content);
  }

  void alertWithFailure(Failure? failure) {
    if (failure == null) {
      var logger = Logger();
      logger.d('Failure is null in errorAlert');
      return;
    }
    showAlert(title: failure.title, content: failure.content);
  }

  void showAlert(
      {required String? title,
      required String? content,
      bool isFunction = false,
      Function? function}) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title!),
          content: Text(content!),
          actions: <Widget>[
            if (isFunction)
              TextButton(
                child: Text('OK'),
                onPressed: () async {
                  function!();
                  Navigator.pop(context, "OK");
                },
              ),
            TextButton(
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
