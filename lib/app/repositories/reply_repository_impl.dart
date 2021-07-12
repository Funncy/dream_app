import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/failure.dart';
import 'package:dream/app/core/error/server_failure.dart';
import 'package:dream/app/data/models/reply.dart';
import 'package:dream/app/data/models/user.dart';
import 'package:dream/app/repositories/reply_repository.dart';

import 'package:dream/app/core/constants/constants.dart';

class ReplyRepositoryImpl extends ReplyRepository {
  late FirebaseFirestore _firebaseFirestore;
  // FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  ReplyRepositoryImpl({required FirebaseFirestore firebaseFirestore}) {
    _firebaseFirestore = firebaseFirestore;
  }

  @override
  Future<Either<Failure, void>> writeReply(
      {required String? noticeId,
      required String? commentId,
      required String replyIndex,
      required UserModel user,
      required String content}) async {
    try {
      //TODO: Notice Reference 혹은 comment Reference 필요
      var replyModel = ReplyModel(
          id: replyIndex,
          userId: user.id,
          nickName: user.name,
          profileImage: user.profileImageUrl ?? "",
          content: content,
          favoriteUserList: []);
      await _firebaseFirestore
          .collection(noticeCollectionName)
          .doc(noticeId!)
          .collection(commentCollectionName)
          .doc(commentId!)
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
    required String? noticeId,
    required String commentId,
    required ReplyModel replyModel,
  }) async {
    try {
      await _firebaseFirestore
          .collection(noticeCollectionName)
          .doc(noticeId!)
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
    required String? noticeId,
    required String? commentId,
    required ReplyModel reply,
    required String userId,
  }) async {
    try {
      await _firebaseFirestore
          .collection(noticeCollectionName)
          .doc(noticeId!)
          .collection(commentCollectionName)
          .doc(commentId!)
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
          .collection(noticeCollectionName)
          .doc(noticeId)
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
