import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/error_model.dart';
import 'package:dream/app/data/models/reply.dart';

abstract class ReplyRepository {
  Future<Either<ErrorModel, void>> writeReply(
      {required String? noticeId,
      required String? commentId,
      required String replyIndex,
      required String userId,
      required String content});

  Future<Either<ErrorModel, void>> deleteReply({
    required String? noticeId,
    required String commentId,
    required ReplyModel replyModel,
  });

  Future<Either<ErrorModel, void>> toggleReplyFavorite({
    required String? noticeId,
    required String? commentId,
    required ReplyModel reply,
    required String userId,
  });
}
