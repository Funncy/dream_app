// abstract class CommentReplyViewModel {
//   List<CommentModel?> get commentList;
//   ViewState? get commentStatus;
//   Stream<ViewState?> commentStatusStream();
//   set commentStatus(ViewState? status);
//   ViewState? get replyStatus;
//   get replyStatusStream;
//   set replyStatus(ViewState? status);

//   //댓글
//   Future<ViewModelResult> writeComment(
//       {required NoticeModel noticeModel,
//       required String userId,
//       required String content});
//   Future<ViewModelResult> getCommentList({required String? noticeId});
//   Future<ViewModelResult> deleteComment(
//       {required NoticeModel noticeModel, required commentId});
//   Future<ViewModelResult> toggleCommentFavorite(
//       {required String? noticeId,
//       required String? commentId,
//       required String userId});
//   //답글
//   Future<ViewModelResult> isExistCommentById({required String? commentId});
//   Future<ViewModelResult> writeReply(
//       {required String? noticeId,
//       required String? commentId,
//       required String userId,
//       required String content});
//   Future<ViewModelResult> deleteReply(
//       {required String? noticeId,
//       required String commentId,
//       required ReplyModel replyModel});
//   Future<ViewModelResult> toggleReplyFavorite(
//       {required String? noticeId,
//       required String? commentId,
//       required String? replyId,
//       required String userId});
//   //화면 초기화
//   void refreshComment();
//   void refreshReply();
// }
