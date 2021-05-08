import 'package:dream/pages/bottom_navigation/notice/components/notice_card.dart';
import 'package:dream/pages/common/empty_widget.dart';
import 'package:dream/pages/common/error_message_widget.dart';
import 'package:dream/pages/common/loading_widget.dart';
import 'package:dream/pages/common/screen_status_widget.dart';
import 'package:dream/viewmodels/notice_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class NoticeBodyWidget extends StatefulWidget {
  @override
  _NoticeBodyWidgetState createState() => _NoticeBodyWidgetState();
}

class _NoticeBodyWidgetState extends State<NoticeBodyWidget> {
  final noticeViewmodel = Get.find<NoticeViewModel>();

  @override
  void initState() {
    super.initState();
    //build후에 함수 실행
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => noticeViewmodel.getNoticeList());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: Obx(() {
        var dataStatus = noticeViewmodel.noticeStatus.value;
        var noticeList = noticeViewmodel.noticeList;

        return DataStatusWidget(
            body: ListView.builder(
                itemCount: noticeList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        // Get.to(NoticeDetailScreen(),
                        //     arguments: noticeList[index]);
                        Get.toNamed('/notice_detail',
                            preventDuplicates: false,
                            arguments: noticeList[index]);
                      },
                      child: Column(
                        children: [
                          NoticeCard(notice: noticeList[index]),
                          SizedBox(
                            height: 10.h,
                          )
                        ],
                      ));
                }),
            error: ErrorMessageWidget(errorMessage: 'test'),
            loading: LoadingWidget(),
            empty: EmptyWidget(),
            updating: Container(),
            dataStatus: dataStatus);
      }),
    );
  }
}
