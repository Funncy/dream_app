import 'package:dartz/dartz.dart';
import 'package:dream/core/data_status/data_result.dart';
import 'package:dream/core/data_status/view_state.dart';
import 'package:dream/core/error/default_error_model.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/repositories/notice_repository.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class NoticeViewModelImpl extends GetxController {
  late NoticeRepository _noticeRepository;
  //obs는 observer로 Rx로 데이터 관리되게 됩니다.
  //화면 상태가 아니라 데이터의 상태를 관리하자.
  List<NoticeModel> _noticeList = <NoticeModel>[];
  List<NoticeModel> get noticeList => _noticeList;
  Rxn<ViewState?> _noticeStatus = Rxn<ViewState?>(ViewState.initial);
  ViewState? get noticeStatus => _noticeStatus.value;
  Stream<ViewState?> get noticeStatusStream => _noticeStatus.stream;
  late ErrorModel _errorModel;
  ErrorModel? get errorModel => _errorModel;

  NoticeViewModelImpl({required NoticeRepository noticeRepository}) {
    _noticeRepository = noticeRepository;
  }

  void createDummyData() async {
    _noticeRepository.createDummyData();
  }

  Future<void> getNoticeList() async {
    _setState(ViewState.loading);
    Either<ErrorModel, List<NoticeModel>> either =
        await _noticeRepository.getNoticeList();
    var result = either.fold((l) => l, (r) => r);

    //에러인 경우 종료
    if (either.isLeft()) {
      _setErrorModel(errorModel: result as ErrorModel);
      _setState(ViewState.error);
    }

    noticeList.clear();
    noticeList.addAll(result as List<NoticeModel>);
    _setState(ViewState.loaded);
  }

  Future<void> getMoreNoticeList() async {
    _setState(ViewState.loading);
    if (noticeList.length == 0) {
      _setErrorModel(code: 'noticeList item count is 0');
      _setState(ViewState.loading);
    }

    Either<ErrorModel, List<NoticeModel>?> either = await _noticeRepository
        .getMoreNoticeList(noticeList.last.documentReference);
    var result = either.fold((l) => l, (r) => r);

    if (either.isLeft()) {
      _setErrorModel(errorModel: result as ErrorModel);
      _setState(ViewState.loading);
    }

    noticeList.addAll(result as List<NoticeModel>);
    _setState(ViewState.loaded);
  }

  Future<void> toggleNoticeFavorite(
      {required String? noticeId, required String userId}) async {
    _setState(ViewState.loading);
    //Notice의 좋아요 리스트 가져오기
    NoticeModel? noticeModel = _getNoticeById(noticeId!);
    if (noticeModel == null) {
      _setErrorModel(code: 'noticeList item count is 0');
      _setState(ViewState.error);
    }
    //이미 등록되있다면 삭제
    bool? isExist = _isExistFavoriteUser(noticeModel!, userId);
    if (isExist == null) {
      _setErrorModel(code: '_isExistFavoriteUser error');
      _setState(ViewState.error);
    }

    var either = await _noticeRepository.toggleNoticeFavorite(
        noticeId: noticeId, userId: userId, isDelete: isExist!);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      _setErrorModel(errorModel: result as ErrorModel);
      _setState(ViewState.error);
    }

    //local에서도 증가
    _toggleFavoriteLocal(noticeModel, userId, isExist);
    _setState(ViewState.loaded);
  }

  void refreshNotice() {
    _noticeStatus.refresh();
  }

  void _toggleFavoriteLocal(
      NoticeModel noticeModel, String userId, bool isExist) {
    if (isExist)
      noticeModel.favoriteUserList!.remove(userId);
    else
      noticeModel.favoriteUserList!.add(userId);
  }

  NoticeModel? _getNoticeById(String noticeId) {
    late NoticeModel notice;
    try {
      notice = noticeList.where((notice) => notice.id == noticeId).first;
      return notice;
    } catch (e) {
      return null;
    }
  }

  bool? _isExistFavoriteUser(NoticeModel notice, String userId) {
    late bool isExist;
    try {
      isExist = notice.favoriteUserList!
          .where((element) => element == userId)
          .isNotEmpty;
      return isExist;
    } catch (e) {
      return null;
    }
  }

  _setState(ViewState state) {
    _noticeStatus.value = state;
  }

  _setErrorModel({ErrorModel? errorModel, String? code}) {
    if (errorModel != null)
      _errorModel = errorModel;
    else if (code != null) _errorModel = DefaultErrorModel(code: code);
  }
}
