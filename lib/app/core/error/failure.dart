import 'package:logger/logger.dart';

abstract class Failure {
  late String code;
  late String title;
  late String content;

  Failure({required this.code}) {
    var logger = Logger();
    logger.d("error code : $code");
  }
}
