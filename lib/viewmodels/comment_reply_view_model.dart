import 'package:dartz/dartz.dart';
import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/comment.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/models/reply.dart';
import 'package:dream/repositories/comment_repository.dart';
import 'package:dream/repositories/notice_repository.dart';
import 'package:dream/repositories/reply_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'notice_view_model.dart';

class CommentReplyViewModel extends GetxController {
  NoticeRepository _noticeRepository;
  CommentRepository _commentRepository;
  ReplyRepository _replyRepository;
  RxList<CommentModel> commentList = <CommentModel>[].obs;
  Rx<Status> commentStatus = Status.initial.obs;
  //답글은 comment내부에 존재하지만 상태는 따로 관리
  Rx<Status> replyStatus = Status.initial.obs;

  CommentReplyViewModel(
      {@required NoticeRepository noticeRepository,
      @required CommentRepository commentRepository,
      @required ReplyRepository replyRepository}) {
    _noticeRepository = noticeRepository;
    _commentRepository = commentRepository;
    _replyRepository = replyRepository;
  }

  void getCommentList({@required String noticeId}) async {
    commentStatus.value = Status.loading;

    Either<ErrorModel, List<CommentModel>> either =
        await _commentRepository.getCommentList(noticeId: noticeId);
    var result =
        either.fold((l) => commentStatus.value = Status.error, (r) => r);

    if (either.isLeft()) return;

    commentList.clear();
    commentList.addAll(result);

    if (commentList.length > 0) {
      commentStatus.value = Status.loaded;
    } else {
      commentStatus.value = Status.empty;
    }
  }

  void getComment({@required String commentId}) async {
    replyStatus.value = Status.loading;

    if (commentList.where((e) => e.id == commentId).isNotEmpty) {
      replyStatus.value = Status.loaded;
    } else {
      replyStatus.value = Status.error;
    }
  }

  void writeComment(
      {@required NoticeModel noticeModel,
      @required String userId,
      @required String content}) async {
    //update 중
    commentStatus.value = Status.updating;
    //댓글 쓰기
    Either<ErrorModel, void> either = await _commentRepository.writeComment(
        noticeId: noticeModel.id, userId: userId, content: content);
    either.fold((l) {
      commentStatus.value = Status.error;
    }, (r) {});
    //에러인 경우 아래 진행 안함
    if (either.isLeft()) return;

    //공지사항의 댓글 카운트 증가
    noticeModel.commentCount++;
    //서버 통신
    either = await _noticeRepository.updateCommentCount(
        noticeModel.id, noticeModel.commentCount);
    if (either.isLeft()) {
      noticeModel.commentCount--;
      //TODO: 댓글도 지워야함.
      commentStatus.value = Status.error;
      return;
    }

    //정상적으로 서버 통신 완료
    //댓글 다시 읽어오기
    Either<ErrorModel, List<CommentModel>> either2 =
        await _commentRepository.getCommentList(noticeId: noticeModel.id);
    var result =
        either2.fold((l) => commentStatus.value = Status.error, (r) => r);

    if (either2.isLeft()) return;

    commentList.clear();
    commentList.addAll(result);
    if (commentList.length > 0)
      commentStatus.value = Status.loaded;
    else
      commentStatus.value = Status.empty;
  }

  Future<void> toggleCommentFavorite(
      {@required String noticeId,
      @required String commentId,
      @required String userId}) async {
    CommentModel commentModel =
        commentList.where((e) => e.id == commentId)?.first;
    if (commentModel == null) return;

    bool isDelete = false;
    if (commentModel.favoriteUserList
        .where((element) => element == userId)
        .isEmpty)
      isDelete = false;
    else
      isDelete = true;

    var result = await _commentRepository.toggleCommentFavorite(
        noticeId: noticeId,
        commentId: commentId,
        userId: userId,
        isDelete: isDelete);
    if (result.isLeft()) return;

    //local에서도 증가
    if (isDelete)
      commentModel.favoriteUserList.remove(userId);
    else
      commentModel.favoriteUserList.add(userId);
    commentList.refresh();
  }

  Future<void> writeReply(
      {@required String noticeId,
      @required String commentId,
      @required String userId,
      @required String content}) async {
    replyStatus.value = Status.updating;

    //인덱스 찾기
    var comment = commentList.where((e) => e.id == commentId)?.first;
    if (comment == null) {
      replyStatus.value = Status.error;
      return;
    }
    var replyIndex = comment.replyIndex;
    comment.replyIndex++;

    //인덱스 증가
    Either<ErrorModel, void> either =
        await _commentRepository.updateCommentById(
            noticeId: noticeId, commentId: commentId, commentModel: comment);

    if (either.isLeft()) {
      replyStatus.value = Status.error;
      return;
    }

    either = await _replyRepository.writeReply(
        noticeId: noticeId,
        commentId: commentId,
        replyIndex: replyIndex.toString(),
        userId: userId,
        content: content);

    either.fold((l) {
      replyStatus.value = Status.error;
      //TODO: 에러시 다이얼로그 처리 어떻게 할지?
    }, (r) {});

    //에러인 경우 아래 진행 안함
    if (either.isLeft()) return;

    //정상적으로 서버 통신 완료
    //답글 다시 읽어 오기
    var either2 = await _commentRepository.getCommentById(
        noticeId: noticeId, commentId: commentId);
    var result = either2.getOrElse(() => null);
    if (either2.isLeft()) return;

    //기존 내용 대체
    int index = commentList.indexWhere((element) => element.id == commentId);
    if (index == -1) {
      replyStatus.value = Status.error;
      return;
    }
    commentList[index] = result;

    replyStatus.value = Status.loaded;
  }

  Future<void> toggleReplyFavorite(
      {@required String noticeId,
      @required String commentId,
      @required String replyId,
      @required String userId}) async {
    CommentModel commentModel = getModel(commentList, commentId, commentStatus);
    if (commentModel == null) return;

    ReplyModel replyModel =
        getModel(commentModel.replyList, replyId, commentStatus);
    if (replyModel == null) return;

    var result = await _replyRepository.toggleReplyFavorite(
      noticeId: noticeId,
      commentId: commentId,
      reply: replyModel,
      userId: userId,
    );
    if (result.isLeft()) {
      commentStatus.value = Status.error;
      return;
    }

    //local에서도 수정
    commentList.refresh();
  }

  Object getModel(List modelList, String modelId, Rx<Status> status) {
    var model = modelList.where((e) => e.id == modelId)?.first;
    if (model != null) {
      status.value = Status.error;
      return null;
    }
    return model;
  }
}
