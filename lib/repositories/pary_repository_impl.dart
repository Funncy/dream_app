import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/core/error/server_error_model.dart';
import 'package:dream/models/pray.dart';
import 'package:dream/repositories/pray_repository.dart';

class PrayRepositoryImpl extends PrayRepository {
  late FirebaseFirestore _firebaseFirestore;

  PrayRepositoryImpl({required FirebaseFirestore firebaseFirestore}) {
    _firebaseFirestore = firebaseFirestore;
  }

  @override
  Future<Either<ErrorModel, List<PrayModel>?>> initPublicPrayList() async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('public_pray')
          .orderBy('updated_at')
          .limit(5)
          .get();
      List<PrayModel> result =
          querySnapshot.docs.map((e) => PrayModel.fromFirestore(e)).toList();
      return Right(result);
    } catch (e) {
      return Left(ServerErrorModel(code: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<PrayModel>?>> getMorePublicPrayList(
      DocumentReference? documentReference) async {
    try {
      DocumentSnapshot documentSnapshot = await documentReference!.get();
      var querySnapshot = await _firebaseFirestore
          .collection('public_pray')
          .orderBy('updated_at')
          .startAfterDocument(documentSnapshot)
          .limit(5)
          .get();
      List<PrayModel> result =
          querySnapshot.docs.map((e) => PrayModel.fromFirestore(e)).toList();
      return Right(result);
    } catch (e) {
      return Left(ServerErrorModel(code: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> sendPray(
      String userId, String title, String content, bool? isPublic) async {
    try {
      var model = PrayModel(userId: userId, title: title, content: content);
      CollectionReference collectionReference;
      if (isPublic!) {
        collectionReference = _firebaseFirestore.collection('public_pray');
      } else {
        collectionReference = _firebaseFirestore.collection('private_pray');
      }
      collectionReference.add(model.toJson());
      return Right(null);
    } catch (e) {
      return Left(ServerErrorModel(code: e.toString()));
    }
  }
}
