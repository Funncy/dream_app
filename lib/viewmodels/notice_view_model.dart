import 'package:dartz/dartz.dart';
import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/repositories/notice_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class NoticeViewModel extends GetxController {
  NoticeRepository _noticeRepository;
  //obs는 observer로 Rx로 데이터 관리되게 됩니다.
  //화면 상태가 아니라 데이터의 상태를 관리하자.
  RxList<NoticeModel> noticeList = <NoticeModel>[].obs;
  Rx<Status> noticeStatus = Status.initial.obs;

  NoticeViewModel({@required NoticeRepository noticeRepository}) {
    _noticeRepository = noticeRepository;
  }

  void createDummyData() async {
    _noticeRepository.createDummyData();
  }

  void getNoticeList() async {
    //데이터 상태와 데이터를 가져오는 함수를 전달
    //추가로 리스트 형태인지를 전달
    // 리스트 형태인경우 데이터의 길이에 따라 Empty위젯을 보여줘야 함.
    noticeStatus.value = Status.loading;
    Either<ErrorModel, List<NoticeModel>> either =
        await _noticeRepository.getNoticeList();
    var result = either.fold((l) {
      noticeStatus.value = Status.error;
    }, (r) => r);

    //에러인 경우 종료
    if (either.isLeft()) return;

    //Right이면 List로 반환됨.
    noticeList.clear();
    noticeList.addAll(result);
    if (noticeList.length > 0)
      noticeStatus.value = Status.loaded;
    else
      noticeStatus.value = Status.empty;
  }

  Future<void> toggleNoticeFavorite(
      {@required String noticeId, @required String userId}) async {
    //Notice의 좋아요 리스트 가져오기
    NoticeModel notice =
        noticeList.where((notice) => notice.id == noticeId)?.first;
    if (notice == null) return;

    //이미 등록되있다면 삭제
    bool isDelete = false;
    if (notice.favoriteUserList.where((element) => element == userId).isEmpty)
      isDelete = false;
    else
      isDelete = true;

    var result = await _noticeRepository.toggleNoticeFavorite(
        noticeId: noticeId, userId: userId, isDelete: isDelete);
    if (result.isLeft()) return;

    //local에서도 증가
    if (isDelete)
      notice.favoriteUserList.remove(userId);
    else
      notice.favoriteUserList.add(userId);
    noticeList.refresh();
  }
}
