import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/failure.dart';
import 'package:dream/app/data/models/comment.dart';

abstract class CommentRepository {
  Future<Either<Failure, List<CommentModel>>> getCommentList(
      {required String? noticeId});
  Future<Either<Failure, CommentModel?>> getCommentById(
      {required String? noticeId, required String? commentId});
  Future<Either<Failure, void>> updateCommentById(
      {required String? noticeId,
      required String? commentId,
      required CommentModel commentModel});

  Future<Either<Failure, void>> writeComment(
      {required String? noticeId,
      required String userId,
      required String content});

  Future<Either<Failure, void>> deleteComment(
      {required String? noticeId, required String commentId});

  Future<Either<Failure, void>> toggleCommentFavorite(
      {required String? noticeId,
      required String? commentId,
      required String userId,
      required bool isDelete});
}
