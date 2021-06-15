import 'package:dream/core/data_status/viewmodel_result.dart';

abstract class AuthViewModel {
  Future<ViewModelResult> signInWithEmail(
      {required String email, required String password});
  Future<ViewModelResult> signUpWithEmail(
      {required String email, required String password});
  Future<ViewModelResult> signOut();
}
