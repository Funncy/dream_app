import 'package:dartz/dartz.dart';
import 'package:dream/repositories/comment_repository.dart';
import 'package:dream/repositories/notice_repository.dart';
import 'package:dream/repositories/reply_repository.dart';
import 'package:dream/viewmodels/comment_reply_view_model.dart';
import 'package:get/get.dart';

// class CommentReplyViewModelImpl extends GetxController
//     with ViewModelPipeLineMixin
//     implements CommentReplyViewModel {
//   //서버통신을 위한 Repositories
//   late NoticeRepository _noticeRepository;
//   late CommentRepository _commentRepository;
//   late ReplyRepository _replyRepository;
//   //main datas
//   List<CommentModel?> _commentList = <CommentModel?>[];
//   List<CommentModel?> get commentList => _commentList;
//   //main data별 status
//   Rxn<ViewState?> _commentStatus =
//       Rxn<ViewState?>(ViewState.initial); // Status.initial.obs;
//   Rxn<ViewState?> _replyStatus = Rxn<ViewState?>(ViewState.initial);
//   ViewState? get commentStatus => _commentStatus.value;
//   set commentStatus(ViewState? status) => _commentStatus.value = status;
//   //답글은 comment내부에 존재하지만 상태는 따로 관리
//   ViewState? get replyStatus => _replyStatus.value;
//   set replyStatus(ViewState? status) => _replyStatus.value = status;
//   //화면에서 상태별 stream에 접근하기 위한 stream getter
//   Stream<ViewState?> commentStatusStream() => _commentStatus.stream;
//   get replyStatusStream => _commentStatus.stream;

//   CommentReplyViewModelImpl(
//       {required NoticeRepository noticeRepository,
//       required CommentRepository commentRepository,
//       required ReplyRepository replyRepository}) {
//     _noticeRepository = noticeRepository;
//     _commentRepository = commentRepository;
//     _replyRepository = replyRepository;
//   }

//   Future<ViewModelResult> writeComment(
//           {required NoticeModel noticeModel,
//           required String userId,
//           required String content}) =>
//       process(functionList: [
//         (_) => _writeComment(
//             noticeModel: noticeModel, userId: userId, content: content),
//         (_) => _increaseCommentCount(noticeModel),
//         (_) => _getCommentList(noticeId: noticeModel.id),
//         (_) => _updateCommentCountLocal(noticeModel: noticeModel, count: 1),
//       ], status: _commentStatus);

//   Future<ViewModelResult> getCommentList({required String? noticeId}) =>
//       process(functionList: [
//         (_) => _getCommentList(noticeId: noticeId),
//       ], status: _commentStatus);

//   Future<ViewModelResult> deleteComment(
//           {required NoticeModel noticeModel, required commentId}) =>
//       process(functionList: [
//         (_) => _deleteComment(noticeId: noticeModel.id!, commentId: commentId),
//         (_) => _deleteModelInLocal(modelList: commentList, id: commentId),
//         (_) => _updateCommentCount(noticeModel.id, noticeModel.commentCount),
//         (_) => _updateCommentCountLocal(noticeModel: noticeModel, count: -1),
//       ], status: _commentStatus);

//   Future<ViewModelResult> toggleCommentFavorite(
//           {required String? noticeId,
//           required String? commentId,
//           required String userId}) =>
//       process(functionList: [
//         (_) => _getModel(commentList, commentId),
//         (data) => _favoriteUserisExist(data['model'].favoriteUserList, userId),
//         (data) => _toggleCommentFavorite(
//             noticeId: noticeId,
//             commentId: commentId,
//             userId: userId,
//             isExist: data['isExist']),
//         (data) => _toggleCommentFavoriteLocal(
//             userId: userId, model: data['model'], isExist: data['isExist']),
//       ], status: _commentStatus);

//   Future<ViewModelResult> isExistCommentById({required String? commentId}) =>
//       process(functionList: [
//         (_) => _isExistCommentById(commentId: commentId),
//       ], status: _replyStatus);

