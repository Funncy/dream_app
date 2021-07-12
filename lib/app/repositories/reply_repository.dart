import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/failure.dart';
import 'package:dream/app/data/models/reply.dart';
import 'package:dream/app/data/models/user.dart';

abstract class ReplyRepository {
  Future<Either<Failure, void>> writeReply(
      {required String? noticeId,
      required String? commentId,
      required String replyIndex,
      required UserModel user,
      required String content});

  Future<Either<Failure, void>> deleteReply({
    required String? noticeId,
    required String commentId,
    required ReplyModel replyModel,
  });

  Future<Either<Failure, void>> toggleReplyFavorite({
    required String? noticeId,
    required String? commentId,
    required ReplyModel reply,
    required String userId,
  });
}
