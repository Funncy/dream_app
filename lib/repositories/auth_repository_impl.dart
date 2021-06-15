import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dream/core/error/default_error_model.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/core/error/fire_auth_error_model.dart';
import 'package:dream/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  late FirebaseAuth _firebaseAuth;
  late FirebaseFirestore _firebaseFirestore;

  AuthRepositoryImpl({
    required firebaseAuth,
    required firebaseFirestore,
  }) {
    _firebaseAuth = firebaseAuth;
    _firebaseFirestore = firebaseFirestore;
  }

  Stream<UserModel> getAuthStateChanges() {
    //from <User?>Stream to <UserModel>Stream
    return _firebaseAuth.authStateChanges().transform<UserModel>(
        StreamTransformer<User?, UserModel>.fromHandlers(
            handleData: (user, sink) async {
      var either = await getUser(user?.uid ?? "None");
      var result = either.fold((l) => l, (r) => r);
      if (either.isLeft()) {
        sink.addError(result);
        return;
      }
      sink.add(result as UserModel);
    }));
  }

  Future<Either<ErrorModel, UserModel>> getUser(String uid) async {
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
      return Left(FireAuthErrorModel(code: e.code));
    } catch (e) {
      return Left(DefaultErrorModel(code: e.toString()));
    }
  }

  // Future<Either<ErrorModel, void>> createUser(
  //     UserCredential _userCredential) async {
  //   try {
  //     UserModel user = UserModel(
  //         id: _userCredential.user?.uid ?? "",
  //         email: _userCredential.user?.email ?? "",
  //         nickName: _userCredential.user?.displayName ?? "");
  //     //TODO: 콜랙션 이름도 따로 관리해야함.
  //     _firebaseFirestore
  //         .collection(userCollectionName)
  //         .doc(user.id)
  //         .set(user.toJson());
  //     return Right(null);
  //   } on FirebaseAuthException catch (e) {
  //     return Left(FireAuthErrorModel(code: e.code));
  //   } catch (e) {
  //     return Left(DefaultErrorModel(code: e.toString()));
  //   }
  // }

  // Future<String> _verifyToken(String kakaoToken) async {
  //   try {
  //     final HttpsCallable callable =
  //         _firebaseFunctions.httpsCallable('kakaoToken');

  //     final HttpsCallableResult result = await callable.call(
  //       <String, dynamic>{
  //         'access_token': kakaoToken,
  //       },
  //     );

  //     if (result.data == null) {
  //       return Future.error('error');
  //     }
  //     return result.data;
  //   } catch (e) {
  //     return Future.error(e);
  //   }
  // }

  // //TODO: Web으로 연결됬을 경우 진행이 안됨.
  // Future<Either<ErrorModel, UserModel>> signInWithKakao() async {
  //   try {
  //     final bool installed = await kakao.isKakaoTalkInstalled();
  //     final String authCode = installed
  //         ? await kakao.AuthCodeClient.instance.requestWithTalk()
  //         : await kakao.AuthCodeClient.instance.request();
  //     kakao.AccessTokenResponse token =
  //         await kakao.AuthApi.instance.issueAccessToken(authCode);

  //     var customToken = await _verifyToken(token.accessToken);
  //     UserCredential userCredential =
  //         await _firebaseAuth.signInWithCustomToken(customToken);
  //     kakao.AccessTokenStore.instance.toStore(token);

  //     final kakao.User userData = await kakao.UserApi.instance.me();
  //     UserModel user = UserModel(
  //       id: userCredential.user!.uid,
  //       email: userData.kakaoAccount?.email ?? "",
  //       name: userData.kakaoAccount?.profile?.nickname ?? "",
  //       nickName: userData.kakaoAccount?.profile?.nickname,
  //       profileImageUrl: userData.kakaoAccount?.profile?.thumbnailImageUrl,
  //     );

  //     _firebaseFirestore.collection(userCollectionName).doc(user.id).set(user.toJson());
  //     return Right(user);
  //   } on FirebaseAuthException catch (e) {
  //     return Left(FireAuthErrorModel(code: e.code));
  //   } catch (e) {
  //     return Left(DefaultErrorModel());
  //   }
  // }

  // Future<Either<ErrorModel, UserModel>> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser?.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken,
  //       idToken: googleAuth?.idToken,
  //     );

  //     UserCredential _userCredential =
  //         await _firebaseAuth.signInWithCredential(credential);

  //     UserModel user = UserModel(
  //         id: _userCredential.user?.uid ?? "",
  //         email: _userCredential.user?.email ?? "",
  //         name: _userCredential.user?.displayName ?? "");

  //     _firebaseFirestore.collection(userCollectionName).doc(user.id).set(user.toJson());

  //     return Right(user);
  //   } on FirebaseAuthException catch (e) {
  //     return Left(FireAuthErrorModel(code: e.code));
  //   } catch (e) {
  //     return Left(DefaultErrorModel());
  //   }
  // }

  Future<Either<ErrorModel, UserModel>> signUpWithEmail(
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
      return Left(FireAuthErrorModel(code: e.code));
    } catch (e) {
      return Left(DefaultErrorModel(code: e.toString()));
    }
  }

  Future<Either<ErrorModel, UserModel>> signInWithEmail(
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
      return Left(FireAuthErrorModel(code: e.code));
    } catch (e) {
      return Left(DefaultErrorModel(code: e.toString()));
    }
  }

  Future<Either<ErrorModel, void>> signOut() async {
    try {
      //TODO: 추후 소셜 로그아웃도 추가해줘야함. 함수위에 얹어서
      await _firebaseAuth.signOut();
      return Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(FireAuthErrorModel(code: e.code));
    } catch (e) {
      return Left(DefaultErrorModel(code: e.toString()));
    }
  }
}
