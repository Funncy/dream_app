import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/app/data/models/pray.dart';
import 'package:dream/pages/common/alert_mixin.dart';
import 'package:dream/pages/common/empty_widget.dart';
import 'package:dream/pages/common/error_message_widget.dart';
import 'package:dream/pages/common/loading_widget.dart';
import 'package:dream/pages/common/profile_app_bar.dart';
import 'package:dream/pages/common/view_model_builder.dart';
import 'package:dream/pages/pray/components/pray_card.dart';
import 'package:dream/viewmodels/pray_list_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrayListScreen extends StatefulWidget {
  @override
  _PrayListScreenState createState() => _PrayListScreenState();
}

class _PrayListScreenState extends State<PrayListScreen> with AlertMixin {
  final ScrollController _scrollController = ScrollController();
  final PrayListViewModel prayListViewModel = Get.find<PrayListViewModel>();

  @override
  void initState() {
    super.initState();
    prayListViewModel.listStateStream.listen((state) {
      if (state == ViewState.error) {
        alertWithErrorModel(prayListViewModel.errorModel);
      }
    });
    //build후에 함수 실행
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          prayListViewModel.getMorePrayList();
        }
      });
    });
  }

  Future<void> refreshPrayList() async {
    prayListViewModel.getPrayList();
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
                    init: prayListViewModel.getPrayList(),
                    errorWidget: _errorWidget(),
                    loadingWidget: _loadingWidget(),
                    getState: () => prayListViewModel.listState,
                    builder: (context, snapshot) {
                      return Obx(() {
                        var dataStatus = prayListViewModel.listState;
                        List<PrayModel> prayList = prayListViewModel.prayList;

                        if (prayList.length == 0) {
                          //Empty Widget
                          return _emptyWidget(size);
                        }

                        return Stack(
                          children: [
                            _bodyWidget(prayList),
                            if (dataStatus == ViewState.loading)
                              _loadingWidget(),
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
