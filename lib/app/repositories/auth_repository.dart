import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/failure.dart';
import 'package:dream/app/data/models/user.dart';

abstract class AuthRepository {
  Stream<UserModel?> getAuthStateChanges();
  Future<Either<Failure, UserModel>> getUser(String uid);
  // Future<Either<ErrorModel, void>> createUser(UserCredential _userCredential);
  // Future<Either<ErrorModel, UserModel>> signInWithGoogle();
  // Future<Either<ErrorModel, UserModel>> signInWithKakao();
  Future<Either<Failure, UserModel>> signUpWithEmail(
      {required String email,
      required String password,
      required String name,
      required String group});
  Future<Either<Failure, UserModel>> signInWithEmail(
      String email, String password);

  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, String>> setProfileImage(
      {required String uid, required File image});
}
