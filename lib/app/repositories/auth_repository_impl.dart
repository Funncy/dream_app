import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/auth_failure.dart';
import 'package:dream/app/core/error/default_failure.dart';
import 'package:dream/app/core/error/failure.dart';
import 'package:dream/app/core/error/server_failure.dart';
import 'package:dream/app/data/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../core/constants/constants.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  late FirebaseAuth _firebaseAuth;
  late FirebaseFirestore _firebaseFirestore;
  late FirebaseStorage _firebaseStorage;

  AuthRepositoryImpl({
    required firebaseAuth,
    required firebaseFirestore,
    required firebaseStorage,
  }) {
    _firebaseAuth = firebaseAuth;
    _firebaseFirestore = firebaseFirestore;
    _firebaseStorage = firebaseStorage;
  }

  Stream<UserModel?> getAuthStateChanges() {
    //from <User?>Stream to <UserModel>Stream
    return _firebaseAuth.authStateChanges().transform<UserModel?>(
        StreamTransformer<User?, UserModel?>.fromHandlers(
            handleData: (user, sink) async {
      var either = await getUser(user?.uid ?? "None");
      var result = either.fold((l) => l, (r) => r);
      if (either.isLeft()) {
        sink.add(null);
        return;
      }
      sink.add(result as UserModel);
    }));
  }

  Future<Either<Failure, String>> setProfileImage(
      {required String uid, required File image}) async {
    try {
      var fileName = "$uid.jpeg";
      TaskSnapshot result = await _firebaseStorage
          .ref()
          .child("profile/$fileName")
          .putFile(image);
      String imageUrl = await result.ref.getDownloadURL();

      await _firebaseFirestore.collection(userCollectionName).doc(uid).update({
        'profile_image_url': imageUrl,
      });
      return Right(imageUrl);
    } catch (e) {
      return Left(ServerFailure(code: e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> getUser(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await _firebaseFirestore
          .collection(userCollectionName)
          .doc(uid)
          .get();

      if (documentSnapshot.data() == null) {
        throw Exception('documentSnapshot data == null');
      }

      return Right(UserModel.fromFirebase(documentSnapshot));
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(code: e.code));
    } catch (e) {
      return Left(DefaultFailure(code: e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> signUpWithEmail(
      {required String email,
      required String password,
      required String name,
      required String group}) async {
    try {
      UserCredential _userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      UserModel userModel = UserModel(
          id: _userCredential.user?.uid ?? "",
          email: _userCredential.user?.email ?? "",
          name: name,
          group: group);

      _firebaseFirestore
          .collection(userCollectionName)
          .doc(userModel.id)
          .set(userModel.toJson());

      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(code: e.code));
    } catch (e) {
      return Left(DefaultFailure(code: e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> signInWithEmail(
      String email, String password) async {
    try {
      UserCredential _userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      DocumentSnapshot documentSnapshot = await _firebaseFirestore
          .collection(userCollectionName)
          .doc(_userCredential.user?.uid)
          .get();

      if (documentSnapshot.data() == null)
        throw Exception('documentSnapshot data == null');

      UserModel userModel = UserModel.fromFirebase(documentSnapshot);
      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(code: e.code));
    } catch (e) {
      return Left(DefaultFailure(code: e.toString()));
    }
  }

  Future<Either<Failure, void>> signOut() async {
    try {
      //TODO: 추후 소셜 로그아웃도 추가해줘야함. 함수위에 얹어서
      await _firebaseAuth.signOut();
      return Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(code: e.code));
    } catch (e) {
      return Left(DefaultFailure(code: e.toString()));
    }
  }
}
