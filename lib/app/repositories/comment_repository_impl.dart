import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/error_model.dart';
import 'package:dream/app/core/error/server_error_model.dart';
import 'package:dream/app/data/models/comment.dart';
import 'package:dream/app/repositories/comment_repository.dart';

import 'package:dream/app/core/constants/constants.dart';

class CommentRepositoryImpl extends CommentRepository {
  late FirebaseFirestore _firebaseFirestore;
  // FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  CommentRepositoryImpl({required FirebaseFirestore firebaseFirestore}) {
    _firebaseFirestore = firebaseFirestore;
  }

  @override
  Future<Either<ErrorModel, List<CommentModel>>> getCommentList(
      {required String? noticeId}) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection(noticeCollectionName)
          .doc(noticeId!)
          .collection(commentCollectionName)
          .orderBy('updated_at')
          .get();
      List<CommentModel> result =
          querySnapshot.docs.map((e) => CommentModel.fromFirestore(e)).toList();
      return Right(result);
    } catch (e) {
      return Left(ServerErrorModel(code: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, CommentModel?>> getCommentById(
      {required String? noticeId, required String? commentId}) async {
    try {
      DocumentSnapshot documentSnapshot = await _firebaseFirestore
          .collection(noticeCollectionName)
          .doc(noticeId!)
          .collection(commentCollectionName)
          .doc(commentId!)
          .get();
      return Right(CommentModel.fromFirestore(documentSnapshot));
    } catch (e) {
      return Left(ServerErrorModel(code: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> updateCommentById(
      {required String? noticeId,
      required String? commentId,
      required CommentModel commentModel}) async {
    try {
      await _firebaseFirestore
          .collection(noticeCollectionName)
          .doc(noticeId!)
          .collection(commentCollectionName)
          .doc(commentId!)
          .update(commentModel.toJson());
      return Right(null);
    } catch (e) {
      return Left(ServerErrorModel(code: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> writeComment(
      {required String? noticeId,
      required String userId,
      required String content}) async {
    try {
      var commentModel = CommentModel(
          id: null,
          userId: userId,
          content: content,
          replyIndex: 0,
          replyList: [],
          favoriteUserList: [],
          documentReference: null);
      commentModel.createdAt = Timestamp.now().toDate();
      commentModel.updatedAt = Timestamp.now().toDate();

      _firebaseFirestore
          .collection(noticeCollectionName)
          .doc(noticeId!)
          .collection(commentCollectionName)
          .add(commentModel.toJson());

      return Right(null);
    } catch (e) {
      return Left(ServerErrorModel(code: e.toString()));
    }
  }

  Future<Either<ErrorModel, void>> deleteComment(
      {required String? noticeId, required String commentId}) async {
    try {
      await _firebaseFirestore
          .collection(noticeCollectionName)
          .doc(noticeId!)
          .collection(commentCollectionName)
          .doc(commentId + 'qweqwe')
          .delete();

      return Right(null);
    } catch (e) {
      return Left(ServerErrorModel(code: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> toggleCommentFavorite(
      {required String? noticeId,
      required String? commentId,
      required String userId,
      required bool isDelete}) async {
    try {
      //TODO : orderby 추가 필요 (모든 곳에)
      FieldValue fieldValue;
      if (isDelete)
        fieldValue = FieldValue.arrayRemove([userId]);
      else
        fieldValue = FieldValue.arrayUnion([userId]);
      await _firebaseFirestore
          .collection(noticeCollectionName)
          .doc(noticeId!)
          .collection(commentCollectionName)
          .doc(commentId!)
          .update({'favorite_user_list': fieldValue});
      return Right(null);
    } catch (e) {
      return Left(ServerErrorModel(code: e.toString()));
    }
  }
}