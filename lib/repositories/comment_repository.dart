import 'package:dartz/dartz.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/comment.dart';
import 'package:flutter/foundation.dart';

abstract class CommentRepository {
  Future<Either<ErrorModel, List<CommentModel>>> getCommentList(
      {@required String noticeId});
  Future<Either<ErrorModel, CommentModel>> getCommentById(
      {@required String noticeId, @required String commentId});
  Future<Either<ErrorModel, void>> updateCommentById(
      {@required String noticeId,
      @required String commentId,
      @required CommentModel commentModel});

  Future<Either<ErrorModel, void>> writeComment(
      {@required String noticeId,
      @required String userId,
      @required String content});

  Future<Either<ErrorModel, void>> deleteComment(
      {@required String noticeId, @required String commentId});

  Future<Either<ErrorModel, void>> toggleCommentFavorite(
      {@required String noticeId,
      @required String commentId,
      @required String userId,
      @required bool isDelete});
}
