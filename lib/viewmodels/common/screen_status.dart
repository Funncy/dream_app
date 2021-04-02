import 'package:dream/core/screen_status/status_enum.dart';
import 'package:get/get.dart';

class ScreenStatus {
  Rx<Status> _status = Status.initial.obs;

  void setScreenStatus(Status status) {
    _status.value = status;
  }

  Status getScreenStatus() {
    return _status.value;
  }
}
