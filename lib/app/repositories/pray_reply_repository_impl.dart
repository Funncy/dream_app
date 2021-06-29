import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dream/app/core/constants/constants.dart';
import 'package:dream/app/core/error/failure.dart';
import 'package:dream/app/core/error/server_failure.dart';
import 'package:dream/app/data/models/reply.dart';
import 'package:dream/app/repositories/pray_reply_repository.dart';

class PrayReplyRepositoryImpl implements PrayReplyRepository {
  late FirebaseFirestore _firebaseFirestore;

  PrayReplyRepositoryImpl({required FirebaseFirestore firebaseFirestore}) {
    _firebaseFirestore = firebaseFirestore;
  }

  @override
  Future<Either<Failure, void>> writeReply(
      {required String prayId,
      required String commentId,
      required String replyIndex,
      required String userId,
      required String content}) async {
    try {
      //TODO: Notice Reference 혹은 comment Reference 필요
      var replyModel = ReplyModel(
          id: replyIndex,
          userId: userId,
          content: content,
          favoriteUserList: []);
      await _firebaseFirestore
          .collection(publicPrayCollectionName)
          .doc(prayId)
          .collection(commentCollectionName)
          .doc(commentId)
          .update({
        'reply_list': FieldValue.arrayUnion([replyModel.toJson()])
      });
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(code: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReply({
    required String prayId,
    required String commentId,
    required ReplyModel replyModel,
  }) async {
    try {
      await _firebaseFirestore
          .collection(publicPrayCollectionName)
          .doc(prayId)
          .collection(commentCollectionName)
          .doc(commentId)
          .update({
        'reply_list': FieldValue.arrayRemove([replyModel.toJson()])
      });
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(code: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleReplyFavorite({
    required String prayId,
    required String commentId,
    required ReplyModel reply,
    required String userId,
  }) async {
    try {
      await _firebaseFirestore
          .collection(publicPrayCollectionName)
          .doc(prayId)
          .collection(commentCollectionName)
          .doc(commentId)
          .update({
        'reply_list': FieldValue.arrayRemove([reply.toJson()])
      });
      //이미 유저 있다면 삭제 없다면 추가
      if (reply.favoriteUserList!.where((e) => e == userId).isEmpty)
        reply.favoriteUserList!.add(userId);
      else
        reply.favoriteUserList!.remove(userId);

      var modifyReply = reply.toJson();

      await _firebaseFirestore
          .collection(publicPrayCollectionName)
          .doc(prayId)
          .collection(commentCollectionName)
          .doc(commentId)
          .update({
        'reply_list': FieldValue.arrayUnion([modifyReply])
      });
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(code: e.toString()));
    }
  }
}
