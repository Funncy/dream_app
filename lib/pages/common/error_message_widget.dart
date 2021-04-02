import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  final errorMessage;

  const ErrorMessageWidget({Key key, @required this.errorMessage})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(errorMessage),
      ),
    );
  }
}
