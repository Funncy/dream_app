import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/default_error_model.dart';
import 'package:dream/app/core/error/error_model.dart';
import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/repositories/pray_repository.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PraySendViewModel extends GetxController {
  late PrayRepository _prayRepository;
  Rx<ViewState> _sendState = ViewState.initial.obs;
  ViewState get sendState => _sendState.value;
  Stream<ViewState?> get sendStateStream => _sendState.stream;

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
    _sendState.refresh();
  }

  _setState(ViewState state) {
    _sendState.value = state;
  }

  _setErrorModel({ErrorModel? errorModel, String? code}) {
    if (errorModel != null)
      _errorModel = errorModel;
    else if (code != null) _errorModel = DefaultErrorModel(code: code);
  }
}
