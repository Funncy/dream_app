import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/repositories/notice_repository.dart';
import 'package:dream/repositories/notice_repository_impl.dart';
import 'package:dream/viewmodels/common/get_data_with_screen.dart';
import 'package:dream/viewmodels/common/screen_status.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class NoticeViewModel extends GetxController
    with ScreenStatus, GetDataWithScreen {
  NoticeRepository _noticeRepository;
  RxList<NoticeModel> notices = <NoticeModel>[].obs;

  NoticeViewModel({@required NoticeRepository noticeRepository}) {
    _noticeRepository = noticeRepository;
  }

  void getNoticeList() async {
    var result = await getDataWithScreenStatus(_noticeRepository.getNoticeList);

    if (result == null) {
      return;
    }

    notices.clear();
    notices.addAll(result);
    checkEmptyWithScreenStatus(result);
  }
}
