import 'package:dartz/dartz.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/notice.dart';
import 'package:flutter/foundation.dart';

abstract class NoticeRepository {
  Future<Either<ErrorModel, List<NoticeModel>>> getNoticeList();
  Future<Either<ErrorModel, List<NoticeCommentModel>>> getCommentList(
      {@required String noticeId});
  Future<Either<ErrorModel, List<NoticeCommentReplyModel>>> getReplyList(
      {@required String commentId});
  Future<Either<ErrorModel, void>> writeComment(
      {@required String noticeId,
      @required String userId,
      @required String content});
  Future<Either<ErrorModel, void>> writeReply(
      {@required String commentId,
      @required String userId,
      @required String content});
}
