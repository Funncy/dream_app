import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/default_error_model.dart';
import 'package:dream/app/core/error/error_model.dart';
import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/app/data/models/user.dart';
import 'package:dream/repositories/auth_repository.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

enum FireAuthState {
  loading,
  signin,
  signout,
}

class AuthViewModel extends GetxController {
  late AuthRepository _authRepository;

  Rxn<ViewState?> _authState = Rxn<ViewState?>(ViewState.initial);

  Rxn<FireAuthState?> _fireauthStatus =
      Rxn<FireAuthState?>(FireAuthState.loading);
  FireAuthState? get fireauthState => _fireauthStatus.value;
  ViewState? get authState => _authState.value;
  Stream<ViewState?> get authStateStream => _authState.stream;

  Rxn<UserModel> _user = Rxn<UserModel>();
  // Rxn<User> _firebaseUser = Rxn<User>();
  UserModel? get user => _user.value;

  late ErrorModel _errorModel;
  ErrorModel? get errorModel => _errorModel;

  AuthViewModel({required authRepository}) {
    _authRepository = authRepository;
  }

  @override
  void onInit() {
    _authRepository.getAuthStateChanges().listen((user) {
      if (_user.value == null && user == null)
        _changeFireAuthStatus(status: FireAuthState.signout);
      if (_user.value != user) {
        _user.value = user;
        _changeFireAuthStatus();
      }
    });
    super.onInit();
  }

  void _changeFireAuthStatus({FireAuthState? status}) {
    if (status != null) {
      _fireauthStatus.value = status;
    } else {
      if (_user.value != null)
        _fireauthStatus.value = FireAuthState.signin;
      else
        _fireauthStatus.value = FireAuthState.signout;
    }
  }

  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    _setState(ViewState.loading);

    Either<ErrorModel, UserModel> either =
        await _authRepository.signInWithEmail(email, password);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      _setErrorModel(errorModel: result as ErrorModel);
      _setState(ViewState.error);
      return;
    }

    _user.value = result as UserModel;
    _setState(ViewState.loaded);
  }

  Future<void> signUpWithEmail(
      {required String email,
      required String password,
      required String name,
      required String group}) async {
    _setState(ViewState.loading);
    Either<ErrorModel, UserModel> either =
        await _authRepository.signUpWithEmail(
            email: email, password: password, name: name, group: group);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      _setErrorModel(errorModel: result as ErrorModel);
      _setState(ViewState.error);
      return;
    }

    _user.value = result as UserModel;
    _setState(ViewState.loaded);
  }

  Future<void> signOut() async {
    _setState(ViewState.loading);
    Either<ErrorModel, void> either = await _authRepository.signOut();
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      _setErrorModel(errorModel: result as ErrorModel);
      _setState(ViewState.error);
      return;
    }
    _setState(ViewState.loaded);
  }

  Future<void> setProfileImage({required File imageFile}) async {
    _setState(ViewState.loading);
    late String imageUrl;

    Either<ErrorModel, String> either =
        await _authRepository.setProfileImage(uid: user!.id, image: imageFile);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      _setErrorModel(errorModel: result as ErrorModel);
      _setState(ViewState.error);
      return;
    }

    imageUrl = result as String;

    _user.update((user) {
      user!.profileImageUrl = imageUrl;
    });
    _setState(ViewState.loaded);
  }

  _setState(ViewState state) {
    _authState.value = state;
  }

  void userUpdate(Function(UserModel?) update) {
    _user.update(update);
  }

  _setErrorModel({ErrorModel? errorModel, String? code}) {
    if (errorModel != null)
      _errorModel = errorModel;
    else if (code != null) _errorModel = DefaultErrorModel(code: code);
  }
}
