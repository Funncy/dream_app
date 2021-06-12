import 'package:dream/core/data_status/viewmodel_result.dart';
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
  final ScrollController _scrollController = ScrollController();
  final noticeViewModel = Get.find<NoticeViewModel>();

  @override
  void initState() {
    super.initState();
    //build후에 함수 실행
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      noticeViewModel.getNoticeList();
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          noticeViewModel.addNoticeList();
        }
      });
    });
  }

  Future<void> refreshNoticeList() async {
    noticeViewModel.getNoticeList();
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
          child: FutureBuilder(
            future: noticeViewModel.getNoticeList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  child: Center(
                    child: Text("로딩 위젯"),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                if ((snapshot.data as ViewModelResult).isCompleted) {
                  return Obx(() {
                    var dataStatus = noticeViewModel.noticeStatus;
                    List<NoticeModel> noticeList = noticeViewModel.noticeList;
                    return DataStatusWidget(
                        body: _noticeList(noticeList),
                        error: _noticeList(noticeList),
                        loading: _noticeList(noticeList),
                        empty: _emptyWidget(),
                        updating: _updatingWidget(noticeList),
                        dataStatus: dataStatus!);
                  });
                }
              }
              return Container(
                child: Center(child: Text("에러 위젯")),
              );
            },
          ),
        ),
      ),
    );
  }

  EmptyWidget _emptyWidget() => EmptyWidget();

  LoadingWidget _loadingWidget() => LoadingWidget();

  ErrorMessageWidget _errorWidget() => ErrorMessageWidget(errorMessage: 'test');

  _updatingWidget(List<NoticeModel> noticeList) {
    return Stack(
      children: [
        _noticeList(noticeList),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 400.h,
            child: Center(child: CircularProgressIndicator()),
          ),
        )
      ],
    );
  }

  ListView _noticeList(List<NoticeModel> noticeList) {
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
}
