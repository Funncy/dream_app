import 'package:dartz/dartz.dart';
import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/pray.dart';
import 'package:dream/repositories/pray_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PrayViewModel extends GetxController {
  PrayRepository _prayRepository;
  Rx<Status> _sendStatus = Status.initial.obs;
  get sendStatus => _sendStatus.value;
  set sendStatus(Status status) => _sendStatus.value = status;
  Rx<Status> _listStatus = Status.initial.obs;
  get listStatus => _listStatus.value;
  set listStatus(Status status) => _listStatus.value = status;

  List<PrayModel> prayList = [];

  PrayViewModel({@required PrayRepository prayRepository}) {
    _prayRepository = prayRepository;
  }

  Future<void> initPrayList() async {
    listStatus.value = Status.loading;
    Either<ErrorModel, List<PrayModel>> either =
        await _prayRepository.initPublicPrayList();
    if (either.isLeft()) {
      listStatus.value = Status.error;
      return;
    }

    prayList.clear();
    prayList.addAll(either.getOrElse(() => null));
    if (prayList.length == 0)
      listStatus.value = Status.empty;
    else
      listStatus.value = Status.loaded;
  }

  Future<void> addPrayList() async {
    listStatus.value = Status.loading;
    Either<ErrorModel, List<PrayModel>> either = await _prayRepository
        .addPublicPrayList(prayList.last.documentReference);
    if (either.isLeft()) {
      listStatus.value = Status.error;
      return;
    }

    prayList.addAll(either.getOrElse(() => null));

    listStatus.value = Status.loaded;
  }

  Future<void> sendPray(
      {@required String userId,
      @required String title,
      @required String content,
      @required bool isPublic}) async {
    sendStatus.value = Status.loading;
    Either<ErrorModel, void> either =
        await _prayRepository.sendPray(userId, title, content, isPublic);
    if (either.isLeft()) {
      //TODO: Alert 보내기
      return;
    }
    sendStatus = Status.loaded;
  }

  void sendRefresh() {
    sendStatus.refresh();
  }

  void listRefresh() {
    listStatus.refresh();
  }
}
