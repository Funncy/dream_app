import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/default_error_model.dart';
import 'package:dream/app/core/error/error_model.dart';
import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/app/data/models/comment.dart';
import 'package:dream/app/data/models/reply.dart';
import 'package:dream/repositories/comment_repository.dart';
import 'package:dream/repositories/notice_repository.dart';
import 'package:dream/repositories/reply_repository.dart';
import 'package:dream/viewmodels/comment_view_model.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ReplyViewModel extends GetxController {
  late NoticeRepository _noticeRepository;
  late CommentRepository _commentRepository;
  late ReplyRepository _replyRepository;
  late CommentViewModel _commentViewModel;

//main datas
  late List<CommentModel?> _commentList;

  Rxn<ViewState?> _replyState = Rxn<ViewState?>(ViewState.initial);
  ViewState? get replyState => _replyState.value;
  Stream<ViewState?> get replyStateStream => _replyState.stream;
  Rxn<ViewState?> get rxReplyState => _replyState;

  late ErrorModel _errorModel;
  ErrorModel? get errorModel => _errorModel;

  ReplyViewModel(
      {required NoticeRepository noticeRepository,
      required CommentRepository commentRepository,
      required ReplyRepository replyRepository,
      required CommentViewModel commentViewModel}) {
    _noticeRepository = noticeRepository;
    _commentRepository = commentRepository;
    _replyRepository = replyRepository;
    _commentViewModel = commentViewModel;
  }

  onInit() {
    _commentList = _commentViewModel.commentList;
    super.onInit();
  }

  Future<void> isEixstReply({required String? commentId}) async {
    _setState(ViewState.loading);
    if (_commentList.where((e) => e!.id == commentId).isNotEmpty) {
      _setState(ViewState.loaded);
      return;
    } else {
      _setErrorModel(code: 'comment not found in list');
      _setState(ViewState.error);
    }
  }

  Future<void> writeReply(
      {required String? noticeId,
      required String? commentId,
      required String userId,
      required String content}) async {
    _setState(ViewState.loading);
    //모델 찾아오기
    CommentModel? commentModel =
        _commentList.where((e) => e!.id == commentId).first;
    if (commentModel == null) {
      _setErrorModel(code: 'commentModel is null at writeReply');
      _setState(ViewState.error);
      return;
    }

    //인덱스 찾기
    int replyIndex = commentModel.replyIndex!;
    commentModel.replyIndex = replyIndex + 1;

    //인덱스 증가
    Either<ErrorModel, void> either =
        await _commentRepository.updateCommentById(
            noticeId: noticeId,
            commentId: commentId,
            commentModel: commentModel);
    either.fold((l) {
      _setErrorModel(errorModel: l);
      _setState(ViewState.error);
    }, (r) => r);
    if (either.isLeft()) {
      commentModel.replyIndex = replyIndex - 1;
      return;
    }
    //답글 작성 server
    either = await _replyRepository.writeReply(
        noticeId: noticeId,
        commentId: commentId,
        replyIndex: replyIndex.toString(),
        userId: userId,
        content: content);
    either.fold((l) {
      _setErrorModel(errorModel: l);
      _setState(ViewState.error);
    }, (r) => r);
    if (either.isLeft()) return;
    //댓글 리로드
    Either<ErrorModel, CommentModel?> either2 = await _commentRepository
        .getCommentById(noticeId: noticeId, commentId: commentId);
    var result = either2.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      _setErrorModel(errorModel: result as ErrorModel);
      _setState(ViewState.error);
      return;
    }
    //댓글 모델 교체
    int index = _commentList.indexWhere((e) => e!.id == commentModel.id);
    if (index == -1) {
      _setErrorModel(code: '_commentList index is not found at writeReply');
      _setState(ViewState.error);
      return;
    }
    _commentList[index] = commentModel;
    _setState(ViewState.loaded);
  }

  Future<void> deleteReply(
      {required String? noticeId,
      required String commentId,
      required ReplyModel replyModel}) async {
    _setState(ViewState.loading);
    //답글 삭제 서버
    Either<ErrorModel, void> either = await _replyRepository.deleteReply(
        noticeId: noticeId, commentId: commentId, replyModel: replyModel);
    either.fold((l) {
      _setErrorModel(errorModel: l);
      _setState(ViewState.error);
    }, (r) => r);
    if (either.isLeft()) return;

    //답글 삭제 로컬
    CommentModel? commentModel =
        _commentList.where((e) => e!.id == commentId).first;
    if (commentModel == null) {
      _setErrorModel(code: 'commentModel is null at writeReply');
      _setState(ViewState.error);
      return;
    }

    commentModel.replyList.removeWhere((e) => e.id == replyModel.id);
    int index = _commentList.indexWhere((e) => e!.id == commentModel.id);
    if (index == -1) {
      _setErrorModel(code: '_commentList index is not found at deleteReply');
      _setState(ViewState.error);
    }
    _commentList[index] = commentModel;
    _setState(ViewState.loaded);
  }

  Future<void> toggleReplyFavorite(
      {required String? noticeId,
      required String? commentId,
      required String? replyId,
      required String userId}) async {
    _setState(ViewState.loading);
    //모델 찾아오기
    CommentModel? commentModel =
        _commentList.where((e) => e!.id == commentId).first;
    if (commentModel == null) {
      _setErrorModel(code: 'commentModel is null at toggleReplyFavorite');
      _setState(ViewState.error);
      return;
    }

    ReplyModel replyModel =
        commentModel.replyList.where((e) => e.id == replyId).first;
    //답글 좋아요 서버
    Either<ErrorModel, void> either =
        await _replyRepository.toggleReplyFavorite(
      noticeId: noticeId,
      commentId: commentId,
      reply: replyModel,
      userId: userId,
    );
    either.fold((l) {
      _setErrorModel(errorModel: l);
      _setState(ViewState.error);
    }, (r) => r);
    if (either.isLeft()) return;
    //댓글 리로드
    Either<ErrorModel, CommentModel?> either2 = await _commentRepository
        .getCommentById(noticeId: noticeId, commentId: commentId);
    var result = either2.fold((l) => l, (r) => r);
    if (either.isLeft()) {
      _setErrorModel(errorModel: result as ErrorModel);
      _setState(ViewState.error);
      return;
    }

    _setState(ViewState.loaded);
  }

  void refresh() {
    _replyState.refresh();
  }

  _setState(ViewState state) {
    _replyState.value = state;
  }

  _setErrorModel({ErrorModel? errorModel, String? code}) {
    if (errorModel != null)
      _errorModel = errorModel;
    else if (code != null) _errorModel = DefaultErrorModel(code: code);
  }
}
