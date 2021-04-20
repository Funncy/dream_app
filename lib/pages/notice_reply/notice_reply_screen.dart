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
  final String nid;
  final NoticeCommentModel noticeCommentModel;

  const NoticeReplyScreen({Key key, this.noticeCommentModel, this.nid})
      : super(key: key);
  @override
  _NoticeReplyScreenState createState() => _NoticeReplyScreenState();
}

class _NoticeReplyScreenState extends State<NoticeReplyScreen> {
  final noticeViewModel = Get.find<NoticeViewModel>();
  final TextEditingController _textEditingController = TextEditingController();

  void inputReply() {
    //TODO: uid 실제 유저로 바꿔야함.
    noticeViewModel.writeReply(
        nid: widget.nid,
        did: widget.noticeCommentModel.did,
        uid: '123',
        content: _textEditingController.text);
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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Obx(() {
                    var dataStatus = noticeViewModel.replyStatus.value;

                    return DataStatusWidget(
                        body: NoticeComment(
                          noticeCommentModel: widget.noticeCommentModel,
                          isReplyScreen: true,
                        ),
                        error: ErrorMessageWidget(errorMessage: 'test'),
                        loading: Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: LoadingWidget(),
                        ),
                        empty: EmptyWidget(),
                        updating: Stack(
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
                        ),
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
        ),
      ),
    );
  }
}