//   Future<ViewModelResult> writeReply(
//           {required String? noticeId,
//           required String? commentId,
//           required String userId,
//           required String content}) =>
//       process(functionList: [
//         (_) => _getModel(commentList, commentId),
//         (data) => _increaseReplyIndex(
//             noticeId: noticeId,
//             commentId: commentId,
//             commentModel: data['model']),
//         (data) => _writeReply(
//             noticeId: noticeId,
//             commentId: commentId,
//             replyIndex: data['model'].replyIndex.toString(),
//             userId: userId,
//             content: content),
//         (_) => _getCommentById(noticeId: noticeId, commentId: commentId),
//         (data) => _replaceModel(commentList, data['comment_model']),
//       ], status: _replyStatus);

//   Future<ViewModelResult> deleteReply(
//           {required String? noticeId,
//           required String commentId,
//           required ReplyModel replyModel}) =>
//       process(functionList: [
//         (_) => _deleteReply(
//             noticeId: noticeId, commentId: commentId, replyModel: replyModel),
//         (_) => _deleteReplyInLocalList(
//             commentId: commentId, noticeId: noticeId, replyModel: replyModel),
//       ], status: _replyStatus);

//   Future<ViewModelResult> toggleReplyFavorite(
//           {required String? noticeId,
//           required String? commentId,
//           required String? replyId,
//           required String userId}) =>
//       process(functionList: [
//         (_) => _getModel(commentList, commentId),
//         (data) => _getModel(data['model'].replyList, replyId),
//         (data) => _toggleReplyFavorite(
//             noticeId: noticeId,
//             commentId: commentId,
//             replyModel: data['model'],
//             userId: userId),
//         (_) => _getCommentById(noticeId: noticeId, commentId: commentId),
//       ], status: _replyStatus);

//   void refreshComment() {
//     _commentStatus.refresh();
//   }

//   void refreshReply() {
//     _replyStatus.refresh();
//   }

//   /*
//    *
//    *
//    * Interface 부품 함수들
//    *
//    *
//    *
//   */

//   Future<DataResult> _getCommentList({required String? noticeId}) async {
//     Either<ErrorModel, List<CommentModel>> either =
//         await _commentRepository.getCommentList(noticeId: noticeId);
//     var result = either.fold((l) => l, (r) => r);

//     if (either.isLeft())
//       return DataResult(isCompleted: false, errorModel: result as ErrorModel?);

//     commentList.clear();
//     commentList.addAll(result as Iterable<CommentModel?>);
//     return DataResult(isCompleted: true);
//   }

//   Future<DataResult> _toggleCommentFavorite({
//     required String? noticeId,
//     required String? commentId,
//     required String userId,
//     required bool isExist,
//   }) async {
//     Either<ErrorModel, void> either =
//         await _commentRepository.toggleCommentFavorite(
//             noticeId: noticeId,
//             commentId: commentId,
//             userId: userId,
//             isDelete: !isExist);
//     var result = either.fold((l) => l, (r) => r);
//     if (either.isLeft()) {
//       return DataResult(isCompleted: false, errorModel: result as ErrorModel);
//     }

//     return DataResult(isCompleted: true);
//   }

//   //TODO: 변화하는지 체크 필요 (혹시 복사해오면 변경 안됨)
//   DataResult _toggleCommentFavoriteLocal({
//     required String userId,
//     required CommentModel model,
//     required bool isExist,
//   }) {
//     try {
//       if (isExist)
//         model.favoriteUserList!.add(userId);
//       else
//         model.favoriteUserList!.remove(userId);
//       return DataResult(isCompleted: true);
//     } catch (e) {
//       return DataResult(
//           isCompleted: false,
//           errorModel:
//               DefaultErrorModel(code: 'error at _toggleCommentFavoriteLocal'));
//     }
//   }

//   Future<DataResult> _deleteComment(
//       {required String noticeId, required commentId}) async {
//     Either<ErrorModel, void> either = await _commentRepository.deleteComment(
//         noticeId: noticeId, commentId: commentId);
//     var result = either.fold((l) => l, (r) => r);
//     if (either.isLeft()) {
//       return DataResult(isCompleted: false, errorModel: result as ErrorModel?);
//     }
//     return DataResult(isCompleted: true);
//   }

