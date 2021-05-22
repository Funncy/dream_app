import 'dart:async';

import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/models/comment.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/models/reply.dart';
import 'package:dream/pages/common/empty_widget.dart';
import 'package:dream/pages/common/error_message_widget.dart';
import 'package:dream/pages/common/loading_widget.dart';
import 'package:dream/pages/common/screen_status_widget.dart';
import 'package:dream/pages/notice_detail/components/bottom_input_bar.dart';
import 'package:dream/pages/notice_detail/components/notice_comment.dart';
import 'package:dream/viewmodels/comment_reply_view_model.dart';
import 'package:dream/viewmodels/notice_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoticeReplyScreen extends StatefulWidget {
  final String noticeId;
  final String commentId;

  const NoticeReplyScreen({Key key, this.commentId, this.noticeId})
      : super(key: key);
  @override
  _NoticeReplyScreenState createState() => _NoticeReplyScreenState();
}

class _NoticeReplyScreenState extends State<NoticeReplyScreen> {
  CommentReplyViewModel commentReplyViewModel =
      Get.find<CommentReplyViewModel>();
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  StreamSubscription alertSubscription;
  @override
  void initState() {
    super.initState();
    //id에 해당하는 댓글 존재 확인
    WidgetsBinding.instance.addPostFrameCallback((_) {
      commentReplyViewModel.getComment(commentId: widget.commentId);
      alertSubscription = commentReplyViewModel.alert.listen((alertModel) {
        if (alertModel.isAlert) return;
        alertModel.isAlert = true;
        showAlert(title: alertModel.title, content: alertModel.content);
      });
      //새로운 답글 추가시 아래 스크롤 애니메이션
      debounce(commentReplyViewModel.replyStatus, (_) {
        if (commentReplyViewModel.replyStatus.value == Status.loaded) {
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

  void writeReply() {
    //TODO: uid 실제 유저로 바꿔야함.
    commentReplyViewModel.writeReply(
        noticeId: widget.noticeId,
        commentId: widget.commentId,
        userId: '123',
        content: _textEditingController.text);
    _textEditingController.text = '';
  }

  void deleteReply(String commentId, ReplyModel replyModel) {
    showAlert(
        title: '답글 삭제',
        content: '정말 답글을 삭제하시겠습니까?',
        isFunction: true,
        function: () => commentReplyViewModel.deleteReply(
            noticeId: widget.noticeId,
            commentId: commentId,
            replyModel: replyModel));
  }

  void showAlert(
      {@required String title,
      @required String content,
      bool isFunction = false,
      Function function}) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            if (isFunction)
              FlatButton(
                child: Text('OK'),
                onPressed: () async {
                  function();
                  Navigator.pop(context, "OK");
                },
              ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, "Cancel");
              },
            ),
          ],
        );
      },
    );
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
          var dataStatus = commentReplyViewModel.replyStatus.value;

          return Container(
            child: Stack(children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Obx(() {
                        var dataStatus =
                            commentReplyViewModel.replyStatus.value;
                        var comment = commentReplyViewModel.commentList
                            .firstWhere((e) => e.id == widget.commentId);
                        return DataStatusWidget(
                            body: _commentBody(comment),
                            error: _errorWidget(),
                            loading: _loadingWidget(),
                            empty: _emptyWidget(),
                            updating: _updatingWidget(comment),
                            dataStatus: dataStatus);
                      }),
                    ),
                  ),
                  BottonInputBar(
                    textEditingController: _textEditingController,
                    writeFunction: writeReply,
                  ),
                ],
              ),
              if (dataStatus == Status.updating)
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

  Stack _updatingWidget(CommentModel commentModel) {
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

  NoticeComment _commentBody(CommentModel commentModel) {
    return NoticeComment(
      noticeCommentModel: commentModel,
      isReplyScreen: true,
      noticeId: widget.noticeId,
      deleteReply: deleteReply,
    );
  }
}
