import 'package:flutter/foundation.dart';

class AlertModel {
  String title;
  String content;
  bool isAlert = false;
  AlertModel({@required this.title, @required this.content}) {
    isAlert = false;
  }
}
