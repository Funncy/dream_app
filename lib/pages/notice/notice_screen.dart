import 'package:dream/models/notice.dart';
import 'package:dream/pages/common/empty_widget.dart';
import 'package:dream/pages/common/error_message_widget.dart';
import 'package:dream/pages/common/loading_widget.dart';
import 'package:dream/pages/common/screen_status_widget.dart';
import 'package:dream/viewmodels/notice_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class NoticeScreen extends StatefulWidget {
  @override
  _NoticeScreenState createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  final noticeViewmodel = Get.find<NoticeViewModel>();

  @override
  void initState() {
    noticeViewmodel.getNoticeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("공지사항"),
      ),
      body: Container(
        child: Obx(() {
          var screenStatus = noticeViewmodel.getScreenStatus();
          var noticeList = noticeViewmodel.notices;

          return ScreenStatusWidget(
              body: noticeListWidget(noticeList),
              error: ErrorMessageWidget(errorMessage: 'test'),
              loading: LoadingWidget(),
              empty: EmptyWidget(),
              screenStatus: screenStatus);
        }),
      ),
    );
  }

  Widget noticeListWidget(List<NoticeModel> noticeList) {
    return ListView.builder(
        itemCount: noticeList.length,
        itemBuilder: (context, index) {
          if (noticeList[index].comments.length != 0) {
            print("Notices ${noticeList[index].comments[0].content}");
            print("Reply ${noticeList[index].comments[0].replys[0].content}");
          }
          return noticeCard(noticeList[index]);
        });
  }

  Widget noticeCard(NoticeModel notice) {
    //임시 시간
    var createdAt = DateTime.now();
    var date = timeago.format(createdAt, locale: 'ko');
    // var date = DateFormat.yMMMd('ko').format(createdAt);
    return Card(
      child: Container(
        child: Column(
          children: [Text(date), Text(notice.content)],
        ),
      ),
    );
  }
}
