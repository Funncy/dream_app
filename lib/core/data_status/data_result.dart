import 'package:dream/core/error/error_model.dart';
import 'package:flutter/foundation.dart';

class DataResult {
  bool isCompleted;
  ErrorModel errorModel;

  DataResult({@required this.isCompleted, this.errorModel});
}
