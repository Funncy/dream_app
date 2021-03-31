import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String message;

  const ErrorScreen({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
