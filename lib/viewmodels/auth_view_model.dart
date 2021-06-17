import 'dart:io';

import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/core/data_status/viewmodel_result.dart';

abstract class AuthViewModel {
  Status? get signInStatus;
  set signInStatus(Status? status);
  Status? get signUpStatus;
  set signUpStatus(Status? status);

  Future<ViewModelResult> signInWithEmail(
      {required String email, required String password});
  Future<ViewModelResult> signUpWithEmail(
      {required String email,
      required String password,
      required String name,
      required String group});
  Future<ViewModelResult> signOut();
  Future<ViewModelResult> setProfileImage({required File imageFile});
}
