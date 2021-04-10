import 'package:dream/core/screen_status/status_enum.dart';
import 'package:get/get.dart';

//화면 상태 관리 클래스 mixin
class ScreenStatus {
  Rx<Status> _status = Status.initial.obs;

  void setScreenStatus(Status status) {
    _status.value = status;
  }

  Status getScreenStatus() {
    return _status.value;
  }
}
