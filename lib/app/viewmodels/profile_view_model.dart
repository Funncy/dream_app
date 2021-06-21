import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/default_error_model.dart';
import 'package:dream/app/core/error/error_model.dart';
import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/app/repositories/auth_repository.dart';
import 'package:dream/app/viewmodels/auth_view_model.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ProfileViewModel extends GetxController {
  late AuthRepository _authRepository;
  late AuthViewModel _authViewModel;

  Rxn<ViewState?> _profileState = Rxn<ViewState?>(ViewState.initial);
  ViewState? get profileState => _profileState.value;
  Stream<ViewState?> get profileStateStream => _profileState.stream;

  late ErrorModel _errorModel;
  ErrorModel? get errorModel => _errorModel;

  ProfileViewModel({required authRepository, required authViewModel}) {
    _authRepository = authRepository;
    _authViewModel = authViewModel;
  }

  Future<void> setProfileImage(
      {required String userId, required File imageFile}) async {
    _setState(ViewState.loading);
    late String imageUrl;

    Either<ErrorModel, String> either =
        await _authRepository.setProfileImage(uid: userId, image: imageFile);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      _setErrorModel(errorModel: result as ErrorModel);
      _setState(ViewState.error);
      return;
    }

    imageUrl = result as String;

    _authViewModel.userUpdate((user) {
      user!.profileImageUrl = imageUrl;
    });
    _setState(ViewState.loaded);
  }

  void refresh() {
    _profileState.refresh();
  }

  _setState(ViewState state) {
    _profileState.value = state;
  }

  _setErrorModel({ErrorModel? errorModel, String? code}) {
    if (errorModel != null)
      _errorModel = errorModel;
    else if (code != null) _errorModel = DefaultErrorModel(code: code);
  }
}
