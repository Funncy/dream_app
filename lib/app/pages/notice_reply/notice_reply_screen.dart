import 'dart:async';

import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/app/data/models/comment.dart';
import 'package:dream/app/data/models/reply.dart';
import 'package:dream/app/pages/common/empty_widget.dart';
import 'package:dream/app/pages/common/error_message_widget.dart';
import 'package:dream/app/pages/common/loading_widget.dart';
import 'package:dream/app/pages/common/alert_mixin.dart';
import 'package:dream/app/pages/common/view_model_builder.dart';
import 'package:dream/app/pages/notice_detail/components/bottom_input_bar.dart';
import 'package:dream/app/pages/notice_detail/components/notice_comment.dart';
import 'package:dream/app/viewmodels/comment_view_model.dart';
import 'package:dream/app/viewmodels/reply_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoticeReplyScreen extends StatefulWidget {
  final String? noticeId;
  final String? commentId;

  const NoticeReplyScreen({Key? key, this.commentId, this.noticeId})
      : super(key: key);
  @override
  _NoticeReplyScreenState createState() => _NoticeReplyScreenState();
}

class _NoticeReplyScreenState extends State<NoticeReplyScreen> with AlertMixin {
  ReplyViewModel replyViewModel = Get.find<ReplyViewModel>();
  CommentViewModel commentViewModel = Get.find<CommentViewModel>();
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late StreamSubscription alertSubscription;
  @override
  void initState() {
    super.initState();
    //id에 해당하는 댓글 존재 확인
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      //새로운 답글 추가시 아래 스크롤 애니메이션
      debounce(replyViewModel.rxReplyState, (_) {
        if (replyViewModel.replyState is Loaded) {
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
    await replyViewModel.writeReply(
        noticeId: widget.noticeId,
        commentId: widget.commentId,
        userId: '123',
        content: _textEditingController.text);
    _textEditingController.text = '';
    //뒤로 갈 경우 화면 적용시키기 위함
    commentViewModel.refresh();
  }

  void deleteReply(String commentId, ReplyModel replyModel) {
    showAlert(
        title: '답글 삭제',
        content: '정말 답글을 삭제하시겠습니까?',
        isFunction: true,
        function: () async {
          await replyViewModel.deleteReply(
              noticeId: widget.noticeId,
              commentId: commentId,
              replyModel: replyModel);
          commentViewModel.refresh();
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
        child: Container(
          child: Stack(children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: ViewModelBuilder(
                        init: replyViewModel.isEixstReply(
                            commentId: widget.commentId),
                        errorWidget: _errorWidget(),
                        loadingWidget: _loadingWidget(),
                        getState: () => commentViewModel.commentState,
                        builder: (context, snapshot) {
                          return Obx(() {
                            ViewState replyState = replyViewModel.replyState!;
                            var comment = commentViewModel.commentList
                                .firstWhere((e) => e!.id == widget.commentId);

                            if (replyState is Error) alert(replyState);

                            return Stack(
                              children: [
                                _commentBody(comment),
                                if (replyState is Loading) _loadingWidget(),
                              ],
                            );
                          });
                        }),
                  ),
                ),
                BottonInputBar(
                  textEditingController: _textEditingController,
                  writeFunction: writeReply,
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  ErrorMessageWidget _errorWidget() => ErrorMessageWidget(errorMessage: 'test');

  EmptyWidget _emptyWidget() => EmptyWidget();

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
