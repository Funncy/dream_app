import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/repositories/notice_repository.dart';
import 'package:dream/viewmodels/common/get_data_with_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class NoticeViewModel extends GetxController with GetDataWithScreen {
  NoticeRepository _noticeRepository;
  //obs는 observer로 Rx로 데이터 관리되게 됩니다.
  //화면 상태가 아니라 데이터의 상태를 관리하자.
  RxList<NoticeModel> noticeList = <NoticeModel>[].obs;
  Rx<Status> noticeStatus = Status.initial.obs;
  RxList<NoticeCommentModel> commentList = <NoticeCommentModel>[].obs;
  Rx<Status> commentStatus = Status.initial.obs;
  //RxList<NoticeModel> not sub type List<NoticeModel>

  NoticeViewModel({@required NoticeRepository noticeRepository}) {
    _noticeRepository = noticeRepository;
  }

  void getNoticeList() async {
    //데이터 상태와 데이터를 가져오는 함수를 전달
    //추가로 리스트 형태인지를 전달
    // 리스트 형태인경우 데이터의 길이에 따라 Empty위젯을 보여줘야 함.
    List<NoticeModel> result = await getDataWithScreenStatus(
        dataStatus: noticeStatus,
        getData: _noticeRepository.getNoticeList,
        isList: true);

    if (result != null) {
      noticeList.clear();
      noticeList.addAll(result);

      checkEmptyWithScreenStatus(dataStatus: noticeStatus, result: result);
    }
  }

  void getCommentList(String did) async {
    List<NoticeCommentModel> result = await getDataWithScreenStatus(
        dataStatus: commentStatus,
        getData: () async => await _noticeRepository.getCommentList(did),
        isList: true);

    if (result != null) {
      commentList.clear();
      commentList.addAll(result);

      checkEmptyWithScreenStatus(dataStatus: commentStatus, result: result);
    }
  }
}
