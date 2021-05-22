import 'package:dream/models/notice.dart';
import 'package:dream/pages/common/empty_widget.dart';
import 'package:dream/pages/common/error_message_widget.dart';
import 'package:dream/pages/common/loading_widget.dart';
import 'package:dream/pages/common/screen_status_widget.dart';
import 'package:dream/pages/notice/components/notice_card.dart';
import 'package:dream/viewmodels/notice_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class NoticeBodyScreen extends StatefulWidget {
  @override
  _NoticeBodyScreenState createState() => _NoticeBodyScreenState();
}

class _NoticeBodyScreenState extends State<NoticeBodyScreen> {
  final noticeViewModel = Get.find<NoticeViewModel>();

  @override
  void initState() {
    super.initState();
    //build후에 함수 실행
    WidgetsBinding.instance
        .addPostFrameCallback((_) => noticeViewModel.getNoticeList());
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
          List<NoticeModel> noticeList = noticeViewModel.noticeList.toList();
          var dataStatus = noticeViewModel.noticeStatus.value;

          return DataStatusWidget(
              body: () => _noticeList(noticeList),
              error: () => _errorWidget(),
              loading: () => _loadingWidget(),
              empty: () => _emptyWidget(),
              updating: () => Container(),
              dataStatus: dataStatus);
        }),
      ),
    );
  }

  EmptyWidget _emptyWidget() => EmptyWidget();

  LoadingWidget _loadingWidget() => LoadingWidget();

  ErrorMessageWidget _errorWidget() => ErrorMessageWidget(errorMessage: 'test');

  ListView _noticeList(List<NoticeModel> noticeList) {
    return ListView.builder(
        itemCount: noticeList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () async {
                await Get.toNamed('/notice_detail',
                    arguments: noticeList[index]);

                noticeViewModel.noticeList.refresh();
              },
              child: Column(
                children: [
                  NoticeCard(notice: noticeList[index]),
                  SizedBox(
                    height: 10.h,
                  )
                ],
              ));
        });
  }
}