import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/default_error_model.dart';
import 'package:dream/app/core/error/error_model.dart';
import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/repositories/pray_repository.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PraySendViewModel extends GetxController {
  late PrayRepository _prayRepository;
  Rx<ViewState> _sendStatus = ViewState.initial.obs;
  ViewState get sendStatus => _sendStatus.value;
  Stream<ViewState?> get sendStatusStream => _sendStatus.stream;

  ErrorModel? _errorModel;
  ErrorModel? get errorModel => _errorModel;

  PraySendViewModel({required PrayRepository prayRepository}) {
    _prayRepository = prayRepository;
  }

  Future<void> sendPray(
      {required String userId,
      required String title,
      required String content,
      required bool? isPublic}) async {
    _setState(ViewState.loading);
    Either<ErrorModel, void> either =
        await _prayRepository.sendPray(userId, title, content, isPublic);
    either.fold((l) {
      _setErrorModel(errorModel: l);
      _setState(ViewState.error);
    }, (r) => r);
    if (either.isLeft()) return;

    _setState(ViewState.loaded);
  }

  refresh() {
    _sendStatus.refresh();
  }

  _setState(ViewState state) {
    _sendStatus.value = state;
  }

  _setErrorModel({ErrorModel? errorModel, String? code}) {
    if (errorModel != null)
      _errorModel = errorModel;
    else if (code != null) _errorModel = DefaultErrorModel(code: code);
  }
}
