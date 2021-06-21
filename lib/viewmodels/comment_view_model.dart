import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/default_error_model.dart';
import 'package:dream/app/core/error/error_model.dart';
import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/app/data/models/comment.dart';
import 'package:dream/app/data/models/notice.dart';
import 'package:dream/repositories/comment_repository.dart';
import 'package:dream/repositories/notice_repository.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CommentViewModel extends GetxController {
  late NoticeRepository _noticeRepository;
  late CommentRepository _commentRepository;
  //main datas
  List<CommentModel?> _commentList = <CommentModel?>[];
  List<CommentModel?> get commentList => _commentList;

  Rxn<ViewState?> _commentState =
      Rxn<ViewState?>(ViewState.initial); // Status.initial.obs;
  ViewState? get commentState => _commentState.value;
  Stream<ViewState?> get commentStateStream => _commentState.stream;

  late ErrorModel _errorModel;
  ErrorModel? get errorModel => _errorModel;

  CommentViewModel({
    required NoticeRepository noticeRepository,
    required CommentRepository commentRepository,
  }) {
    _noticeRepository = noticeRepository;
    _commentRepository = commentRepository;
  }

  Future<void> writeComment(
      {required NoticeModel noticeModel,
      required String userId,
      required String content}) async {
    _setState(ViewState.loading);
    //댓글 작성
    Either<ErrorModel, void> either = await _commentRepository.writeComment(
        noticeId: noticeModel.id, userId: userId, content: content);
    either.fold((l) {
      _setErrorModel(errorModel: l);
      _setState(ViewState.error);
    }, (r) => r);
    if (either.isLeft()) return;
    //카운트 증가
    //TODO: 추후에는 CloudFunction으로
    either =
        await _noticeRepository.updateCommentCount(noticeId: noticeModel.id);
    either.fold((l) {
      _setErrorModel(errorModel: l);
      _setState(ViewState.error);
    }, (r) => r);
    if (either.isLeft()) return;

    //댓글 리로드
    Either<ErrorModel, List<CommentModel>> either2 =
        await _commentRepository.getCommentList(noticeId: noticeModel.id);
    var result = either2.fold((l) => l, (r) => r);

    if (either.isLeft()) {
      _setErrorModel(errorModel: result as ErrorModel);
      _setState(ViewState.error);
      return;
    }

    commentList.clear();
    commentList.addAll(result as Iterable<CommentModel?>);

    //공지사항 댓글 카운트 증가 (로컬)
    int commentCount = noticeModel.commentCount!;
    noticeModel.commentCount = commentCount + 1;

    _setState(ViewState.loaded);
  }

  Future<void> getCommentList({required String? noticeId}) async {
    _setState(ViewState.loading);
    Either<ErrorModel, List<CommentModel>> either =
        await _commentRepository.getCommentList(noticeId: noticeId);
    var result = either.fold((l) => l, (r) => r);

    if (either.isLeft()) {
      _setErrorModel(errorModel: result as ErrorModel);
      _setState(ViewState.error);
      return;
    }

    commentList.clear();
    commentList.addAll(result as Iterable<CommentModel?>);
    _setState(ViewState.loaded);
  }

  Future<void> deleteComment(
      {required NoticeModel noticeModel, required commentId}) async {
    _setState(ViewState.loading);
    //댓글 삭제 server
    Either<ErrorModel, void> either = await _commentRepository.deleteComment(
        noticeId: noticeModel.id, commentId: commentId);
    either.fold((l) {
      _setErrorModel(errorModel: l);
      _setState(ViewState.error);
    }, (r) => r);
    if (either.isLeft()) return;
    //댓글 삭제 local
    commentList.removeWhere((e) => e!.id == commentId);
    //댓글 카운트 수정 server
    either = await _noticeRepository.updateCommentCount(
        noticeId: noticeModel.id, isIncreasement: false);
    either.fold((l) {
      _setErrorModel(errorModel: l);
      _setState(ViewState.error);
    }, (r) => r);
    if (either.isLeft()) return;
    //댓글 카운트 수정 local
    int commentCount = noticeModel.commentCount!;
    noticeModel.commentCount = commentCount - 1;
    if (noticeModel.commentCount == 0) noticeModel.commentCount = 0;
    _setState(ViewState.loaded);
  }

  Future<void> toggleCommentFavroite(
      {required String? noticeId,
      required String? commentId,
      required String userId}) async {
    _setState(ViewState.loading);
    //댓글 모델 찾아오기
    CommentModel? commentModel =
        commentList.where((e) => e!.id == commentId).first;
    if (commentModel == null) {
      _setErrorModel(code: 'not found commentModel at toggleCommentFavroite');
      _setState(ViewState.error);
      return;
    }
    //유저 존재여부 확인하기
    bool? isExist =
        commentModel.favoriteUserList?.where((e) => e == userId).isEmpty;
    if (isExist == null) {
      _setErrorModel(
          code: 'not found favoriteUserList at toggleCommentFavroite');
      _setState(ViewState.error);
      return;
    }
    // 좋아요 토글 서버
    Either<ErrorModel, void> either =
        await _commentRepository.toggleCommentFavorite(
            noticeId: noticeId,
            commentId: commentId,
            userId: userId,
            isDelete: !isExist);
    either.fold((l) {
      _setErrorModel(errorModel: l);
      _setState(ViewState.error);
    }, (r) => r);
    if (either.isLeft()) return;
    // 좋아요 토클 로컬
    _toggleCommentFavoriteLocal(commentModel, userId, isExist);

    _setState(ViewState.loaded);
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

  _setErrorModel({ErrorModel? errorModel, String? code}) {
    if (errorModel != null)
      _errorModel = errorModel;
    else if (code != null) _errorModel = DefaultErrorModel(code: code);
  }
}
