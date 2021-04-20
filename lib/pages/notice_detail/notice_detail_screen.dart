import 'package:dream/constants.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/pages/bottom_navigation/notice/components/notice_card.dart';
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

class NoticeDetailScreen extends StatefulWidget {
  @override
  _NoticeDetailScreenState createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends State<NoticeDetailScreen> {
  final noticeViewModel = Get.find<NoticeViewModel>();
  final TextEditingController _textEditingController = TextEditingController();
  var notice = Get.arguments as NoticeModel;

  @override
  void initState() {
    super.initState();
    //build후에 함수 실행
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => noticeViewModel.getCommentList(nid: notice.did));
  }

  void inputComment() {
    //TODO: uid 연동해야함.
    noticeViewModel.writeComment(
        nid: notice.did, uid: '123', content: _textEditingController.text);
    _textEditingController.text = '';
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
                child: ListView(
                  children: [
                    NoticeCard(
                      notice: notice,
                    ),
                    Divider(
                      thickness: 1.0,
                      color: Colors.black26,
                    ),
                    Obx(() {
                      var dataStatus = noticeViewModel.commentStatus.value;
                      var commentList = noticeViewModel.commentList;

                      return DataStatusWidget(
                          body: Column(
                              children: commentList
                                  .map((comment) => NoticeComment(
                                        noticeCommentModel: comment,
                                        isReplyScreen: false,
                                      ))
                                  .toList()),
                          error: ErrorMessageWidget(errorMessage: 'test'),
                          loading: Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: LoadingWidget(),
                          ),
                          empty: EmptyWidget(),
                          updating: Stack(
                            children: [
                              Column(
                                  children: commentList
                                      .map((comment) => NoticeComment(
                                            noticeCommentModel: comment,
                                            isReplyScreen: false,
                                          ))
                                      .toList()),
                              Container(
                                height: 400.h,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              )
                            ],
                          ),
                          dataStatus: dataStatus);
                    })
                  ],
                ),
              ),
              BottonInputBar(
                textEditingController: _textEditingController,
                inputFunction: inputComment,
              )
            ],
          ),
        ),
      ),
    );
  }
}
