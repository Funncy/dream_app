import 'package:dream/models/notice.dart';
import 'package:dream/pages/common/empty_widget.dart';
import 'package:dream/pages/common/error_message_widget.dart';
import 'package:dream/pages/common/loading_widget.dart';
import 'package:dream/pages/common/screen_status_widget.dart';
import 'package:dream/pages/notice/components/notice_card.dart';
import 'package:dream/pages/notice/image_slider_screen.dart';
import 'package:dream/utils/time_util.dart';
import 'package:dream/viewmodels/notice_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'components/image_spliter.dart';

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
        color: Colors.black12,
        child: Obx(() {
          var screenStatus = noticeViewmodel.getScreenStatus();
          var noticeList = noticeViewmodel.notices;

          return ScreenStatusWidget(
              body: ListView.builder(
                  itemCount: noticeList.length,
                  itemBuilder: (context, index) {
                    return NoticeCard(notice: noticeList[index]);
                  }),
              error: ErrorMessageWidget(errorMessage: 'test'),
              loading: LoadingWidget(),
              empty: EmptyWidget(),
              screenStatus: screenStatus);
        }),
      ),
    );
  }
}
