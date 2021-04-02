import 'package:dream/core/screen_status/status_enum.dart';
import 'package:dream/viewmodels/common/screen_status.dart';

mixin GetDataWithScreen on ScreenStatus {
  Future<T> getDataWithScreenStatus<T>(Function getData) async {
    setScreenStatus(Status.loading);
    try {
      return await getData();
    } catch (e) {
      setScreenStatus(Status.error);
      return null;
    }
  }

  void checkEmptyWithScreenStatus<S>(List<S> result) {
    if (result.length == 0) {
      setScreenStatus(Status.empty);
    } else {
      setScreenStatus(Status.loaded);
    }
  }
}
