import 'dart:async';

import 'package:dream/constants.dart';
import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/models/comment.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/models/reply.dart';
import 'package:dream/pages/common/empty_widget.dart';
import 'package:dream/pages/common/error_message_widget.dart';
import 'package:dream/pages/common/loading_widget.dart';
import 'package:dream/pages/common/screen_status_widget.dart';
import 'package:dream/pages/notice/components/notice_card.dart';
import 'package:dream/pages/notice_detail/components/bottom_input_bar.dart';
import 'package:dream/pages/notice_detail/components/notice_comment.dart';
import 'package:dream/viewmodels/comment_reply_view_model.dart';
import 'package:dream/viewmodels/notice_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoticeDetailScreen extends StatefulWidget {
  @override
  _NoticeDetailScreenState createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends State<NoticeDetailScreen> {
  final commentReplyViewModel = Get.find<CommentReplyViewModel>();
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  var notice = Get.arguments as NoticeModel;
  StreamSubscription alertSubscription;

  @override
  void initState() {
    super.initState();
    //build후에 함수 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      commentReplyViewModel.getCommentList(noticeId: notice.id);
      alertSubscription = commentReplyViewModel.alert.listen((alertModel) {
        if (alertModel.isAlert) return;
        alertModel.isAlert = true;
        showAlert(title: alertModel.title, content: alertModel.content);
      });
    });

    //댓글 추가 이후 스크롤 내리기
    commentReplyViewModel.commentStatus.stream.reduce((preStatus, status) {
      //initial => loading => loaded (scroll X)
      //updating => loaded (scroll O)

      if (preStatus == Status.updating && status == Status.loaded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 500),
              curve: Curves.ease);
        });
      }
      return status;
    });
  }

  @override
  void dispose() {
    alertSubscription.cancel();
    super.dispose();
  }

  void inputComment() {
    //TODO: uid 연동해야함.
    commentReplyViewModel.writeComment(
        noticeModel: notice,
        userId: '123',
        content: _textEditingController.text);
    _textEditingController.text = '';
  }

  void deleteComment(String commentId) {
    showAlert(
        title: '댓글 삭제',
        content: '정말 댓글을 삭제하시겠습니까?',
        isFunction: true,
        function: () => commentReplyViewModel.deleteComment(
            notcieModel: notice, commentId: commentId));
  }

  void deleteReply(String commentId, ReplyModel replyModel) {
    showAlert(
        title: '답글 삭제',
        content: '정말 답글을 삭제하시겠습니까?',
        isFunction: true,
        function: () => commentReplyViewModel.deleteReply(
            noticeId: notice.id, commentId: commentId, replyModel: replyModel));
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
        title: Text(''),
        backgroundColor: Constants.backgroundColor,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Obx(() {
                    var dataStatus = commentReplyViewModel.commentStatus.value;
                    var commentList =
                        commentReplyViewModel.commentList.toList();
                    return Column(
                      children: [
                        NoticeCard(
                          notice: notice,
                          isCommentScreen: true,
                        ),
                        Divider(
                          thickness: 1.0,
                          color: Colors.black26,
                        ),
                        DataStatusWidget(
                            body: _commentList(commentList),
                            error: _errorWidget(),
                            loading: _loadingWidget(),
                            empty: _emptyWidget(),
                            updating: _updatingWidget(commentList),
                            dataStatus: dataStatus),
                      ],
                    );
                  }),
                ),
              ),
              BottonInputBar(
                textEditingController: _textEditingController,
                writeFunction: inputComment,
              )
            ],
          ),
        ),
      ),
    );
  }

  Stack _updatingWidget(List<CommentModel> commentList) {
    return Stack(
      children: [
        _commentList(commentList),
        Container(
          height: 400.h,
          child: Center(child: CircularProgressIndicator()),
        )
      ],
    );
  }

  EmptyWidget _emptyWidget() => EmptyWidget();

  Padding _loadingWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: LoadingWidget(),
    );
  }

  ErrorMessageWidget _errorWidget() => ErrorMessageWidget(errorMessage: 'test');

  ListView _commentList(List<CommentModel> commentList) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: commentList.length,
        itemBuilder: (_, index) {
          return NoticeComment(
            noticeCommentModel: commentList[index],
            isReplyScreen: false,
            noticeId: notice.id,
            deleteComment: deleteComment,
            deleteReply: deleteReply,
          );
        });
  }
}
