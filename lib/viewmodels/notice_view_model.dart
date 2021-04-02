import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/repositories/notice_repository.dart';
import 'package:dream/repositories/notice_repository_impl.dart';
import 'package:dream/viewmodels/common/screen_status.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class NoticeViewModel extends GetxController with ScreenStatus {
  NoticeRepository _noticeRepository;
  RxList<NoticeModel> notices = <NoticeModel>[].obs;

  NoticeViewModel({@required NoticeRepository noticeRepository}) {
    _noticeRepository = noticeRepository;
  }

  void getNotices() async {
    List<NoticeModel> result = [];
    //로딩 상태
    setScreenStatus(Status.loading);
    try {
      result = await _noticeRepository.getNotices();
    } catch (e) {
      print(e);
      //데이터 로드 실패
      //세부적인 에러 내용은 ErrorModel에 담겨 있음
      setScreenStatus(Status.error);
      return;
    }

    if (result != null) {
      //초기화 후 데이터 삽입
      notices.clear();
      notices.addAll(result);
    }

    if (result.length == 0) {
      setScreenStatus(Status.empty);
    } else {
      setScreenStatus(Status.loaded);
    }
  }
}
