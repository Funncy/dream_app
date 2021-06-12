import 'package:dream/core/data_status/data_result.dart';
import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/core/data_status/viewmodel_result.dart';
import 'package:get/get.dart';

typedef Future<DataResult> Process(DataResult successOrError);

mixin ViewModelPipeLineMixin {
  Future<DataResult> pipeline(List<Process> functionList) async {
    DataResult successOrError = DataResult(isCompleted: true);
    for (var process in functionList) {
      successOrError = await process(successOrError);
      if (!successOrError.isCompleted) {
        return successOrError;
      }
    }
    return successOrError;
  }

  Future<ViewModelResult> process(
      {required List<Process> functionList,
      required Rxn<Status?> status,
      List<dynamic>? dataList}) async {
    status.value = Status.loading;

    ViewModelResult result = await pipeline(functionList);
    if (!result.isCompleted) {
      status.value = Status.error;
      return result;
    }
    if (dataList != null && dataList.length == 0) {
      status.value = Status.empty;
    } else {
      status.value = Status.loaded;
    }
    return ViewModelResult(isCompleted: true);
  }
}
