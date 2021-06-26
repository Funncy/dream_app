import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/app/data/models/pray.dart';
import 'package:dream/app/pages/common/alert_mixin.dart';
import 'package:dream/app/pages/common/empty_widget.dart';
import 'package:dream/app/pages/common/error_message_widget.dart';
import 'package:dream/app/pages/common/loading_widget.dart';
import 'package:dream/app/pages/common/profile_app_bar.dart';
import 'package:dream/app/pages/common/view_model_builder.dart';
import 'package:dream/app/pages/pray/components/pray_card.dart';
import 'package:dream/app/viewmodels/pray_list_view_model.dart';
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
<<<<<<< HEAD
    //build후에 함수 실행
=======
    //무한 스크롤
>>>>>>> 892fb6f4f1f2db0815f5f46ef08c27a1788b56e1
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
    return SafeArea(
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
<<<<<<< HEAD
                      ViewState listState = prayListViewModel.listState!;
                      List<PrayModel> prayList = prayListViewModel.prayList;

                      if (listState is Error) alert(listState);
=======
                      ViewState prayListState = prayListViewModel.listState!;
                      List<PrayModel> prayList = prayListViewModel.prayList;

                      if (prayListState is Error) alert(prayListState);
>>>>>>> 892fb6f4f1f2db0815f5f46ef08c27a1788b56e1

                      if (prayList.length == 0) {
                        //Empty Widget
                        return _emptyWidget(size);
                      }

                      return Stack(
                        children: [
                          _bodyWidget(prayList),
<<<<<<< HEAD
                          if (listState is Loading) _loadingWidget(),
=======
                          if (prayListState is Loading) _loadingWidget(),
>>>>>>> 892fb6f4f1f2db0815f5f46ef08c27a1788b56e1
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
