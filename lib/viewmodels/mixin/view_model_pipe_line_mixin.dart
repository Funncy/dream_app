import 'package:dream/core/data_status/data_result.dart';
import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/core/data_status/viewmodel_result.dart';
import 'package:get/get.dart';

typedef DataResult Process(DataResult successOrError);

mixin ViewModelPipeLineMixin {
  Future<DataResult> pipeline(List<Function> functionList) async {
    DataResult successOrError = DataResult(isCompleted: true);
    Map<String, dynamic> data = {};
    for (var function in functionList) {
      successOrError = await function(data);
      if (!successOrError.isCompleted) {
        return successOrError;
      }
      if (successOrError.data != null) data.addAll(successOrError.data);
    }
    return successOrError;
  }

  Future<ViewModelResult> process(
      {required List<Function> functionList,
      required Rxn<Status?> status}) async {
    status.value = Status.loading;

    ViewModelResult result = await pipeline(functionList);
    if (!result.isCompleted) {
      status.value = Status.error;
      return result;
    }

    status.value = Status.loaded;

    return ViewModelResult(isCompleted: true);
  }
}
