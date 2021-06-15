import 'package:dartz/dartz.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/user.dart';

abstract class AuthRepository {
  Stream<UserModel> getAuthStateChanges();
  Future<Either<ErrorModel, UserModel>> getUser(String uid);
  // Future<Either<ErrorModel, void>> createUser(UserCredential _userCredential);
  // Future<Either<ErrorModel, UserModel>> signInWithGoogle();
  // Future<Either<ErrorModel, UserModel>> signInWithKakao();
  Future<Either<ErrorModel, UserModel>> signUpWithEmail(
      {required String email,
      required String password,
      required String name,
      required String group});
  Future<Either<ErrorModel, UserModel>> signInWithEmail(
      String email, String password);

  Future<Either<ErrorModel, void>> signOut();
}
