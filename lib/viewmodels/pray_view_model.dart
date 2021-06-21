import 'package:dartz/dartz.dart';
import 'package:dream/core/data_status/data_result.dart';
import 'package:dream/core/data_status/view_state.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/pray.dart';
import 'package:dream/repositories/pray_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PrayViewModel extends GetxController {
  late PrayRepository _prayRepository;
  Rx<ViewState> _sendStatus = ViewState.initial.obs;
  ViewState get sendStatus => _sendStatus.value;
  set sendStatus(ViewState status) => _sendStatus.value = status;
  Rx<ViewState> _listStatus = ViewState.initial.obs;
  ViewState get listStatus => _listStatus.value;
  set listStatus(ViewState status) => _listStatus.value = status;

  List<PrayModel> prayList = [];

  PrayViewModel({required PrayRepository prayRepository}) {
    _prayRepository = prayRepository;
  }

  Future<DataResult> initPrayList() async {
    listStatus = ViewState.loading;
    Either<ErrorModel, List<PrayModel>?> either =
        await _prayRepository.initPublicPrayList();
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      listStatus = ViewState.error;
      return DataResult(isCompleted: false, errorModel: result as ErrorModel);
    }

    prayList.clear();
    prayList.addAll(either.getOrElse(() => null)!);

    listStatus = ViewState.loaded;
    return DataResult(isCompleted: true);
  }

  Future<DataResult> getMorePrayList() async {
    listStatus = ViewState.loading;
    Either<ErrorModel, List<PrayModel>?> either = await _prayRepository
        .getMorePublicPrayList(prayList.last.documentReference);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      listStatus = ViewState.error;
      return DataResult(isCompleted: false, errorModel: result as ErrorModel);
    }

    prayList.addAll(either.getOrElse(() => null)!);

    listStatus = ViewState.loaded;
    return DataResult(isCompleted: true);
  }

  Future<DataResult> sendPray(
      {required String userId,
      required String title,
      required String content,
      required bool? isPublic}) async {
    sendStatus = ViewState.loading;
    Either<ErrorModel, void> either =
        await _prayRepository.sendPray(userId, title, content, isPublic);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      //TODO: Alert 보내기
      return DataResult(isCompleted: false, errorModel: result as ErrorModel);
    }
    sendStatus = ViewState.loaded;
    return DataResult(isCompleted: true);
  }

  void sendRefresh() {
    _sendStatus.refresh();
  }

  void listRefresh() {
    _listStatus.refresh();
  }
}
