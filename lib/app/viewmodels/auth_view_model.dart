import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/failure.dart';
import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/app/data/models/user.dart';
import 'package:dream/app/repositories/auth_repository.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

enum FireAuthState {
  loading,
  signin,
  signout,
}

class AuthViewModel extends GetxController {
  late AuthRepository _authRepository;

  Rxn<ViewState?> _authState = Rxn<ViewState?>(Initial());

  Rxn<FireAuthState?> _fireauthStatus =
      Rxn<FireAuthState?>(FireAuthState.loading);
  FireAuthState? get fireauthState => _fireauthStatus.value;
  ViewState? get authState => _authState.value;
  Stream<ViewState?> get authStateStream => _authState.stream;

  Rxn<UserModel> _user = Rxn<UserModel>();
  // Rxn<User> _firebaseUser = Rxn<User>();
  UserModel? get user => _user.value;

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
    _setState(Loading());

    Either<Failure, UserModel> either =
        await _authRepository.signInWithEmail(email, password);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      _setState(Error(result as Failure));
      return;
    }

    _user.value = result as UserModel;
    _setState(Loaded());
  }

  Future<void> signUpWithEmail(
      {required String email,
      required String password,
      required String name,
      required String group}) async {
    _setState(Loading());
    Either<Failure, UserModel> either = await _authRepository.signUpWithEmail(
        email: email, password: password, name: name, group: group);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      _setState(Error(result as Failure));
      return;
    }

    _user.value = result as UserModel;
    _setState(Loaded());
  }

  Future<void> signOut() async {
    _setState(Loading());
    Either<Failure, void> either = await _authRepository.signOut();
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      _setState(Error(result as Failure));
      return;
    }
    _setState(Loaded());
  }

  Future<void> setProfileImage({required File imageFile}) async {
    _setState(Loading());
    late String imageUrl;

    Either<Failure, String> either =
        await _authRepository.setProfileImage(uid: user!.id, image: imageFile);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      _setState(Error(result as Failure));
      return;
    }

    imageUrl = result as String;

    _user.update((user) {
      user!.profileImageUrl = imageUrl;
    });
    _setState(Loaded());
  }

  void userUpdate(Function(UserModel?) update) {
    _user.update(update);
  }

  _setState(ViewState state) {
    _authState.value = state;
  }
}