//   DataResult _deleteModelInLocal(
//       {required List modelList, required String id}) {
//     try {
//       modelList.removeWhere((e) => e.id == id);
//       return DataResult(isCompleted: true);
//     } catch (e) {
//       return DataResult(
//           isCompleted: false,
//           errorModel: DefaultErrorModel(code: 'error at _deleteModelInList '));
//     }
//   }

//   DataResult _isExistCommentById({required String? commentId}) {
//     if (commentList.where((e) => e!.id == commentId).isNotEmpty) {
//       return DataResult(isCompleted: true);
//     } else {
//       return DataResult(isCompleted: false);
//     }
//   }

//   Future<DataResult> _writeComment(
//       {required NoticeModel noticeModel,
//       required String userId,
//       required String content}) async {
//     Either<ErrorModel, void> either = await _commentRepository.writeComment(
//         noticeId: noticeModel.id, userId: userId, content: content);

//     var result = either.fold((l) => l, (r) => r);
//     //에러인 경우 아래 진행 안함
//     if (either.isLeft()) {
//       return DataResult(isCompleted: false, errorModel: result as ErrorModel?);
//     }
//     return DataResult(isCompleted: true);
//   }

//   Future<DataResult> _increaseCommentCount(NoticeModel noticeModel) async {
//     Either<ErrorModel, void> either =
//         await _noticeRepository.updateCommentCount(noticeId: noticeModel.id);
//     var result = either.fold((l) => l, (r) => r);
//     if (either.isLeft()) {
//       return DataResult(isCompleted: false, errorModel: result as ErrorModel?);
//     }
//     return DataResult(isCompleted: true);
//   }

//   Future<DataResult> _updateCommentCount(String? id, int? count) async {
//     Either<ErrorModel, void> either = await _noticeRepository
//         .updateCommentCount(noticeId: id, isIncreasement: false);
//     var result = either.fold((l) => l, (r) => r);
//     if (either.isLeft()) {
//       return DataResult(isCompleted: false, errorModel: result as ErrorModel?);
//     }
//     return DataResult(isCompleted: true);
//   }

//   DataResult _updateCommentCountLocal(
//       {required NoticeModel noticeModel, required int count}) {
//     try {
//       int commentCount = noticeModel.commentCount!;
//       noticeModel.commentCount = commentCount + count;
//       if (noticeModel.commentCount == 0) noticeModel.commentCount = 0;
//       return DataResult(isCompleted: true);
//     } catch (e) {
//       return DataResult(
//           isCompleted: false,
//           errorModel:
//               DefaultErrorModel(code: 'error at _updateCommentCountLocal'));
//     }
//   }

//   Future<DataResult> _writeReply(
//       {required String? noticeId,
//       required String? commentId,
//       required String userId,
//       required String replyIndex,
//       required String content}) async {
//     Either<ErrorModel, void> either = await _replyRepository.writeReply(
//         noticeId: noticeId,
//         commentId: commentId,
//         replyIndex: replyIndex,
//         userId: userId,
//         content: content);
//     var result = either.fold((l) => l, (r) => r);
//     if (either.isLeft()) {
//       return DataResult(isCompleted: false, errorModel: result as ErrorModel);
//     }
//     return DataResult(isCompleted: true);
//   }

//   Future<DataResult> _getCommentById(
//       {required String? noticeId, required String? commentId}) async {
//     Either<ErrorModel, CommentModel?> either = await _commentRepository
//         .getCommentById(noticeId: noticeId, commentId: commentId);
//     var result = either.fold((l) => l, (r) => r);
//     if (either.isLeft()) {
//       return DataResult(isCompleted: false, errorModel: result as ErrorModel);
//     }
//     return DataResult(
//         isCompleted: true, data: {'comment_model': result as CommentModel});
//   }

