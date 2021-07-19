import 'dart:async';

import 'package:dream/app/core/constants/constants.dart';
import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/app/data/models/comment.dart';
import 'package:dream/app/data/models/notice.dart';
import 'package:dream/app/data/models/reply.dart';
import 'package:dream/app/data/models/user.dart';
import 'package:dream/app/pages/common/error_message_widget.dart';
import 'package:dream/app/pages/common/loading_widget.dart';
import 'package:dream/app/pages/common/view_model_builder.dart';
import 'package:dream/app/pages/common_mixin/alert_mixin.dart';
import 'package:dream/app/pages/notice/components/notice_card.dart';
import 'package:dream/app/pages/notice_detail/components/bottom_input_bar.dart';
import 'package:dream/app/pages/notice_detail/components/notice_comment.dart';
import 'package:dream/app/viewmodels/auth_view_model.dart';
import 'package:dream/app/viewmodels/comment_view_model.dart';
import 'package:dream/app/viewmodels/reply_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoticeDetailScreen extends StatefulWidget {
  static final routeName = '/notice_detail';
  @override
  _NoticeDetailScreenState createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends State<NoticeDetailScreen>
    with AlertMixin {
  final CommentViewModel commentViewModel = Get.find<CommentViewModel>();
  final ReplyViewModel replyViewModel = Get.find<ReplyViewModel>();
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final UserModel user = Get.find<AuthViewModel>().user!;
  var notice = Get.arguments as NoticeModel?;

  bool isScrollDown = false;

  @override
  void initState() {
    super.initState();
    //댓글 추가 이후 스크롤 내리기
    commentViewModel.commentStateStream.reduce(scrollAnimatorByStatus);
  }

  ViewState? scrollAnimatorByStatus(ViewState? preStatus, ViewState? status) {
    //스크롤
    if (preStatus is Loading && status is Loaded && isScrollDown) {
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
    super.dispose();
  }

  void inputComment() {
    isScrollDown = true;
    commentViewModel.writeComment(
        noticeModel: notice!, user: user, content: _textEditingController.text);
    _textEditingController.text = '';
  }

  void deleteComment(String commentId) {
    showAlert(
        title: '댓글 삭제',
        content: '정말 댓글을 삭제하시겠습니까?',
        isFunction: true,
        function: () async {
          await commentViewModel.deleteComment(
              noticeModel: notice!, commentId: commentId);
          commentViewModel.refresh();
          replyViewModel.refresh();
        });
  }

  void deleteReply(String commentId, ReplyModel replyModel) {
    showAlert(
        title: '답글 삭제',
        content: '정말 답글을 삭제하시겠습니까?',
        isFunction: true,
        function: () async {
          await replyViewModel.deleteReply(
              noticeId: notice!.id,
              commentId: commentId,
              replyModel: replyModel);
          commentViewModel.refresh();
          replyViewModel.refresh();
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
                        init: commentViewModel.getCommentList(
                            noticeId: notice!.id),
                        errorWidget: _errorWidget(),
                        loadingWidget: _loadingWidget(),
                        getState: () => commentViewModel.commentState,
                        builder: (context, snapshot) {
                          return Obx(() {
                            ViewState commentState =
                                commentViewModel.commentState!;
                            var commentList = commentViewModel.commentList;

                            if (commentState is Error) alert(commentState);

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
                                if (commentState is Loading) _loadingWidget(),
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
            user: user,
          );
        });
  }
}
