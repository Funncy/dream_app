import 'package:flutter/material.dart';

import '../../app/core/constants/constants.dart';

mixin InputMixin<T extends StatefulWidget> on State<T> {
  InputDecoration textInputDecor(String text) {
    return InputDecoration(
      labelText: text,
      enabledBorder: activeInputBorder(),
      focusedBorder: activeInputBorder(),
      errorBorder: errorInputBorder(),
      focusedErrorBorder: errorInputBorder(),
      filled: true,
      fillColor: Colors.grey[100],
    );
  }

  InputDecoration textInputCheckDecor(String text) {
    return InputDecoration(
      hintText: text,
      enabledBorder: activeInputBorder(),
      focusedBorder: activeInputBorder(),
      errorBorder: errorInputBorder(),
      focusedErrorBorder: errorInputBorder(),
      filled: true,
      fillColor: Colors.grey[100],
    );
  }

  OutlineInputBorder errorInputBorder() {
    return OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.redAccent,
        ),
        borderRadius: BorderRadius.circular(Constants.commonGap));
  }

  OutlineInputBorder activeInputBorder() {
    return OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(Constants.commonGap));
  }
}
