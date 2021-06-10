import 'package:dartz/dartz.dart';
import 'package:dream/core/data_status/data_result.dart';
import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/core/error/alert_model.dart';
import 'package:dream/core/error/error_constants.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/comment.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/models/reply.dart';
import 'package:dream/repositories/comment_repository.dart';
import 'package:dream/repositories/notice_repository.dart';
import 'package:dream/repositories/reply_repository.dart';
import 'package:dream/viewmodels/comment_reply_view_model.dart';
import 'package:get/get.dart';

class CommentReplyViewModelImpl extends GetxController
    implements CommentReplyViewModel {
  late NoticeRepository _noticeRepository;
  late CommentRepository _commentRepository;
  late ReplyRepository _replyRepository;
  List<CommentModel?> commentList = <CommentModel?>[];
  Rxn<Status?> _commentStatus =
      Rxn<Status?>(Status.initial); // Status.initial.obs;
  Status? get commentStatus => _commentStatus.value;
  Stream<Status?> commentStatusStream() => _commentStatus.stream;
  set commentStatus(Status? status) => _commentStatus.value = status;
  //답글은 comment내부에 존재하지만 상태는 따로 관리
  Rxn<Status?> _replyStatus = Rxn<Status?>(Status.initial);
  Status? get replyStatus => _replyStatus.value;
  get replyStatusStream => _commentStatus.stream;
  set replyStatus(Status? status) => _replyStatus.value = status;

  CommentReplyViewModelImpl(
      {required NoticeRepository noticeRepository,
      required CommentRepository commentRepository,
      required ReplyRepository replyRepository}) {
    _noticeRepository = noticeRepository;
    _commentRepository = commentRepository;
    _replyRepository = replyRepository;
  }

  Future<DataResult> getCommentList({required String? noticeId}) async {
    commentStatus = Status.loading;

    Either<ErrorModel, List<CommentModel>> either =
        await _commentRepository.getCommentList(noticeId: noticeId);
    var result = either.fold((l) => l, (r) => r);

    if (either.isLeft()) {
      commentStatus = Status.error;
      return DataResult(isCompleted: false, errorModel: result as ErrorModel?);
    }

    commentList.clear();
    commentList.addAll(result as Iterable<CommentModel?>);

    if (commentList.length > 0) {
      commentStatus = Status.loaded;
    } else {
      commentStatus = Status.empty;
    }

    return DataResult(isCompleted: true);
  }

  DataResult isExistCommentById({required String? commentId}) {
    replyStatus = Status.loading;
    if (commentList.where((e) => e!.id == commentId).isNotEmpty) {
      replyStatus = Status.loaded;
      return DataResult(isCompleted: true);
    } else {
      replyStatus = Status.error;
      return DataResult(isCompleted: false);
    }
  }

  Future<DataResult> writeComment(
      {required NoticeModel noticeModel,
      required String userId,
      required String content}) async {
    //update 중
    commentStatus = Status.updating;
    //댓글 쓰기
    Either<ErrorModel, void> either = await _commentRepository.writeComment(
        noticeId: noticeModel.id, userId: userId, content: content);

    var result = either.fold((l) => l, (r) => r);
    //에러인 경우 아래 진행 안함
    if (either.isLeft()) {
      commentStatus = Status.loaded;
      return DataResult(isCompleted: false, errorModel: result as ErrorModel?);
    }

    //공지사항의 댓글 카운트 증가
    DataResult increaseResult = await increaseCommentCount(noticeModel);
    if (!increaseResult.isCompleted) return increaseResult;

    //정상적으로 서버 통신 완료
    //댓글 다시 읽어오기
    DataResult getCommentListResult =
        await getCommentList(noticeId: noticeModel.id);
    if (!getCommentListResult.isCompleted) return getCommentListResult;

    return DataResult(isCompleted: true);
  }

  Future<DataResult> increaseCommentCount(NoticeModel noticeModel) async {
    int commentCount = noticeModel.commentCount!;
    noticeModel.commentCount = commentCount + 1;
    //서버 통신
    Either<ErrorModel, void> either = await _noticeRepository
        .updateCommentCount(noticeModel.id, noticeModel.commentCount);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      noticeModel.commentCount = commentCount - 1;
      //TODO: 댓글도 지워야함.
      commentStatus = Status.loaded;
      return DataResult(isCompleted: false, errorModel: result as ErrorModel?);
    }
    return DataResult(isCompleted: true);
  }

  Future<DataResult> deleteComment(
      {required NoticeModel notcieModel, required commentId}) async {
    Either<ErrorModel, void> either = await _commentRepository.deleteComment(
        noticeId: notcieModel.id, commentId: commentId);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      commentStatus = Status.loaded;
      return DataResult(isCompleted: false, errorModel: result as ErrorModel?);
    }
    //로컬에서도 삭제
    deleteModelInList(commentList, commentId);

    DataResult updateCommentCountResult =
        await updateCommentCount(notcieModel.id, notcieModel.commentCount);
    commentStatus = Status.loaded;
    if (!updateCommentCountResult.isCompleted) {
      return updateCommentCountResult;
    }

    return DataResult(isCompleted: true);
  }

  Future<DataResult> updateCommentCount(String? id, int? count) async {
    Either<ErrorModel, void> either =
        await _noticeRepository.updateCommentCount(id, count);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      return DataResult(isCompleted: false, errorModel: result as ErrorModel?);
    }
    return DataResult(isCompleted: true);
  }

  Future<DataResult> toggleCommentFavorite(
      {required String? noticeId,
      required String? commentId,
      required String userId}) async {
    CommentModel? commentModel =
        getModel(commentList, commentId) as CommentModel?;
    if (commentModel == null) return DataResult(isCompleted: false);

    bool isExist = favoriteUserisExist(commentModel.favoriteUserList!, userId);

    Either<ErrorModel, void> either =
        await _commentRepository.toggleCommentFavorite(
            noticeId: noticeId,
            commentId: commentId,
            userId: userId,
            isDelete: !isExist);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      return DataResult(isCompleted: false, errorModel: result as ErrorModel?);
    }

    //local에서도 증가
    if (isExist)
      commentModel.favoriteUserList!.add(userId);
    else
      commentModel.favoriteUserList!.remove(userId);
    refreshComment();
    return DataResult(isCompleted: true);
  }

  Future<DataResult> writeReply(
      {required String? noticeId,
      required String? commentId,
      required String userId,
      required String content}) async {
    replyStatus = Status.updating;

    CommentModel? commentModel =
        getModel(commentList, commentId) as CommentModel?;
    //Comment 내부 replyIndex 증가
    DataResult increaseReplyIndexResult = await increaseReplyIndex(
        noticeId: noticeId, commentId: commentId, commentModel: commentModel);

    if (!increaseReplyIndexResult.isCompleted) {
      replyStatus = Status.loaded;
      return increaseReplyIndexResult;
    }

    Either<ErrorModel, void> either = await _replyRepository.writeReply(
        noticeId: noticeId,
        commentId: commentId,
        replyIndex: commentModel!.replyIndex.toString(),
        userId: userId,
        content: content);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      return DataResult(isCompleted: false, errorModel: result as ErrorModel);
    }

    //정상적으로 서버 통신 완료
    //답글 다시 읽어 오기
    Either<ErrorModel, CommentModel?> either2 = await _commentRepository
        .getCommentById(noticeId: noticeId, commentId: commentId);
    var result2 = either2.fold((l) => l, (r) => r);
    if (either2.isLeft()) {
      return DataResult(isCompleted: false, errorModel: result2 as ErrorModel);
    }
    commentModel = either2.getOrElse(() => null);
    //화면 모델 리스트에 삽입
    replaceModel(commentList, commentModel);

    replyStatus = Status.loaded;
    return DataResult(isCompleted: true);
  }

  Future<DataResult> deleteReply(
      {required String? noticeId,
      required String commentId,
      required ReplyModel replyModel}) async {
    replyStatus = Status.updating;
    var either = await _replyRepository.deleteReply(
        noticeId: noticeId, commentId: commentId, replyModel: replyModel);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      return DataResult(isCompleted: false, errorModel: result as ErrorModel);
    }
    //로컬에서도 삭제 필요
    CommentModel commentModel =
        getModel(commentList, commentId) as CommentModel;
    commentModel.replyList.removeWhere((e) => e.id == replyModel.id);
    replaceModel(commentList, commentModel);

    replyStatus = Status.loaded;
    commentStatus = Status.loaded;
    return DataResult(isCompleted: true);
  }

  Future<DataResult> toggleReplyFavorite(
      {required String? noticeId,
      required String? commentId,
      required String? replyId,
      required String userId}) async {
    CommentModel? commentModel =
        getModel(commentList, commentId) as CommentModel?;
    if (commentModel == null) {
      return DataResult(
          isCompleted: false,
          errorModel: ErrorModel(message: 'commentModel is null'));
    }

    ReplyModel? replyModel =
        getModel(commentModel.replyList, replyId) as ReplyModel?;
    if (replyModel == null) {
      return DataResult(
          isCompleted: false,
          errorModel: ErrorModel(message: 'replyModel is null'));
    }

    var either = await _replyRepository.toggleReplyFavorite(
      noticeId: noticeId,
      commentId: commentId,
      reply: replyModel,
      userId: userId,
    );
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      return DataResult(isCompleted: false, errorModel: result as ErrorModel);
    }

    //local에서도 수정
    refreshComment();
    return DataResult(isCompleted: true);
  }

  Future<DataResult> increaseReplyIndex(
      {required String? noticeId,
      required String? commentId,
      required CommentModel? commentModel}) async {
    if (commentModel == null)
      return DataResult(
          isCompleted: false,
          errorModel: ErrorModel(message: 'commentModel is null'));
    //인덱스 찾기
    int replyIndex = commentModel.replyIndex!;

    commentModel.replyIndex = replyIndex + 1;

    //인덱스 증가
    Either<ErrorModel, void> either =
        await _commentRepository.updateCommentById(
            noticeId: noticeId,
            commentId: commentId,
            commentModel: commentModel);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      commentModel.replyIndex = replyIndex - 1;
      return DataResult(isCompleted: false, errorModel: result as ErrorModel);
    }
    return DataResult(isCompleted: true);
  }

  void refreshComment() {
    _commentStatus.refresh();
  }

  void refreshReply() {
    _replyStatus.refresh();
  }

  Object? getModel(List modelList, String? modelId) =>
      modelList.where((e) => e.id == modelId).first;

  bool replaceModel(List modelList, dynamic model) {
    int index = modelList.indexWhere((e) => e.id == model.id);
    if (index == -1) {
      return false;
    }
    modelList[index] = model;
    return true;
  }

  bool favoriteUserisExist(List favoriteList, String userId) =>
      favoriteList.where((e) => e == userId).isEmpty;

  void deleteModelInList(List modelList, String modelId) =>
      modelList.removeWhere((e) => e.id == modelId);
}
