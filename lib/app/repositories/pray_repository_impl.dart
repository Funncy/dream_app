import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dream/app/core/constants/constants.dart';
import 'package:dream/app/core/error/failure.dart';
import 'package:dream/app/core/error/server_failure.dart';
import 'package:dream/app/data/models/pray.dart';
import 'package:dream/app/data/models/user.dart';
import 'package:dream/app/repositories/pray_repository.dart';

class PrayRepositoryImpl extends PrayRepository {
  late FirebaseFirestore _firebaseFirestore;

  PrayRepositoryImpl({required FirebaseFirestore firebaseFirestore}) {
    _firebaseFirestore = firebaseFirestore;
  }

  @override
  Future<Either<Failure, List<PrayModel>?>> initPublicPrayList() async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection(publicPrayCollectionName)
          .orderBy('updated_at')
          .limit(5)
          .get();
      List<PrayModel> result =
          querySnapshot.docs.map((e) => PrayModel.fromFirestore(e)).toList();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(code: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PrayModel>?>> getMorePublicPrayList(
      DocumentReference? documentReference) async {
    try {
      DocumentSnapshot documentSnapshot = await documentReference!.get();
      var querySnapshot = await _firebaseFirestore
          .collection(publicPrayCollectionName)
          .orderBy('updated_at')
          .startAfterDocument(documentSnapshot)
          .limit(5)
          .get();
      List<PrayModel> result =
          querySnapshot.docs.map((e) => PrayModel.fromFirestore(e)).toList();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(code: e.toString()));
    }
  }

  Future<Either<Failure, void>> togglePrayFavorite(
      {required String prayId,
      required String userId,
      required bool isDelete}) async {
    try {
      FieldValue fieldValue;
      if (isDelete)
        fieldValue = FieldValue.arrayRemove([userId]);
      else
        fieldValue = FieldValue.arrayUnion([userId]);
      _firebaseFirestore
          .collection(publicPrayCollectionName)
          .doc(prayId)
          .update({'pray_user_list': fieldValue});
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(code: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPray(
      UserModel user, String title, String content, bool? isPublic) async {
    try {
      var model = PrayModel(
          userId: user.id,
          nickName: user.name,
          profileImage: user.profileImageUrl ?? "",
          title: title,
          content: content);
      CollectionReference collectionReference;
      if (isPublic!) {
        collectionReference =
            _firebaseFirestore.collection(publicPrayCollectionName);
      } else {
        collectionReference =
            _firebaseFirestore.collection(privatePrayCollectionName);
      }
      collectionReference.add(model.toJson());
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(code: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCommentCount(
      {required String prayId, bool isIncreasement = true}) async {
    try {
      late int count;
      if (isIncreasement)
        count = 1;
      else
        count = -1;
      //notice doc?????? commentCount ??????
      DocumentReference documentReference =
          _firebaseFirestore.collection(publicPrayCollectionName).doc(prayId);
      await _firebaseFirestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (!snapshot.exists) {
          throw Exception("Comment does not exist!");
        }

        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        int? newCommentCount = (data['comment_count'] as int) + count;

        transaction
            .update(documentReference, {'comment_count': newCommentCount});

        return newCommentCount;
      });
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(code: e.toString()));
    }
  }
}
