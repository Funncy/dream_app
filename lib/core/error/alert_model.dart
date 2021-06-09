import 'package:dream/core/error/error_constants.dart';
import 'package:flutter/foundation.dart';

class AlertModel {
  String? title;
  String? content;
  bool isAlert = false;

  void update({required String code}) {
    title = ErrorConstants.alertMap['code']['title'];
    content = ErrorConstants.alertMap['code']['content'];
    isAlert = false;
  }
}