//   Future<DataResult> _deleteReply(
//       {required String? noticeId,
//       required String commentId,
//       required ReplyModel replyModel}) async {
//     var either = await _replyRepository.deleteReply(
//         noticeId: noticeId, commentId: commentId, replyModel: replyModel);
//     var result = either.fold((l) => l, (r) => r);
//     if (either.isLeft()) {
//       return DataResult(isCompleted: false, errorModel: result as ErrorModel);
//     }
//     return DataResult(isCompleted: true);
//   }

//   DataResult _deleteReplyInLocalList(
//       {required String? noticeId,
//       required String commentId,
//       required ReplyModel replyModel}) {
//     try {
//       CommentModel commentModel =
//           _getModel(commentList, commentId).data['model'];
//       commentModel.replyList.removeWhere((e) => e.id == replyModel.id);
//       _replaceModel(commentList, commentModel);
//     } catch (e) {
//       return DataResult(
//           isCompleted: false,
//           errorModel:
//               DefaultErrorModel(code: 'error at _deleteReplyInLocalList'));
//     }
//     return DataResult(isCompleted: true);
//   }

//   Future<DataResult> _toggleReplyFavorite(
//       {required String? noticeId,
//       required String? commentId,
//       required ReplyModel replyModel,
//       required String userId}) async {
//     var either = await _replyRepository.toggleReplyFavorite(
//       noticeId: noticeId,
//       commentId: commentId,
//       reply: replyModel,
//       userId: userId,
//     );
//     var result = either.fold((l) => l, (r) => r);
//     if (either.isLeft()) {
//       return DataResult(isCompleted: false, errorModel: result as ErrorModel);
//     }
//     return DataResult(isCompleted: true);
//   }

//   Future<DataResult> _increaseReplyIndex(
//       {required String? noticeId,
//       required String? commentId,
//       required CommentModel? commentModel}) async {
//     if (commentModel == null)
//       return DataResult(
//           isCompleted: false,
//           errorModel: DefaultErrorModel(code: 'commentModel is null'));
//     //인덱스 찾기
//     int replyIndex = commentModel.replyIndex!;

//     commentModel.replyIndex = replyIndex + 1;

//     //인덱스 증가
//     Either<ErrorModel, void> either =
//         await _commentRepository.updateCommentById(
//             noticeId: noticeId,
//             commentId: commentId,
//             commentModel: commentModel);
//     var result = either.fold((l) => l, (r) => r);
//     if (either.isLeft()) {
//       commentModel.replyIndex = replyIndex - 1;
//       return DataResult(isCompleted: false, errorModel: result as ErrorModel);
//     }
//     return DataResult(isCompleted: true);
//   }

//   ///_getModel => data is CommentModel.
//   ///
//   ///```
//   /// CommentModel model = data['model']
//   /// ```
//   DataResult _getModel(List modelList, String? modelId) {
//     late Object model;
//     try {
//       model = modelList.where((e) => e.id == modelId).first;
//     } catch (e) {
//       return DataResult(
//           isCompleted: false,
//           errorModel: DefaultErrorModel(code: 'error at getModel'));
//     }
//     return DataResult(isCompleted: true, data: {'model': model});
//   }

//   ///_replaceModel => data is None.
//   DataResult _replaceModel(List modelList, dynamic model) {
//     int index = modelList.indexWhere((e) => e.id == model.id);
//     if (index == -1) {
//       return DataResult(
//           isCompleted: false,
//           errorModel: DefaultErrorModel(code: 'index == -1 at replaceModel'));
//     }
//     modelList[index] = model;
//     return DataResult(isCompleted: true);
//   }

//   ///_favoriteUserisExist => data is bool.
//   ///
//   ///```
//   /// bool isExist = data['isExist']
//   ///```
//   DataResult _favoriteUserisExist(List favoriteList, String userId) {
//     try {
//       bool isExist = favoriteList.where((e) => e == userId).isEmpty;
//       return DataResult(isCompleted: true, data: {'isExist': isExist});
//     } catch (e) {
//       return DataResult(
//           isCompleted: false,
//           errorModel: DefaultErrorModel(code: 'error at _favoriteUserisExist'));
//     }
//   }
// }
