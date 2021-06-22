import 'package:dartz/dartz.dart';
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

  refresh() {
    _listState.refresh();
  }

  _setState(ViewState state) {
    _listState.value = state;
  }
}
