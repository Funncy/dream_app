import 'dart:async';

import 'package:dream/core/data_status/view_state.dart';
import 'package:dream/models/comment.dart';
import 'package:dream/models/reply.dart';
import 'package:dream/pages/common/empty_widget.dart';
import 'package:dream/pages/common/error_message_widget.dart';
import 'package:dream/pages/common/loading_widget.dart';
import 'package:dream/pages/common/screen_status_widget.dart';
import 'package:dream/pages/common/alert_mixin.dart';
import 'package:dream/pages/notice_detail/components/bottom_input_bar.dart';
import 'package:dream/pages/notice_detail/components/notice_comment.dart';
import 'package:dream/viewmodels/comment_reply_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoticeReplyScreen extends StatefulWidget {
  final String? noticeId;
  final String? commentId;

  const NoticeReplyScreen({Key? key, this.commentId, this.noticeId})
      : super(key: key);
  @override
  _NoticeReplyScreenState createState() => _NoticeReplyScreenState();
}

class _NoticeReplyScreenState extends State<NoticeReplyScreen> with AlertMixin {
  CommentReplyViewModel commentReplyViewModel =
      Get.find<CommentReplyViewModel>();
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late StreamSubscription alertSubscription;
  @override
  void initState() {
    super.initState();
    //id에 해당하는 댓글 존재 확인
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      commentReplyViewModel.isExistCommentById(commentId: widget.commentId);
      // alertSubscription = commentReplyViewModel.alert.listen((alertModel) {
      //   if (alertModel.isAlert) return;
      //   alertModel.isAlert = true;
      //   showAlert(title: alertModel.title, content: alertModel.content);
      // });
      //새로운 답글 추가시 아래 스크롤 애니메이션
      debounce(commentReplyViewModel.replyStatusStream, (dynamic _) {
        if (commentReplyViewModel.replyStatus == ViewState.loaded) {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 500),
              curve: Curves.ease);
        }
      }, time: Duration(milliseconds: 500));
    });
  }

  @override
  void dispose() {
    alertSubscription.cancel();
    super.dispose();
  }

  void writeReply() async {
    //TODO: uid 실제 유저로 바꿔야함.
    await commentReplyViewModel.writeReply(
        noticeId: widget.noticeId,
        commentId: widget.commentId,
        userId: '123',
        content: _textEditingController.text);
    _textEditingController.text = '';
    //뒤로 갈 경우 화면 적용시키기 위함
    commentReplyViewModel.refreshComment();
  }

  void deleteReply(String commentId, ReplyModel replyModel) {
    showAlert(
        title: '답글 삭제',
        content: '정말 답글을 삭제하시겠습니까?',
        isFunction: true,
        function: () async {
          await commentReplyViewModel.deleteReply(
              noticeId: widget.noticeId,
              commentId: commentId,
              replyModel: replyModel);
          commentReplyViewModel.refreshComment();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '댓글',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Obx(() {
          ViewState dataStatus = commentReplyViewModel.replyStatus!;

          return Container(
            child: Stack(children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Obx(() {
                        var dataStatus = commentReplyViewModel.replyStatus;
                        var comment = commentReplyViewModel.commentList
                            .firstWhere((e) => e!.id == widget.commentId);
                        return DataStatusWidget(
                            body: _commentBody(comment),
                            error: _errorWidget(),
                            loading: _loadingWidget(),
                            empty: _emptyWidget(),
                            updating: _updatingWidget(comment),
                            dataStatus: dataStatus!);
                      }),
                    ),
                  ),
                  BottonInputBar(
                    textEditingController: _textEditingController,
                    writeFunction: writeReply,
                  ),
                ],
              ),
              if (dataStatus == ViewState.updating)
                Center(
                  child: CircularProgressIndicator(),
                )
            ]),
          );
        }),
      ),
    );
  }

  ErrorMessageWidget _errorWidget() => ErrorMessageWidget(errorMessage: 'test');

  EmptyWidget _emptyWidget() => EmptyWidget();

  Stack _updatingWidget(CommentModel? commentModel) {
    return Stack(
      children: [
        NoticeComment(
          noticeCommentModel: commentModel,
          isReplyScreen: true,
        ),
        Container(
          height: 400.h,
          child: Center(child: CircularProgressIndicator()),
        )
      ],
    );
  }

  Padding _loadingWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: LoadingWidget(),
    );
  }

  Widget _commentBody(CommentModel? commentModel) {
    if (commentModel == null) return ErrorMessageWidget(errorMessage: 'test');
    return NoticeComment(
      noticeCommentModel: commentModel,
      isReplyScreen: true,
      noticeId: widget.noticeId,
      deleteReply: deleteReply,
    );
  }
}
