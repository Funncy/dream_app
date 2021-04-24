import 'package:dartz/dartz.dart';
import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/repositories/notice_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class NoticeViewModel extends GetxController {
  NoticeRepository _noticeRepository;
  //obs는 observer로 Rx로 데이터 관리되게 됩니다.
  //화면 상태가 아니라 데이터의 상태를 관리하자.
  RxList<NoticeModel> noticeList = <NoticeModel>[].obs;
  Rx<Status> noticeStatus = Status.initial.obs;
  RxList<NoticeCommentModel> commentList = <NoticeCommentModel>[].obs;
  Rx<Status> commentStatus = Status.initial.obs;
  //답글은 comment내부에 존재하지만 상태는 따로 관리
  Rx<Status> replyStatus = Status.initial.obs;
  //RxList<NoticeModel> not sub type List<NoticeModel>

  NoticeViewModel({@required NoticeRepository noticeRepository}) {
    _noticeRepository = noticeRepository;
  }

  void getNoticeList() async {
    //데이터 상태와 데이터를 가져오는 함수를 전달
    //추가로 리스트 형태인지를 전달
    // 리스트 형태인경우 데이터의 길이에 따라 Empty위젯을 보여줘야 함.
    noticeStatus.value = Status.loading;
    Either<ErrorModel, List<NoticeModel>> either =
        await _noticeRepository.getNoticeList();
    var result = either.fold((l) {
      noticeStatus.value = Status.error;
    }, (r) => r);

    //에러인 경우 종료
    if (either.isLeft()) return;

    //Right이면 List로 반환됨.
    noticeList.clear();
    noticeList.addAll(result);
    if (noticeList.length > 0)
      noticeStatus.value = Status.loaded;
    else
      noticeStatus.value = Status.empty;
  }

  void getCommentList({@required String nid}) async {
    commentStatus.value = Status.loading;

    Either<ErrorModel, List<NoticeCommentModel>> either =
        await _noticeRepository.getCommentList(nid);
    var result =
        either.fold((l) => commentStatus.value = Status.error, (r) => r);

    if (either.isLeft()) return;

    commentList.clear();
    commentList.addAll(result);

    if (commentList.length > 0)
      commentStatus.value = Status.loaded;
    else
      commentStatus.value = Status.empty;
  }

  void writeComment(
      {@required String nid,
      @required String uid,
      @required String content}) async {
    //update 중
    commentStatus.value = Status.updating;
    Either<ErrorModel, void> either = await _noticeRepository.writeComment(
        nid: nid, uid: uid, content: content);
    either.fold((l) {
      commentStatus.value = Status.error;
    }, (r) {});

    //에러인 경우 아래 진행 안함
    if (either.isLeft()) return;

    //정상적으로 서버 통신 완료
    //댓글 다시 읽어 오기
    Either<ErrorModel, List<NoticeCommentModel>> either2 =
        await _noticeRepository.getCommentList(nid);
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

  Future<void> writeReply(
      {@required String nid,
      @required String did,
      @required String uid,
      @required String content}) async {
    replyStatus.value = Status.updating;
    commentStatus.value = Status.updating;
    Either<ErrorModel, void> either = await _noticeRepository.writeReply(
        did: did, uid: uid, content: content);

    either.fold((l) {
      replyStatus.value = Status.error;
      //댓글 화면은 일단 그대로
      commentStatus.value = Status.loaded;
      //TODO: 에러시 다이얼로그 처리 어떻게 할지?
    }, (r) {});

    //에러인 경우 아래 진행 안함
    if (either.isLeft()) return;

    NoticeCommentModel comment =
        commentList.where((comment) => comment.did == did).first;
    //서버에서 댓글 갯수 증가 반영
    comment.replyCount += 1;

    //정상적으로 서버 통신 완료
    //답글 다시 읽어 오기
    var either2 = await _noticeRepository.getReplyList(comment.did);
    var result =
        either2.fold((l) => commentStatus.value = Status.error, (r) => r);

    comment.replyList.clear();
    comment.replyList.addAll(result);

    replyStatus.value = Status.loaded;
    commentStatus.value = Status.loaded;
  }
}
