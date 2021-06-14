import 'package:dartz/dartz.dart';
import 'package:dream/core/data_status/data_result.dart';
import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/pray.dart';
import 'package:dream/repositories/pray_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PrayViewModel extends GetxController {
  late PrayRepository _prayRepository;
  Rx<Status> _sendStatus = Status.initial.obs;
  Status get sendStatus => _sendStatus.value;
  set sendStatus(Status status) => _sendStatus.value = status;
  Rx<Status> _listStatus = Status.initial.obs;
  Status get listStatus => _listStatus.value;
  set listStatus(Status status) => _listStatus.value = status;

  List<PrayModel> prayList = [];

  PrayViewModel({required PrayRepository prayRepository}) {
    _prayRepository = prayRepository;
  }

  Future<DataResult> initPrayList() async {
    listStatus = Status.loading;
    Either<ErrorModel, List<PrayModel>?> either =
        await _prayRepository.initPublicPrayList();
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      listStatus = Status.error;
      return DataResult(isCompleted: false, errorModel: result as ErrorModel);
    }

    prayList.clear();
    prayList.addAll(either.getOrElse(() => null)!);
    if (prayList.length == 0)
      listStatus = Status.empty;
    else
      listStatus = Status.loaded;
    return DataResult(isCompleted: true);
  }

  Future<DataResult> getMorePrayList() async {
    listStatus = Status.loading;
    Either<ErrorModel, List<PrayModel>?> either = await _prayRepository
        .getMorePublicPrayList(prayList.last.documentReference);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      listStatus = Status.error;
      return DataResult(isCompleted: false, errorModel: result as ErrorModel);
    }

    prayList.addAll(either.getOrElse(() => null)!);

    listStatus = Status.loaded;
    return DataResult(isCompleted: true);
  }

  Future<DataResult> sendPray(
      {required String userId,
      required String title,
      required String content,
      required bool? isPublic}) async {
    sendStatus = Status.loading;
    Either<ErrorModel, void> either =
        await _prayRepository.sendPray(userId, title, content, isPublic);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      //TODO: Alert 보내기
      return DataResult(isCompleted: false, errorModel: result as ErrorModel);
    }
    sendStatus = Status.loaded;
    return DataResult(isCompleted: true);
  }

  void sendRefresh() {
    _sendStatus.refresh();
  }

  void listRefresh() {
    _listStatus.refresh();
  }
}
