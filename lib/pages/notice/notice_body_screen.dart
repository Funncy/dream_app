import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/app/data/models/notice.dart';
import 'package:dream/pages/common/empty_widget.dart';
import 'package:dream/pages/common/error_message_widget.dart';
import 'package:dream/pages/common/loading_widget.dart';
import 'package:dream/pages/common/profile_app_bar.dart';
import 'package:dream/pages/common/view_model_builder.dart';
import 'package:dream/pages/common/alert_mixin.dart';
import 'package:dream/pages/notice/components/notice_card.dart';
import 'package:dream/viewmodels/auth_view_model.dart';
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
  final NoticeViewModel noticeViewModel = Get.find<NoticeViewModel>();
  final AuthViewModel authViewModel = Get.find<AuthViewModel>();
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    //build후에 함수 실행
    profileImageUrl = authViewModel.user?.profileImageUrl;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      noticeViewModel.noticeStateStream.listen((viewState) {
        if (viewState == ViewState.error ||
            noticeViewModel.errorModel != null) {
          alertWithErrorModel(noticeViewModel.errorModel);
        }
      });
    });
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: ProfileAppBar(
        title: '공지사항',
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: RefreshIndicator(
                onRefresh: refreshNoticeList,
                child: Container(
                    color: Colors.black12,
                    child: ViewModelBuilder(
                      init: noticeViewModel.getNoticeList(),
                      errorWidget: _errorWidget(),
                      loadingWidget: _loadingWidget(),
                      getState: () => authViewModel.authState,
                      builder: (context, snapshot) {
                        return Obx(() {
                          var dataStatus = noticeViewModel.noticeState;
                          List<NoticeModel> noticeList =
                              noticeViewModel.noticeList;

                          if (noticeList.length == 0) {
                            //Empty Widget
                            return _emptyWidget(size);
                          }

                          return Stack(
                            children: [
                              _bodyWidget(noticeList),
                              if (dataStatus == ViewState.loading)
                                _loadingWidget(),
                            ],
                          );
                        });
                      },
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView _bodyWidget(List<NoticeModel> noticeList) {
    return ListView.builder(
        key: PageStorageKey("notice_listview"),
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: noticeList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () async {
                await Get.toNamed('/notice_detail',
                    arguments: noticeList[index]);

                refreshNoticeList();
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

  ErrorMessageWidget _errorWidget() =>
      ErrorMessageWidget(errorMessage: '일시적인 문제가 발생했습니다.\n다시 시도해주세요.');
}
