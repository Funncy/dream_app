import 'package:dream/models/notice.dart';
import 'package:dream/pages/common/empty_widget.dart';
import 'package:dream/pages/common/error_message_widget.dart';
import 'package:dream/pages/common/loading_widget.dart';
import 'package:dream/pages/common/screen_status_widget.dart';
import 'package:dream/viewmodels/notice_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

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
              body: noticeListWidget(noticeList),
              error: ErrorMessageWidget(errorMessage: 'test'),
              loading: LoadingWidget(),
              empty: EmptyWidget(),
              screenStatus: screenStatus);
        }),
      ),
    );
  }

  Widget noticeListWidget(List<NoticeModel> noticeList) {
    return ListView.builder(
        itemCount: noticeList.length,
        itemBuilder: (context, index) {
          if (noticeList[index].comments.length != 0) {
            print("Notices ${noticeList[index].comments[0].content}");
            print("Reply ${noticeList[index].comments[0].replys[0].content}");
          }
          return noticeCard(noticeList[index]);
        });
  }

  Widget noticeCard(NoticeModel notice) {
    var size = MediaQuery.of(context).size;
    //임시 시간
    var createdAt = DateTime.now();
    var date = timeago.format(createdAt, locale: 'ko');
    // var date = DateFormat.yMMMd('ko').format(createdAt);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(date),
                  Text(notice.content),
                  //TODO:추후 이미지 여러개면 쪼개서 보여줘야함.
                  //1. 1개 이미지 -> 전체
                  //2. 2개 이미지 -> 반 나눠서
                  //3. 3개 이상 -> 3칸으로 쪼개서
                  //4. 4개 이상 -> 3칸으로 쪼개고 마지막 칸에 추가적인 이미지 숫자
                  //이미지는 클릭하면 좌우 스크롤 하는 화면
                  Container(
                    width: size.width,
                    //TODO: 나중에 스크린 유틸로 사이즈 변경하기
                    height: 250,
                    child: Image.asset(
                      'assets/images/test-img.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1.0,
              color: Colors.black12,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Row(
                    children: [Icon(Icons.ac_unit), Text("좋아요 3")],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Row(
                    children: [Icon(Icons.ac_unit), Text('댓글 2')],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
