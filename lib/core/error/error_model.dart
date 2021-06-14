import 'package:logger/logger.dart';

abstract class ErrorModel {
  late String code;
  late String title;
  late String content;

  ErrorModel({required this.code}) {
    var logger = Logger();
    logger.d("error code : $code");
  }
}
