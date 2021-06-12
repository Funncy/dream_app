import 'package:dartz/dartz.dart';
import 'package:dream/core/data_status/data_result.dart';
import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/core/data_status/viewmodel_result.dart';
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
import 'package:dream/viewmodels/mixin/view_model_pipe_line_mixin.dart';
import 'package:get/get.dart';

class CommentReplyViewModelImpl extends GetxController
    with ViewModelPipeLineMixin
    implements CommentReplyViewModel {
  //서버통신을 위한 Repositories
  late NoticeRepository _noticeRepository;
  late CommentRepository _commentRepository;
  late ReplyRepository _replyRepository;
  //main datas
  List<CommentModel?> _commentList = <CommentModel?>[];
  List<CommentModel?> get commentList => _commentList;
  //main data별 status
  Rxn<Status?> _commentStatus =
      Rxn<Status?>(Status.initial); // Status.initial.obs;
  Rxn<Status?> _replyStatus = Rxn<Status?>(Status.initial);
  Status? get commentStatus => _commentStatus.value;
  set commentStatus(Status? status) => _commentStatus.value = status;
  //답글은 comment내부에 존재하지만 상태는 따로 관리
  Status? get replyStatus => _replyStatus.value;
  set replyStatus(Status? status) => _replyStatus.value = status;
  //화면에서 상태별 stream에 접근하기 위한 stream getter
  Stream<Status?> commentStatusStream() => _commentStatus.stream;
  get replyStatusStream => _commentStatus.stream;

  CommentReplyViewModelImpl(
      {required NoticeRepository noticeRepository,
      required CommentRepository commentRepository,
      required ReplyRepository replyRepository}) {
    _noticeRepository = noticeRepository;
    _commentRepository = commentRepository;
    _replyRepository = replyRepository;
  }

  Future<ViewModelResult> writeComment(
          {required NoticeModel noticeModel,
          required String userId,
          required String content}) =>
      process(functionList: [
        (_) => _writeComment(
            noticeModel: noticeModel, userId: userId, content: content),
        (_) => _increaseCommentCount(noticeModel),
        (_) => _getCommentList(noticeId: noticeModel.id),
      ], status: _commentStatus);

  // Future<ViewModelResult> writeComment(
  //     {required NoticeModel noticeModel,
  //     required String userId,
  //     required String content}) async {
  //   //update 중
  //   commentStatus = Status.updating;

  //   ViewModelResult result = await pipeline([
  //     (_) => _writeComment(
  //         noticeModel: noticeModel, userId: userId, content: content),
  //     (_) => _increaseCommentCount(noticeModel),
  //     (_) => _getCommentList(noticeId: noticeModel.id),
  //   ]);

  //   if (!result.isCompleted == false) {
  //     commentStatus = Status.error;
  //     return result;
  //   }
  //   commentStatus = Status.loaded;
  //   return result;
  // }

  Future<ViewModelResult> getCommentList({required String? noticeId}) async {
    commentStatus = Status.loading;

    ViewModelResult result = await pipeline([
      (_) => _getCommentList(noticeId: noticeId),
    ]);

    if (!result.isCompleted == false) {
      commentStatus = Status.error;
      return result;
    }

    if (commentList.length > 0) {
      commentStatus = Status.loaded;
    } else {
      commentStatus = Status.empty;
    }

    return result;
  }

  Future<ViewModelResult> deleteComment(
      {required NoticeModel notcieModel, required commentId}) async {
    commentStatus = Status.loading;

    ViewModelResult result = await pipeline([
      (_) => _deleteComment(noticeId: notcieModel.id!, commentId: commentId),
      (_) => _updateCommentCount(notcieModel.id, notcieModel.commentCount),
    ]);

    if (!result.isCompleted) {
      commentStatus = Status.error;
      return result;
    }

    commentStatus = Status.loaded;
    return ViewModelResult(isCompleted: true);
  }

  Future<ViewModelResult> toggleCommentFavorite(
      {required String? noticeId,
      required String? commentId,
      required String userId}) async {
    commentStatus = Status.loading;

    ViewModelResult result = await pipeline([
      (_) => _toggleCommentFavorite(
          noticeId: noticeId, commentId: commentId, userId: userId)
    ]);
    if (!result.isCompleted) {
      commentStatus = Status.error;
      return result;
    }

    commentStatus = Status.loaded;
    return ViewModelResult(isCompleted: true);
  }

  Future<ViewModelResult> writeReply(
      {required String? noticeId,
      required String? commentId,
      required String userId,
      required String content}) async {
    replyStatus = Status.updating;

    CommentModel? commentModel =
        getModel(commentList, commentId) as CommentModel?;
    //Comment 내부 replyIndex 증가
    DataResult successOrError = await increaseReplyIndex(
        noticeId: noticeId, commentId: commentId, commentModel: commentModel);
    if (!successOrError.isCompleted) {
      replyStatus = Status.error;
      return successOrError;
    }

    successOrError = await _writeReply(
        noticeId: noticeId,
        commentId: commentId,
        replyIndex: commentModel!.replyIndex.toString(),
        userId: userId,
        content: content);
    if (!successOrError.isCompleted) {
      replyStatus = Status.error;
      return successOrError;
    }

    //정상적으로 서버 통신 완료
    //답글 다시 읽어 오기
    successOrError =
        await _getCommentById(noticeId: noticeId, commentId: commentId);
    if (!successOrError.isCompleted) {
      commentStatus = Status.error;
      return successOrError;
    }

    CommentModel resultModel = successOrError.data;
    //화면 모델 리스트에 삽입
    replaceModel(commentList, resultModel);

    replyStatus = Status.loaded;
    return ViewModelResult(isCompleted: true);
  }

  Future<ViewModelResult> deleteReply(
      {required String? noticeId,
      required String commentId,
      required ReplyModel replyModel}) async {
    replyStatus = Status.loading;
    DataResult successOrError = await _deleteReply(
        noticeId: noticeId, commentId: commentId, replyModel: replyModel);
    if (!successOrError.isCompleted) {
      replyStatus = Status.error;
      return successOrError;
    }
    //로컬에서도 삭제 필요
    _deleteReplyInLocalList(
        commentId: commentId, noticeId: noticeId, replyModel: replyModel);

    replyStatus = Status.loaded;
    return ViewModelResult(isCompleted: true);
  }

  Future<ViewModelResult> toggleReplyFavorite(
      {required String? noticeId,
      required String? commentId,
      required String? replyId,
      required String userId}) async {
    replyStatus = Status.loading;
    CommentModel? commentModel =
        getModel(commentList, commentId) as CommentModel?;
    if (commentModel == null) {
      return ViewModelResult(
          isCompleted: false,
          errorModel: ErrorModel(message: 'commentModel is null'));
    }

    ReplyModel? replyModel =
        getModel(commentModel.replyList, replyId) as ReplyModel?;
    if (replyModel == null) {
      return ViewModelResult(
          isCompleted: false,
          errorModel: ErrorModel(message: 'replyModel is null'));
    }

    DataResult successOrError = await _toggleReplyFavorite(
        noticeId: noticeId,
        commentId: commentId,
        replyModel: replyModel,
        userId: userId);
    if (!successOrError.isCompleted) {
      replyStatus = Status.error;
      return successOrError;
    }

    //local에서도 수정
    replyStatus = Status.loaded;
    return ViewModelResult(isCompleted: true);
  }

  void refreshComment() {
    _commentStatus.refresh();
  }

  void refreshReply() {
    _replyStatus.refresh();
  }

  /*
   *
   * 
   * Interface 부품 함수들 
   * 
   * 
   * 
  */

  Future<DataResult> _getCommentList({required String? noticeId}) async {
    Either<ErrorModel, List<CommentModel>> either =
        await _commentRepository.getCommentList(noticeId: noticeId);
    var result = either.fold((l) => l, (r) => r);

    if (either.isLeft())
      return DataResult(isCompleted: false, errorModel: result as ErrorModel?);

    commentList.clear();
    commentList.addAll(result as Iterable<CommentModel?>);
    return DataResult(isCompleted: true);
  }

  Future<DataResult> _toggleCommentFavorite({
    required String? noticeId,
    required String? commentId,
    required String userId,
  }) async {
    //모델 찾기
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
    try {
      _toggleCommentFavoriteLocal(userId: userId, model: commentModel);
    } catch (e) {
      return DataResult(
          isCompleted: false,
          errorModel: ErrorModel(message: 'favorite user not found'));
    }

    return DataResult(isCompleted: true);
  }

  //TODO: 변화하는지 체크 필요 (혹시 복사해오면 변경 안됨)
  void _toggleCommentFavoriteLocal({
    required String userId,
    required CommentModel model,
  }) {
    bool isExist = favoriteUserisExist(model.favoriteUserList!, userId);
    if (isExist)
      model.favoriteUserList!.add(userId);
    else
      model.favoriteUserList!.remove(userId);
  }

  Future<DataResult> _deleteComment(
      {required String noticeId, required commentId}) async {
    Either<ErrorModel, void> either = await _commentRepository.deleteComment(
        noticeId: noticeId, commentId: commentId);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      commentStatus = Status.loaded;
      return DataResult(isCompleted: false, errorModel: result as ErrorModel?);
    }
    //모델 내부도 삭제
    try {
      _deleteModelInList(commentList, commentId);
    } catch (e) {
      return DataResult(
          isCompleted: false,
          errorModel: ErrorModel(message: 'model is not found'));
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

  Future<DataResult> _writeComment(
      {required NoticeModel noticeModel,
      required String userId,
      required String content}) async {
    Either<ErrorModel, void> either = await _commentRepository.writeComment(
        noticeId: noticeModel.id, userId: userId, content: content);

    var result = either.fold((l) => l, (r) => r);
    //에러인 경우 아래 진행 안함
    if (either.isLeft()) {
      return DataResult(isCompleted: false, errorModel: result as ErrorModel?);
    }
    return DataResult(isCompleted: true);
  }

  Future<DataResult> _increaseCommentCount(NoticeModel noticeModel) async {
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

  Future<DataResult> _updateCommentCount(String? id, int? count) async {
    Either<ErrorModel, void> either =
        await _noticeRepository.updateCommentCount(id, count);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      return DataResult(isCompleted: false, errorModel: result as ErrorModel?);
    }
    return DataResult(isCompleted: true);
  }

  Future<DataResult> _writeReply(
      {required String? noticeId,
      required String? commentId,
      required String userId,
      required String replyIndex,
      required String content}) async {
    Either<ErrorModel, void> either = await _replyRepository.writeReply(
        noticeId: noticeId,
        commentId: commentId,
        replyIndex: replyIndex,
        userId: userId,
        content: content);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      return DataResult(isCompleted: false, errorModel: result as ErrorModel);
    }
    return DataResult(isCompleted: true);
  }

  Future<DataResult> _getCommentById(
      {required String? noticeId, required String? commentId}) async {
    Either<ErrorModel, CommentModel?> either = await _commentRepository
        .getCommentById(noticeId: noticeId, commentId: commentId);
    var result2 = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      return DataResult(isCompleted: false, errorModel: result2 as ErrorModel);
    }
    return DataResult(isCompleted: true, data: either.getOrElse(() => null));
  }

  Future<DataResult> _deleteReply(
      {required String? noticeId,
      required String commentId,
      required ReplyModel replyModel}) async {
    var either = await _replyRepository.deleteReply(
        noticeId: noticeId, commentId: commentId, replyModel: replyModel);
    var result = either.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      return DataResult(isCompleted: false, errorModel: result as ErrorModel);
    }
    return DataResult(isCompleted: true);
  }

  void _deleteReplyInLocalList(
      {required String? noticeId,
      required String commentId,
      required ReplyModel replyModel}) {
    CommentModel commentModel =
        getModel(commentList, commentId) as CommentModel;
    commentModel.replyList.removeWhere((e) => e.id == replyModel.id);
    replaceModel(commentList, commentModel);
  }

  Future<DataResult> _toggleReplyFavorite(
      {required String? noticeId,
      required String? commentId,
      required ReplyModel replyModel,
      required String userId}) async {
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

  void _deleteModelInList(List modelList, String modelId) =>
      modelList.removeWhere((e) => e.id == modelId);
}
