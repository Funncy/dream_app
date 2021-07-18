import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/default_failure.dart';
import 'package:dream/app/core/error/failure.dart';
import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/app/data/models/comment.dart';
import 'package:dream/app/data/models/notice.dart';
import 'package:dream/app/data/models/user.dart';
import 'package:dream/app/repositories/comment_repository.dart';
import 'package:dream/app/repositories/notice_repository.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CommentViewModel extends GetxController {
  late NoticeRepository _noticeRepository;
  late CommentRepository _commentRepository;
  //main datas
  List<CommentModel?> _commentList = <CommentModel?>[];
  List<CommentModel?> get commentList => _commentList;

  Rxn<ViewState?> _commentState =
      Rxn<ViewState?>(Initial()); // Status.initial.obs;
  ViewState? get commentState => _commentState.value;
  Stream<ViewState?> get commentStateStream => _commentState.stream;

  CommentViewModel({
    required NoticeRepository noticeRepository,
    required CommentRepository commentRepository,
  }) {
    _noticeRepository = noticeRepository;
    _commentRepository = commentRepository;
  }

  Future<void> writeComment(
      {required NoticeModel noticeModel,
      required UserModel user,
      required String content}) async {
    _setState(Loading());
    //댓글 작성
    Either<Failure, void> either = await _commentRepository.writeComment(
        noticeId: noticeModel.id, user: user, content: content);
    either.fold((l) {
      _setState(Error(l));
    }, (r) => r);
    if (either.isLeft()) return;
    //카운트 증가
    //TODO: 추후에는 CloudFunction으로
    either =
        await _noticeRepository.updateCommentCount(noticeId: noticeModel.id);
    either.fold((l) {
      _setState(Error(l));
    }, (r) => r);
    if (either.isLeft()) return;

    //댓글 리로드
    Either<Failure, List<CommentModel>> either2 =
        await _commentRepository.getCommentList(noticeId: noticeModel.id);
    var result = either2.fold((l) => l, (r) => r);

    if (either.isLeft()) {
      _setState(Error(result as Failure));
      return;
    }

    commentList.clear();
    commentList.addAll(result as Iterable<CommentModel?>);

    //공지사항 댓글 카운트 증가 (로컬)
    int commentCount = noticeModel.commentCount!;
    noticeModel.commentCount = commentCount + 1;

    _setState(Loaded());
  }

  Future<void> getCommentList({required String? noticeId}) async {
    _setState(Loading());
    Either<Failure, List<CommentModel>> either =
        await _commentRepository.getCommentList(noticeId: noticeId);
    var result = either.fold((l) => l, (r) => r);

    if (either.isLeft()) {
      _setState(Error(result as Failure));
      return;
    }

    commentList.clear();
    commentList.addAll(result as Iterable<CommentModel?>);
    _setState(Loaded());
  }

  Future<void> deleteComment(
      {required NoticeModel noticeModel, required commentId}) async {
    _setState(Loading());
    //댓글 삭제 server
    Either<Failure, void> either = await _commentRepository.deleteComment(
        noticeId: noticeModel.id, commentId: commentId);
    either.fold((l) {
      _setState(Error(l));
    }, (r) => r);
    if (either.isLeft()) return;
    //댓글 삭제 local
    commentList.removeWhere((e) => e!.id == commentId);
    //댓글 카운트 수정 server
    either = await _noticeRepository.updateCommentCount(
        noticeId: noticeModel.id, isIncreasement: false);
    either.fold((l) {
      _setState(Error(l));
    }, (r) => r);
    if (either.isLeft()) return;
    //댓글 카운트 수정 local
    int commentCount = noticeModel.commentCount!;
    noticeModel.commentCount = commentCount - 1;
    if (noticeModel.commentCount == 0) noticeModel.commentCount = 0;
    _setState(Loaded());
  }

  Future<void> toggleCommentFavorite(
      {required String? noticeId,
      required String? commentId,
      required String userId}) async {
    _setState(Loading());
    //댓글 모델 찾아오기
    CommentModel? commentModel =
        commentList.where((e) => e!.id == commentId).first;
    if (commentModel == null) {
      _setState(Error(DefaultFailure(
          code: 'not found commentModel at toggleCommentFavroite')));
      return;
    }
    //유저 존재여부 확인하기
    bool? isExist =
        commentModel.favoriteUserList?.where((e) => e == userId).isEmpty;
    if (isExist == null) {
      _setState(Error(DefaultFailure(
          code: 'not found favoriteUserList at toggleCommentFavroite')));
      return;
    }
    // 좋아요 토글 서버
    Either<Failure, void> either =
        await _commentRepository.toggleCommentFavorite(
            noticeId: noticeId,
            commentId: commentId,
            userId: userId,
            isDelete: !isExist);
    either.fold((l) {
      _setState(Error(l));
    }, (r) => r);
    if (either.isLeft()) return;
    // 좋아요 토클 로컬
    _toggleCommentFavoriteLocal(commentModel, userId, isExist);

    _setState(Loaded());
  }

  void refresh() {
    _commentState.refresh();
  }

  _toggleCommentFavoriteLocal(
      CommentModel commentModel, String userId, bool isExist) {
    if (isExist)
      commentModel.favoriteUserList!.add(userId);
    else
      commentModel.favoriteUserList!.remove(userId);
  }

  _setState(ViewState state) {
    _commentState.value = state;
  }
}
