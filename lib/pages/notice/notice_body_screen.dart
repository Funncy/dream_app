import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/core/data_status/viewmodel_result.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/pages/common/empty_widget.dart';
import 'package:dream/pages/common/error_message_widget.dart';
import 'package:dream/pages/common/loading_widget.dart';
import 'package:dream/pages/common/view_model_builder.dart';
import 'package:dream/pages/mixin/alert_mixin.dart';
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

class _NoticeBodyScreenState extends State<NoticeBodyScreen> with AlertMixin {
  final ScrollController _scrollController = ScrollController();
  final noticeViewModel = Get.find<NoticeViewModel>();

  @override
  void initState() {
    super.initState();
    //build후에 함수 실행
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          noticeViewModel.getMoreNoticeList();
        }
      });
    });
  }

  Future<void> refreshNoticeList() async {
    noticeViewModel.getNoticeList();
  }

  void errorAlert(ErrorModel? errorModel) {
    if (errorModel == null) return;
    showAlert(title: '오류', content: '다시 시도해주세요.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("공지사항"),
      ),
      body: RefreshIndicator(
        onRefresh: refreshNoticeList,
        child: Container(
            color: Colors.black12,
            child: ViewModelBuilder(
              init: noticeViewModel.getNoticeList(),
              errorWidget: _errorWidget(),
              loadingWidget: _loadingWidget(),
              builder: (context, snapshot) {
                return Obx(() {
                  var dataStatus = noticeViewModel.noticeStatus;
                  List<NoticeModel> noticeList = noticeViewModel.noticeList;

                  _ifErrorSendAlert(dataStatus!,
                      (snapshot.data as ViewModelResult).errorModel);

                  if (noticeList.length == 0) {
                    //Empty Widget
                    return _emptyWidget();
                  }

                  return Stack(
                    children: [
                      _bodyWidget(noticeList),
                      if (dataStatus == Status.loading) _loadingWidget(),
                    ],
                  );
                });
              },
            )),
      ),
    );
  }

  void _ifErrorSendAlert(Status dataStatus, ErrorModel? errorModel) {
    if (dataStatus != Status.error || errorModel == null) return;
    //Alert 발생
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      errorAlert(errorModel);
    });
  }

  ListView _bodyWidget(List<NoticeModel> noticeList) {
    return ListView.builder(
        key: PageStorageKey("notice_listview"),
        controller: _scrollController,
        itemCount: noticeList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () async {
                await Get.toNamed('/notice_detail',
                    arguments: noticeList[index]);

                noticeViewModel.refreshNotice();
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

  EmptyWidget _emptyWidget() => EmptyWidget();

  LoadingWidget _loadingWidget() => LoadingWidget();

  ErrorMessageWidget _errorWidget() =>
      ErrorMessageWidget(errorMessage: '일시적인 문제가 발생했습니다.\n다시 시도해주세요.');
}
