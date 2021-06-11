import 'package:dream/core/data_status/viewmodel_result.dart';
import 'package:dream/core/error/error_model.dart';

class DataResult extends ViewModelResult {
  DataResult({required bool isCompleted, ErrorModel? errorModel, dynamic data})
      : super(isCompleted: isCompleted, errorModel: errorModel, data: data);
}
