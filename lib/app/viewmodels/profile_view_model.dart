import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/failure.dart';
import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/app/repositories/auth_repository.dart';
import 'package:dream/app/viewmodels/auth_view_model.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ProfileViewModel extends GetxController {
  late AuthRepository _authRepository;
  late AuthViewModel _authViewModel;

  Rxn<ViewState?> _profileState = Rxn<ViewState?>(Initial());
  ViewState? get profileState => _profileState.value;
  Stream<ViewState?> get profileStateStream => _profileState.stream;

  ProfileViewModel({required authRepository, required authViewModel}) {
    _authRepository = authRepository;
    _authViewModel = authViewModel;
  }

  Future<void> setProfileImage(
      {required String userId, required File imageFile}) async {
    _setState(Loading());
    late String imageUrl;

    Either<Failure, String> either =
        await _authRepository.setProfileImage(uid: userId, image: imageFile);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      _setState(Error(result as Failure));
      return;
    }

    imageUrl = result as String;

    _authViewModel.userUpdate((user) {
      user!.profileImageUrl = imageUrl;
    });
    _setState(Loaded());
  }

  void refresh() {
    _profileState.refresh();
  }

  _setState(ViewState state) {
    _profileState.value = state;
  }
}
