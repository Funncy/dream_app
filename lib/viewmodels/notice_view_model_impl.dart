import 'package:dartz/dartz.dart';
import 'package:dream/core/data_status/data_result.dart';
import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/core/data_status/viewmodel_result.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/repositories/notice_repository.dart';
import 'package:dream/viewmodels/mixin/view_model_pipe_line_mixin.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'notice_view_model.dart';

class NoticeViewModelImpl extends GetxController
    with ViewModelPipeLineMixin
    implements NoticeViewModel {
  late NoticeRepository _noticeRepository;
  //obs는 observer로 Rx로 데이터 관리되게 됩니다.
  //화면 상태가 아니라 데이터의 상태를 관리하자.
  List<NoticeModel> _noticeList = <NoticeModel>[];
  List<NoticeModel> get noticeList => _noticeList;
  Rxn<Status?> _noticeStatus = Rxn<Status?>(Status.initial);
  Status? get noticeStatus => _noticeStatus.value;
  set noticeStatus(Status? status) => _noticeStatus.value = status;

  NoticeViewModel({required NoticeRepository noticeRepository}) {
    _noticeRepository = noticeRepository;
  }

  void createDummyData() async {
    _noticeRepository.createDummyData();
  }

  Future<ViewModelResult> getNoticeList() => process(functionList: [
        (_) => _getNoticeList(),
      ], status: _noticeStatus, dataList: noticeList);

  Future<ViewModelResult> getMoreNoticeList() => process(functionList: [
        (_) => _getMoreNoticeList(),
      ], status: _noticeStatus);

  Future<ViewModelResult> toggleNoticeFavorite(
          {required String? noticeId, required String userId}) =>
      process(functionList: [
        (_) => _toggleNoticeFavorite(noticeId: noticeId, userId: userId),
      ], status: _noticeStatus);

  void refreshNotice() {
    _noticeStatus.refresh();
  }

  /*
  *
  *
  * 함수 부품들
  *
  *    
  */

  Future<DataResult> _getNoticeList() async {
    Either<ErrorModel, List<NoticeModel>> either =
        await _noticeRepository.getNoticeList();
    var result = either.fold((l) => l, (r) => r);

    //에러인 경우 종료
    if (either.isLeft()) {
      return DataResult(isCompleted: false, errorModel: result as ErrorModel);
    }

    noticeList.clear();
    noticeList.addAll(result as List<NoticeModel>);

    return DataResult(isCompleted: true);
  }

  Future<DataResult> _getMoreNoticeList() async {
    if (noticeList.length == 0) {
      return DataResult(
          isCompleted: false,
          errorModel: ErrorModel(message: 'noticeList item count is 0'));
    }

    Either<ErrorModel, List<NoticeModel>?> either = await _noticeRepository
        .getMoreNoticeList(noticeList.last.documentReference);
    var result = either.fold((l) => l, (r) => r);
    //에러인 경우 종료
    if (either.isLeft()) {
      return DataResult(isCompleted: false, errorModel: result as ErrorModel);
    }

    noticeList.addAll(result as List<NoticeModel>);
    return DataResult(isCompleted: true);
  }

  Future<DataResult> _toggleNoticeFavorite(
      {required String? noticeId, required String userId}) async {
    //Notice의 좋아요 리스트 가져오기
    DataResult successOrError = _getNoticeById(noticeId!);
    if (!successOrError.isCompleted) {
      return successOrError;
    }
    NoticeModel notice = successOrError.data['notice'];
    //이미 등록되있다면 삭제
    successOrError = _isExistFavoriteUser(notice, userId);
    if (!successOrError.isCompleted) {
      return successOrError;
    }
    bool isExist = successOrError.data['isExist'];

    var either = await _noticeRepository.toggleNoticeFavorite(
        noticeId: noticeId, userId: userId, isDelete: isExist);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      return DataResult(isCompleted: false, errorModel: result as ErrorModel);
    }

    //local에서도 증가
    if (isExist)
      notice.favoriteUserList!.remove(userId);
    else
      notice.favoriteUserList!.add(userId);
    refreshNotice();
    return DataResult(isCompleted: true);
  }

  DataResult _getNoticeById(String noticeId) {
    late NoticeModel notice;
    try {
      notice = noticeList.where((notice) => notice.id == noticeId).first;
    } catch (e) {
      return DataResult(
          isCompleted: false,
          errorModel: ErrorModel(message: 'notice not found'));
    }
    return DataResult(isCompleted: true, data: {'notice': notice});
  }

  DataResult _isExistFavoriteUser(NoticeModel notice, String userId) {
    late bool isExist;
    try {
      isExist = notice.favoriteUserList!
          .where((element) => element == userId)
          .isNotEmpty;
    } catch (e) {
      return DataResult(
          isCompleted: false,
          errorModel: ErrorModel(message: 'error at isExistFavoriteUser'));
    }
    return DataResult(isCompleted: true, data: {'isExist': isExist});
  }
}
