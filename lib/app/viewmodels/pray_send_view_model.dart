import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/failure.dart';
import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/app/repositories/pray_repository.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PraySendViewModel extends GetxController {
  late PrayRepository _prayRepository;
  Rxn<ViewState> _sendState = Rxn(Initial());
  ViewState? get sendState => _sendState.value;
  Stream<ViewState?> get sendStateStream => _sendState.stream;

  PraySendViewModel({required PrayRepository prayRepository}) {
    _prayRepository = prayRepository;
  }

  Future<void> sendPray(
      {required String userId,
      required String title,
      required String content,
      required bool? isPublic}) async {
    _setState(Loading());
    Either<Failure, void> either =
        await _prayRepository.sendPray(userId, title, content, isPublic);
    either.fold((l) {
      _setState(Error(l));
    }, (r) => r);
    if (either.isLeft()) return;

    _setState(Loaded());
  }

  refresh() {
    _sendState.refresh();
  }

  _setState(ViewState state) {
    _sendState.value = state;
  }
}
