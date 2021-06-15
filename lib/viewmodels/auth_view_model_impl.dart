import 'package:dartz/dartz.dart';
import 'package:dream/core/data_status/data_result.dart';
import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/core/data_status/viewmodel_result.dart';
import 'package:dream/core/error/default_error_model.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/user.dart';
import 'package:dream/repositories/auth_repository.dart';
import 'package:dream/viewmodels/auth_view_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'mixin/view_model_pipe_line_mixin.dart';

class AuthViewModelImpl extends GetxController
    with ViewModelPipeLineMixin
    implements AuthViewModel {
  late AuthRepository _authRepository;
  Rxn<Status?> _signInStatus = Rxn<Status?>(Status.initial);
  Rxn<Status?> _signUpStatus = Rxn<Status?>(Status.initial);
  Status? get signInStatus => _signInStatus.value;
  set signInStatus(Status? status) => _signInStatus.value = status;
  Status? get signUpStatus => _signUpStatus.value;
  set signUpStatus(Status? status) => _signUpStatus.value = status;

  Rxn<UserModel> _user = Rxn<UserModel>();
  // Rxn<User> _firebaseUser = Rxn<User>();
  UserModel? get user => _user.value;

  AuthViewModelImpl({required authRepository}) {
    _authRepository = authRepository;
  }

  @override
  void onInit() {
    _user.bindStream(_authRepository.getAuthStateChanges());
    super.onInit();
  }

  Future<ViewModelResult> signInWithEmail(
          {required String email, required String password}) =>
      process(functionList: [
        (_) => _signInWithEmail(email: email, password: password),
        (data) => setUser(data['user']),
      ], status: _signInStatus);

  Future<ViewModelResult> signUpWithEmail(
          {required String email,
          required String password,
          required String name,
          required String group}) =>
      process(functionList: [
        (_) => _signUpWithEamil(
            email: email, password: password, name: name, group: group),
        (data) => setUser(data['user']),
      ], status: _signUpStatus);

  Future<ViewModelResult> signOut() =>
      process(functionList: [(_) => _signOut()], status: null);

  /*
  *
  *
  * 부품 함수들
  *
  *
  */

  ///_signInWithEmail => data is UserModel
  /// ```
  /// UserModel userModel = data['user']
  /// ```
  Future<DataResult> _signInWithEmail(
      {required String email, required String password}) async {
    Either<ErrorModel, UserModel> either =
        await _authRepository.signInWithEmail(email, password);

    var result = either.fold((l) => l, (r) => r);

    if (either.isLeft()) {
      return DataResult(isCompleted: false, errorModel: result as ErrorModel);
    }
    // setUser(result as UserModel);
    return DataResult(isCompleted: true, data: {'user': result});
  }

  ///_signUpWithEamil => data is UserModel
  /// ```
  /// UserModel userModel = data['user']
  /// ```
  Future<DataResult> _signUpWithEamil(
      {required String email,
      required String password,
      required String name,
      required String group}) async {
    Either<ErrorModel, UserModel> either =
        await _authRepository.signUpWithEmail(
            email: email, password: password, name: name, group: group);
    var result = either.fold((l) => l, (r) => r);

    if (either.isLeft()) {
      return DataResult(isCompleted: false, errorModel: result as ErrorModel);
    }
    return DataResult(isCompleted: true, data: {'user': result});
  }

  DataResult setUser(UserModel user) {
    try {
      _user.value = user;
      return DataResult(isCompleted: true);
    } catch (e) {
      return DataResult(
          isCompleted: false,
          errorModel: DefaultErrorModel(code: e.toString()));
    }
  }

  ///_signOut => data is void
  Future<DataResult> _signOut() async {
    Either<ErrorModel, void> either = await _authRepository.signOut();
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      return DataResult(isCompleted: false, errorModel: result as ErrorModel);
    }
    return DataResult(isCompleted: true);
  }
}
