import 'package:dream/core/error/error_model.dart';

class ViewModelResult {
  bool isCompleted;
  ErrorModel? errorModel;
  dynamic data;

  ViewModelResult({required this.isCompleted, this.errorModel, this.data});
}
