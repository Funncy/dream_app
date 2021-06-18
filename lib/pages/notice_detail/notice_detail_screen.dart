import 'dart:async';

import 'package:dream/constants.dart';
import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/core/data_status/viewmodel_result.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/comment.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/models/reply.dart';
import 'package:dream/pages/common/error_message_widget.dart';
import 'package:dream/pages/common/loading_widget.dart';
import 'package:dream/pages/common/view_model_builder.dart';
import 'package:dream/pages/common/alert_mixin.dart';
import 'package:dream/pages/notice/components/notice_card.dart';
import 'package:dream/pages/notice_detail/components/bottom_input_bar.dart';
import 'package:dream/pages/notice_detail/components/notice_comment.dart';
import 'package:dream/viewmodels/comment_reply_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoticeDetailScreen extends StatefulWidget {
  static final routeName = '/notice_detail';
  @override
  _NoticeDetailScreenState createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends State<NoticeDetailScreen>
    with AlertMixin {
  final commentReplyViewModel = Get.find<CommentReplyViewModel>();
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  var notice = Get.arguments as NoticeModel?;
  late StreamSubscription alertSubscription;

  bool isScrollDown = false;

  @override
  void initState() {
    super.initState();
    //댓글 추가 이후 스크롤 내리기
    commentReplyViewModel.commentStatusStream().reduce(scrollAnimatorByStatus);
  }

  Status? scrollAnimatorByStatus(Status? preStatus, Status? status) {
    if (preStatus == Status.loading &&
        status == Status.loaded &&
        isScrollDown) {
      isScrollDown = false;
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      });
    }
    return status;
  }

  @override
  void dispose() {
    alertSubscription.cancel();
    super.dispose();
  }

  void inputComment() {
    //TODO: uid 연동해야함.
    isScrollDown = true;
    commentReplyViewModel.writeComment(
        noticeModel: notice!,
        userId: '123',
        content: _textEditingController.text);
    _textEditingController.text = '';
  }

  void deleteComment(String commentId) {
    showAlert(
        title: '댓글 삭제',
        content: '정말 댓글을 삭제하시겠습니까?',
        isFunction: true,
        function: () async {
          await commentReplyViewModel.deleteComment(
              noticeModel: notice!, commentId: commentId);
          commentReplyViewModel.refreshComment();
          commentReplyViewModel.refreshReply();
        });
  }

  void deleteReply(String commentId, ReplyModel replyModel) {
    showAlert(
        title: '답글 삭제',
        content: '정말 답글을 삭제하시겠습니까?',
        isFunction: true,
        function: () async {
          await commentReplyViewModel.deleteReply(
              noticeId: notice!.id,
              commentId: commentId,
              replyModel: replyModel);
          commentReplyViewModel.refreshComment();
          commentReplyViewModel.refreshReply();
        });
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
                    child: ViewModelBuilder(
                        init: commentReplyViewModel.getCommentList(
                            noticeId: notice!.id),
                        errorWidget: _errorWidget(),
                        loadingWidget: _loadingWidget(),
                        builder: (context, snapshot) {
                          return Obx(() {
                            var dataStatus =
                                commentReplyViewModel.commentStatus;
                            var commentList = commentReplyViewModel.commentList;

                            _ifErrorSendAlert(dataStatus!,
                                (snapshot.data as ViewModelResult).errorModel);

                            return Stack(
                              children: [
                                Column(
                                  children: [
                                    NoticeCard(
                                      notice: notice,
                                      isCommentScreen: true,
                                    ),
                                    Divider(
                                      thickness: 1.0,
                                      color: Colors.black26,
                                    ),
                                    _bodyWidget(commentList),
                                  ],
                                ),
                                if (dataStatus == Status.loading)
                                  _loadingWidget(),
                              ],
                            );
                          });
                        })),
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

  Widget _loadingWidget() {
    return Center(
      child: LoadingWidget(),
    );
  }

  void _ifErrorSendAlert(Status dataStatus, ErrorModel? errorModel) {
    if (dataStatus != Status.error || errorModel == null) return;
    //Alert 발생
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      alertWithErrorModel(errorModel);
    });
  }

  ErrorMessageWidget _errorWidget() => ErrorMessageWidget(errorMessage: 'test');

  ListView _bodyWidget(List<CommentModel?> commentList) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: commentList.length,
        itemBuilder: (_, index) {
          return NoticeComment(
            noticeCommentModel: commentList[index],
            isReplyScreen: false,
            noticeId: notice!.id,
            deleteComment: deleteComment,
            deleteReply: deleteReply,
          );
        });
  }
}
