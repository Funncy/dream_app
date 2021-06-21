import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dream/core/data_status/fireauth_status.dart';
import 'package:dream/core/data_status/view_state.dart';
import 'package:dream/core/error/default_error_model.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/user.dart';
import 'package:dream/repositories/auth_repository.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AuthViewModel extends GetxController {
  late AuthRepository _authRepository;

  Rxn<ViewState?> _authStatus = Rxn<ViewState?>(ViewState.initial);

  Rxn<FireAuthStatus?> _fireauthStatus =
      Rxn<FireAuthStatus?>(FireAuthStatus.loading);
  FireAuthStatus? get fireauthStatus => _fireauthStatus.value;
  ViewState? get authStatus => _authStatus.value;
  set authStatus(ViewState? status) => _authStatus.value = status;
  Stream<ViewState?> get authStatusStream => _authStatus.stream;

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
        _changeFireAuthStatus(status: FireAuthStatus.signout);
      if (_user.value != user) {
        _user.value = user;
        _changeFireAuthStatus();
      }
    });
    super.onInit();
  }

  void _changeFireAuthStatus({FireAuthStatus? status}) {
    if (status != null) {
      _fireauthStatus.value = status;
    } else {
      if (_user.value != null)
        _fireauthStatus.value = FireAuthStatus.signin;
      else
        _fireauthStatus.value = FireAuthStatus.signout;
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
    _authStatus.value = state;
  }

  _setErrorModel({ErrorModel? errorModel, String? code}) {
    if (errorModel != null)
      _errorModel = errorModel;
    else if (code != null) _errorModel = DefaultErrorModel(code: code);
  }
}
