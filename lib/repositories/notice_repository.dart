import 'package:dartz/dartz.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/comment.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/models/reply.dart';
import 'package:flutter/foundation.dart';

abstract class NoticeRepository {
  //FireStore Name
  final String noticeCollectionName = 'notice';
  final String commentCollectionName = 'comment';
  final String replyCollectionName = 'notice_reply';
  final String noticeColumnName = 'notice_id';
  final String favoriteCollectionName = 'favorite_list';

  //Firebase Storage URL
  final String noticeImagePath = '/notice';

  Future<void> createDummyData();

  Future<Either<ErrorModel, List<NoticeModel>>> getNoticeList();
  Future<Either<ErrorModel, List<CommentModel>>> getCommentList(
      {@required String noticeId});
  Future<Either<ErrorModel, CommentModel>> getCommentById(
      {@required String noticeId, @required String commentId});
  Future<Either<ErrorModel, void>> updateCommentById(
      {@required String noticeId,
      @required String commentId,
      @required CommentModel commentModel});
  Future<Either<ErrorModel, List<ReplyModel>>> getReplyList(
      {@required String commentId});
  Future<Either<ErrorModel, void>> writeComment(
      {@required String noticeId,
      @required String userId,
      @required String content});
  Future<Either<ErrorModel, void>> writeReply(
      {@required String noticeId,
      @required String commentId,
      @required String replyIndex,
      @required String userId,
      @required String content});
  Future<Either<ErrorModel, void>> toggleNoticeFavorite(
      {@required String noticeId,
      @required String userId,
      @required bool isDelete});
  Future<Either<ErrorModel, void>> toggleCommentFavorite(
      {@required String noticeId,
      @required String commentId,
      @required String userId,
      @required bool isDelete});
  Future<Either<ErrorModel, void>> toggleReplyFavorite({
    @required String noticeId,
    @required String commentId,
    @required ReplyModel reply,
    @required String userId,
  });
}
