import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/pages/common/empty_widget.dart';
import 'package:dream/pages/common/error_message_widget.dart';
import 'package:dream/pages/common/loading_widget.dart';
import 'package:dream/pages/common/screen_status_widget.dart';
import 'package:dream/pages/notice_detail/components/bottom_input_bar.dart';
import 'package:dream/pages/notice_detail/components/notice_comment.dart';
import 'package:dream/viewmodels/notice_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoticeReplyScreen extends StatefulWidget {
  final String noticeId;
  final NoticeCommentModel noticeCommentModel;

  const NoticeReplyScreen({Key key, this.noticeCommentModel, this.noticeId})
      : super(key: key);
  @override
  _NoticeReplyScreenState createState() => _NoticeReplyScreenState();
}

class _NoticeReplyScreenState extends State<NoticeReplyScreen> {
  final noticeViewModel = Get.find<NoticeViewModel>();
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    debounce(noticeViewModel.replyStatus, (_) {
      if (noticeViewModel.replyStatus.value == Status.loaded) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      }
    }, time: Duration(milliseconds: 500));
  }

  void inputReply() {
    //TODO: uid 실제 유저로 바꿔야함.
    noticeViewModel.writeReply(
        noticeId: widget.noticeId,
        commentId: widget.noticeCommentModel.documentId,
        userId: '123',
        content: _textEditingController.text);
    _textEditingController.text = '';
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
          var dataStatus = noticeViewModel.replyStatus.value;

          return Container(
            child: Stack(children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Obx(() {
                        var dataStatus = noticeViewModel.replyStatus.value;

                        return DataStatusWidget(
                            body: () => _commentBody(),
                            error: () => _errorWidget(),
                            loading: () => _loadingWidget(),
                            empty: () => _emptyWidget(),
                            updating: () => _updatingWidget(),
                            dataStatus: dataStatus);
                      }),
                    ),
                  ),
                  BottonInputBar(
                    textEditingController: _textEditingController,
                    inputFunction: inputReply,
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

  Stack _updatingWidget() {
    return Stack(
      children: [
        NoticeComment(
          noticeCommentModel: widget.noticeCommentModel,
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

  NoticeComment _commentBody() {
    return NoticeComment(
      noticeCommentModel: widget.noticeCommentModel,
      isReplyScreen: true,
    );
  }
}
