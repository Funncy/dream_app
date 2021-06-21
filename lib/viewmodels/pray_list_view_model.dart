import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/default_error_model.dart';
import 'package:dream/app/core/error/error_model.dart';
import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/app/data/models/pray.dart';
import 'package:dream/repositories/pray_repository.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PrayListViewModel extends GetxController {
  late PrayRepository _prayRepository;
  Rx<ViewState> _listStatus = ViewState.initial.obs;
  ViewState get listStatus => _listStatus.value;
  Stream<ViewState?> get listStatusStream => _listStatus.stream;

  List<PrayModel> prayList = [];

  ErrorModel? _errorModel;
  ErrorModel? get errorModel => _errorModel;

  PrayListViewModel({required PrayRepository prayRepository}) {
    _prayRepository = prayRepository;
  }

  Future<void> getPrayList() async {
    _setState(ViewState.loading);
    Either<ErrorModel, List<PrayModel>?> either =
        await _prayRepository.initPublicPrayList();
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      _setErrorModel(errorModel: result as ErrorModel);
      _setState(ViewState.error);
      return;
    }
    prayList.clear();
    prayList.addAll(either.getOrElse(() => null)!);
    _setState(ViewState.loaded);
  }

  Future<void> getMorePrayList() async {
    _setState(ViewState.loading);
    Either<ErrorModel, List<PrayModel>?> either = await _prayRepository
        .getMorePublicPrayList(prayList.last.documentReference);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      _setErrorModel(errorModel: result as ErrorModel);
      _setState(ViewState.error);
      return;
    }

    prayList.addAll(result as List<PrayModel>);
    _setState(ViewState.loaded);
  }

  refresh() {
    _listStatus.refresh();
  }

  _setState(ViewState state) {
    _listStatus.value = state;
  }

  _setErrorModel({ErrorModel? errorModel, String? code}) {
    if (errorModel != null)
      _errorModel = errorModel;
    else if (code != null) _errorModel = DefaultErrorModel(code: code);
  }
}
