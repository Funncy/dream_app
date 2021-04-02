import 'package:get/get.dart';

enum Status { initial, loading, loaded, empty, error }

class ScreenStatus {
  Rx<Status> _status = Status.initial.obs;

  void setScreenStatus(Status status) {
    _status.value = status;
  }

  Status getScreenStatus() {
    return _status.value;
  }
}
