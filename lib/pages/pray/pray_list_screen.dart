import 'package:dream/models/pray.dart';
import 'package:dream/pages/common/empty_widget.dart';
import 'package:dream/pages/common/error_message_widget.dart';
import 'package:dream/pages/common/loading_widget.dart';
import 'package:dream/pages/common/screen_status_widget.dart';
import 'package:dream/pages/pray/components/pray_card.dart';
import 'package:dream/viewmodels/pray_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrayListScreen extends StatefulWidget {
  @override
  _PrayListScreenState createState() => _PrayListScreenState();
}

class _PrayListScreenState extends State<PrayListScreen> {
  final ScrollController _scrollController = ScrollController();
  final prayViewModel = Get.find<PrayViewModel>();

  @override
  void initState() {
    super.initState();
    //build후에 함수 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      prayViewModel.initPrayList();
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          prayViewModel.addPrayList();
        }
      });
    });
  }

  Future<void> refreshNoticeList() async {
    prayViewModel.initPrayList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("중보 기도"),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshNoticeList,
          child: Container(
            color: Colors.black12,
            child: Obx(() {
              List<PrayModel> prayList = prayViewModel.prayList;
              var dataStatus = prayViewModel.listStatus.value;

              return DataStatusWidget(
                  body: _prayList(prayList),
                  error: _errorWidget(),
                  loading: _loadingWidget(),
                  empty: _emptyWidget(),
                  updating: _updatingWidget(prayList),
                  dataStatus: dataStatus);
            }),
          ),
        ),
      ),
    );
  }

  EmptyWidget _emptyWidget() => EmptyWidget();

  LoadingWidget _loadingWidget() => LoadingWidget();

  ErrorMessageWidget _errorWidget() => ErrorMessageWidget(errorMessage: 'test');

  _updatingWidget(List<PrayModel> noticeList) {
    return Stack(
      children: [
        _prayList(noticeList),
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

  ListView _prayList(List<PrayModel> prayList) {
    return ListView.builder(
        key: PageStorageKey("notice_listview"),
        controller: _scrollController,
        itemCount: prayList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () async {},
              child: Column(
                children: [
                  PrayCard(prayModel: prayList[index]),
                  SizedBox(
                    height: 10.h,
                  )
                ],
              ));
        });
  }
}
