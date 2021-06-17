import 'package:dream/core/error/error_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

mixin AlertMixin<T extends StatefulWidget> on State<T> {
  void alertWithString(String title, String content) {
    showAlert(title: title, content: content);
  }

  void alertWithErrorModel(ErrorModel? errorModel) {
    if (errorModel == null) {
      var logger = Logger();
      logger.d('errorModel is null in errorAlert');
      return;
    }
    showAlert(title: errorModel.title, content: errorModel.content);
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
