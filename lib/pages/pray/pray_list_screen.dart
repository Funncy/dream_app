import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/core/data_status/viewmodel_result.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/pray.dart';
import 'package:dream/pages/common/alert_mixin.dart';
import 'package:dream/pages/common/empty_widget.dart';
import 'package:dream/pages/common/error_message_widget.dart';
import 'package:dream/pages/common/loading_widget.dart';
import 'package:dream/pages/common/profile_app_bar.dart';
import 'package:dream/pages/common/screen_status_widget.dart';
import 'package:dream/pages/common/view_model_builder.dart';
import 'package:dream/pages/pray/components/pray_card.dart';
import 'package:dream/pages/profile/profile_screen.dart';
import 'package:dream/viewmodels/pray_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrayListScreen extends StatefulWidget {
  @override
  _PrayListScreenState createState() => _PrayListScreenState();
}

class _PrayListScreenState extends State<PrayListScreen> with AlertMixin {
  final ScrollController _scrollController = ScrollController();
  final prayViewModel = Get.find<PrayViewModel>();

  @override
  void initState() {
    super.initState();
    //build후에 함수 실행
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          prayViewModel.getMorePrayList();
        }
      });
    });
  }

  Future<void> refreshPrayList() async {
    prayViewModel.initPrayList();
  }

  void alertWithErrorModel(ErrorModel? errorModel) {
    if (errorModel == null) return;
    showAlert(title: '오류', content: '다시 시도해주세요.');
  }

  void _ifErrorSendAlert(Status dataStatus, ErrorModel? errorModel) {
    if (dataStatus != Status.error || errorModel == null) return;
    //Alert 발생
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      alertWithErrorModel(errorModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: ProfileAppBar(
        title: '중보 기도',
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: RefreshIndicator(
                onRefresh: refreshPrayList,
                child: Container(
                  color: Colors.black12,
                  child: ViewModelBuilder(
                    init: prayViewModel.initPrayList(),
                    errorWidget: _errorWidget(),
                    loadingWidget: _loadingWidget(),
                    builder: (context, snapshot) {
                      return Obx(() {
                        var dataStatus = prayViewModel.listStatus;
                        List<PrayModel> prayList = prayViewModel.prayList;

                        _ifErrorSendAlert(dataStatus,
                            (snapshot.data as ViewModelResult).errorModel);

                        if (prayList.length == 0) {
                          //Empty Widget
                          return _emptyWidget(size);
                        }

                        return Stack(
                          children: [
                            _bodyWidget(prayList),
                            if (dataStatus == Status.loading) _loadingWidget(),
                          ],
                        );
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyWidget(Size size) => Stack(
        children: [
          SingleChildScrollView(
              child: Container(
            width: size.width,
            height: size.height,
          )),
          EmptyWidget()
        ],
      );

  LoadingWidget _loadingWidget() => LoadingWidget();

  ErrorMessageWidget _errorWidget() => ErrorMessageWidget(errorMessage: 'test');

  ListView _bodyWidget(List<PrayModel> prayList) {
    return ListView.builder(
        key: PageStorageKey("pray_listview"),
        physics: const AlwaysScrollableScrollPhysics(),
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
