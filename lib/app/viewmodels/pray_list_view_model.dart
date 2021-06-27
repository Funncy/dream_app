import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/default_failure.dart';
import 'package:dream/app/core/error/failure.dart';
import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/app/data/models/pray.dart';
import 'package:dream/app/repositories/pray_repository.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PrayListViewModel extends GetxController {
  late PrayRepository _prayRepository;
  Rxn<ViewState> _listState = Rxn(Initial());
  ViewState? get listState => _listState.value;
  Stream<ViewState?> get listStateStream => _listState.stream;

  List<PrayModel> prayList = [];

  PrayListViewModel({required PrayRepository prayRepository}) {
    _prayRepository = prayRepository;
  }

  Future<void> getPrayList() async {
    _setState(Loading());
    Either<Failure, List<PrayModel>?> either =
        await _prayRepository.initPublicPrayList();
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      _setState(Error(result as Failure));
      return;
    }
    prayList.clear();
    prayList.addAll(either.getOrElse(() => null)!);
    _setState(Loaded());
  }

  Future<void> getMorePrayList() async {
    _setState(Loading());
    Either<Failure, List<PrayModel>?> either = await _prayRepository
        .getMorePublicPrayList(prayList.last.documentReference);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      _setState(Error(result as Failure));
      return;
    }

    prayList.addAll(result as List<PrayModel>);
    _setState(Loaded());
  }

  Future<void> togglePrayFavorite(
      {required String prayId, required String userId}) async {
    _setState(Loading());
    //Notice의 좋아요 리스트 가져오기
    PrayModel? prayModel = _getPrayById(prayId);
    if (prayModel == null) {
      _setState(Error(DefaultFailure(
          code: 'could not find prayModel at togglePrayFavorite ')));
      return;
    }
    //이미 등록되있다면 삭제
    bool? isExist = _isExistFavoriteUser(prayModel, userId);
    if (isExist == null) {
      _setState(Error(DefaultFailure(
          code: '_isExistFavoriteUser error at togglePrayFavorite')));
      return;
    }

    var either = await _prayRepository.togglePrayFavorite(
        prayId: prayId, userId: userId, isDelete: isExist);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      _setState(Error(result as Failure));
      return;
    }

    //local에서도 증가
    _toggleFavoriteLocal(prayModel, userId, isExist);
    _setState(Loaded());
  }

  PrayModel? _getPrayById(String prayId) {
    try {
      return prayList.firstWhere((e) => e.id == prayId);
    } catch (e) {
      return null;
    }
  }

  bool? _isExistFavoriteUser(PrayModel pray, String userId) {
    late bool isExist;
    try {
      isExist =
          pray.prayUserList.where((element) => element == userId).isNotEmpty;
      return isExist;
    } catch (e) {
      return null;
    }
  }

  void _toggleFavoriteLocal(PrayModel prayModel, String userId, bool isExist) {
    if (isExist)
      prayModel.prayUserList.remove(userId);
    else
      prayModel.prayUserList.add(userId);
  }

  refresh() {
    _listState.refresh();
  }

  _setState(ViewState state) {
    _listState.value = state;
  }
}
