import 'package:dream/constants.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/pages/bottom_navigation/notice/components/notice_card.dart';
import 'package:dream/pages/common/empty_widget.dart';
import 'package:dream/pages/common/error_message_widget.dart';
import 'package:dream/pages/common/loading_widget.dart';
import 'package:dream/pages/common/screen_status_widget.dart';
import 'package:dream/pages/notice_detail/components/bottom_input_bar.dart';
import 'package:dream/pages/notice_detail/components/notice_comment.dart';
import 'package:dream/utils/time_util.dart';
import 'package:dream/viewmodels/notice_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoticeDetailScreen extends StatefulWidget {
  @override
  _NoticeDetailScreenState createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends State<NoticeDetailScreen> {
  final noticeViewmodel = Get.find<NoticeViewModel>();
  final TextEditingController _textEditingController = TextEditingController();
  var notice = Get.arguments as NoticeModel;

  @override
  void initState() {
    super.initState();
    //build후에 함수 실행
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => noticeViewmodel.getCommentList(notice.did));
  }

  void inputComment() {
    //TODO: FireStore에 댓글 추가하는 로직 추가해야함. viewmodel 통해서
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
                      var screenStatus = noticeViewmodel.getScreenStatus();
                      var commentList = noticeViewmodel.commentList;

                      return ScreenStatusWidget(
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
                          screenStatus: screenStatus);
                    })
                    // NoticeComment(),
                    // NoticeComment(),
                    // NoticeComment()
                  ],
                  //댓글 리스트 만들어야함.
                ),
              ),
              //TODO: 대화창 만들어야함.
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
