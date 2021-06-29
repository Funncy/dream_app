import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/failure.dart';
import 'package:dream/app/data/models/comment.dart';

abstract class PrayCommentRepository {
  Future<Either<Failure, List<CommentModel>>> getCommentList(
      {required String prayId});
  Future<Either<Failure, CommentModel?>> getCommentById(
      {required String prayId, required String commentId});
  Future<Either<Failure, void>> updateCommentById(
      {required String prayId,
      required String commentId,
      required CommentModel commentModel});

  Future<Either<Failure, void>> writeComment(
      {required String prayId,
      required String userId,
      required String content});

  Future<Either<Failure, void>> deleteComment(
      {required String prayId, required String commentId});

  Future<Either<Failure, void>> toggleCommentFavorite(
      {required String prayId,
      required String commentId,
      required String userId,
      required bool isDelete});
}
