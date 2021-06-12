import 'package:dream/core/data_status/data_result.dart';
import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/core/data_status/viewmodel_result.dart';

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
      required Function setStatus,
      List<dynamic>? dataList}) async {
    setStatus(Status.loading);

    ViewModelResult result = await pipeline(functionList);
    if (!result.isCompleted) {
      setStatus(Status.error);
      return result;
    }
    if (dataList == null && dataList!.length == 0) {
      setStatus(Status.empty);
    } else {
      setStatus(Status.loaded);
    }
    return ViewModelResult(isCompleted: true);
  }
}
