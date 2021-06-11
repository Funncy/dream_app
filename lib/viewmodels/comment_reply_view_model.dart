import 'package:dream/core/data_status/data_result.dart';
import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/core/data_status/viewmodel_result.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/models/reply.dart';

abstract class CommentReplyViewModel {
  Status? get commentStatus;
  Stream<Status?> commentStatusStream();
  set commentStatus(Status? status);
  Status? get replyStatus;
  get replyStatusStream;
  set replyStatus(Status? status);

  //댓글
  Future<ViewModelResult> writeComment(
      {required NoticeModel noticeModel,
      required String userId,
      required String content});
  Future<ViewModelResult> getCommentList({required String? noticeId});
  Future<ViewModelResult> deleteComment(
      {required NoticeModel notcieModel, required commentId});
  Future<ViewModelResult> toggleCommentFavorite(
      {required String? noticeId,
      required String? commentId,
      required String userId});
  //답글
  Future<ViewModelResult> writeReply(
      {required String? noticeId,
      required String? commentId,
      required String userId,
      required String content});
  Future<ViewModelResult> deleteReply(
      {required String? noticeId,
      required String commentId,
      required ReplyModel replyModel});
  Future<ViewModelResult> toggleReplyFavorite(
      {required String? noticeId,
      required String? commentId,
      required String? replyId,
      required String userId});
  //화면 초기화
  void refreshComment();
  void refreshReply();
}
