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
  //화면용 상태
  Rxn<ViewState?> _loginState = Rxn<ViewState?>(Initial());
  Rxn<ViewState?> _signUpState = Rxn<ViewState?>(Initial());
  Rxn<ViewState?> _signOutState = Rxn<ViewState?>(Initial());
  //root Page용 firebase auth 로그인 상태
  Rxn<FireAuthState?> _fireauthStatus =
      Rxn<FireAuthState?>(FireAuthState.loading);

  FireAuthState? get fireauthState => _fireauthStatus.value;
  ViewState? get loginState => _loginState.value;
  ViewState? get signUpState => _signUpState.value;
  ViewState? get signOutState => _signOutState.value;
  //Firebase통해서 들어오는 유저 데이터
  Rxn<UserModel> _user = Rxn<UserModel>();
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
    _setState(_loginState, Loading());

    Either<Failure, UserModel> either =
        await _authRepository.signInWithEmail(email, password);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      _setState(_loginState, Error(result as Failure));
      return;
    }

    _user.value = result as UserModel;
    _setState(_loginState, Loaded());
  }

  Future<void> signUpWithEmail(
      {required String email,
      required String password,
      required String name,
      required String group}) async {
    _setState(_signUpState, Loading());
    Either<Failure, UserModel> either = await _authRepository.signUpWithEmail(
        email: email, password: password, name: name, group: group);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      _setState(_signUpState, Error(result as Failure));
      return;
    }

    _user.value = result as UserModel;
    _setState(_signUpState, Loaded());
  }

  Future<void> signOut() async {
    _setState(_signOutState, Loading());
    Either<Failure, void> either = await _authRepository.signOut();
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      _setState(_signOutState, Error(result as Failure));
      return;
    }
    _setState(_signOutState, Loaded());
  }

  void userUpdate(Function(UserModel?) update) {
    _user.update(update);
  }

  _setState(Rxn authState, ViewState state) {
    authState.value = state;
  }
}
