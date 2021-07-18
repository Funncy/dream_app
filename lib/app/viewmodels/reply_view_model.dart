import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/default_failure.dart';
import 'package:dream/app/core/error/failure.dart';
import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/app/data/models/comment.dart';
import 'package:dream/app/data/models/reply.dart';
import 'package:dream/app/data/models/user.dart';
import 'package:dream/app/repositories/comment_repository.dart';
import 'package:dream/app/repositories/notice_repository.dart';
import 'package:dream/app/repositories/reply_repository.dart';
import 'package:dream/app/viewmodels/comment_view_model.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ReplyViewModel extends GetxController {
  late NoticeRepository _noticeRepository;
  late CommentRepository _commentRepository;
  late ReplyRepository _replyRepository;
  late CommentViewModel _commentViewModel;

//main datas
  late List<CommentModel?> _commentList;

  Rxn<ViewState?> _replyState = Rxn<ViewState?>(Initial());
  ViewState? get replyState => _replyState.value;
  Stream<ViewState?> get replyStateStream => _replyState.stream;
  Rxn<ViewState?> get rxReplyState => _replyState;

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
    _setState(Loading());
    if (_commentList.where((e) => e!.id == commentId).isNotEmpty) {
      _setState(Loaded());
      return;
    } else {
      _setState(Error(DefaultFailure(code: 'comment not found in list')));
    }
  }

  Future<void> writeReply(
      {required String? noticeId,
      required String? commentId,
      required UserModel user,
      required String content}) async {
    _setState(Loading());
    //모델 찾아오기
    CommentModel? commentModel =
        _commentList.where((e) => e!.id == commentId).first;
    if (commentModel == null) {
      _setState(
          Error(DefaultFailure(code: 'commentModel is null at writeReply')));
      return;
    }

    //인덱스 찾기
    int replyIndex = commentModel.replyIndex!;
    commentModel.replyIndex = replyIndex + 1;

    //인덱스 증가
    Either<Failure, void> either = await _commentRepository.updateCommentById(
        noticeId: noticeId, commentId: commentId, commentModel: commentModel);
    either.fold((l) {
      _setState(Error(l));
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
        user: user,
        content: content);
    either.fold((l) {
      _setState(Error(l));
    }, (r) => r);
    if (either.isLeft()) return;
    //댓글 리로드
    Either<Failure, CommentModel?> either2 = await _commentRepository
        .getCommentById(noticeId: noticeId, commentId: commentId);
    var result = either2.fold((l) => l, (r) => r);
    if (either2.isLeft()) {
      _setState(Error(result as Failure));
      return;
    }
    CommentModel modifiedCommentModel = result as CommentModel;
    //댓글 모델 교체
    int index =
        _commentList.indexWhere((e) => e!.id == modifiedCommentModel.id);
    if (index == -1) {
      _setState(Error(DefaultFailure(
          code: '_commentList index is not found at writeReply')));
      return;
    }
    _commentList[index] = modifiedCommentModel;
    _setState(Loaded());
  }

  Future<void> deleteReply(
      {required String? noticeId,
      required String commentId,
      required ReplyModel replyModel}) async {
    _setState(Loading());
    //답글 삭제 서버
    Either<Failure, void> either = await _replyRepository.deleteReply(
        noticeId: noticeId, commentId: commentId, replyModel: replyModel);
    either.fold((l) {
      _setState(Error(l));
    }, (r) => r);
    if (either.isLeft()) return;

    //답글 삭제 로컬
    CommentModel? commentModel =
        _commentList.where((e) => e!.id == commentId).first;
    if (commentModel == null) {
      _setState(
          Error(DefaultFailure(code: 'commentModel is null at writeReply')));
      return;
    }

    commentModel.replyList.removeWhere((e) => e.id == replyModel.id);
    int index = _commentList.indexWhere((e) => e!.id == commentModel.id);
    if (index == -1) {
      _setState(Error(DefaultFailure(
          code: '_commentList index is not found at deleteReply')));
    }
    _commentList[index] = commentModel;
    _setState(Loaded());
  }

  Future<void> toggleReplyFavorite(
      {required String? noticeId,
      required String? commentId,
      required String? replyId,
      required String userId}) async {
    _setState(Loading());
    //모델 찾아오기
    CommentModel? commentModel =
        _commentList.where((e) => e!.id == commentId).first;
    if (commentModel == null) {
      _setState(Error(
          DefaultFailure(code: 'commentModel is null at toggleReplyFavorite')));
      return;
    }

    ReplyModel replyModel =
        commentModel.replyList.where((e) => e.id == replyId).first;
    //답글 좋아요 서버
    Either<Failure, void> either = await _replyRepository.toggleReplyFavorite(
      noticeId: noticeId,
      commentId: commentId,
      reply: replyModel,
      userId: userId,
    );
    either.fold((l) {
      _setState(Error(l));
    }, (r) => r);
    if (either.isLeft()) return;
    //댓글 리로드
    Either<Failure, CommentModel?> either2 = await _commentRepository
        .getCommentById(noticeId: noticeId, commentId: commentId);
    var result = either2.fold((l) => l, (r) => r);
    if (either2.isLeft()) {
      _setState(Error(result as Failure));
      return;
    }

    _setState(Loaded());
  }

  void refresh() {
    _replyState.refresh();
  }

  _setState(ViewState state) {
    _replyState.value = state;
  }
}
