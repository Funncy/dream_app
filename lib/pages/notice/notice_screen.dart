import 'package:dream/models/notice.dart';
import 'package:dream/pages/common/empty_widget.dart';
import 'package:dream/pages/common/error_message_widget.dart';
import 'package:dream/pages/common/loading_widget.dart';
import 'package:dream/pages/common/screen_status_widget.dart';
import 'package:dream/pages/notice/image_slider_screen.dart';
import 'package:dream/utils/time_util.dart';
import 'package:dream/viewmodels/notice_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
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
          return noticeCard(noticeList[index]);
        });
  }

  Widget noticeImages(List<String> images) {
    if (images.length == 1) {
      //단일 이미지
      return Container(
        child: Image.network(
          images[0],
          fit: BoxFit.cover,
        ),
      );
    } else if (images.length == 2) {
      //2장
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: Image.network(
            images[0],
            fit: BoxFit.cover,
          )),
          SizedBox(
            width: 8,
          ),
          Expanded(
              child: Image.network(
            images[0],
            fit: BoxFit.cover,
          ))
        ],
      );
    } else if (images.length > 2) {
      //3장 이상
      return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
            child: Image.network(
          images[0],
          fit: BoxFit.cover,
        )),
        SizedBox(
          width: 8,
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: Image.network(
              images[0],
              fit: BoxFit.cover,
            )),
            SizedBox(
              height: 5,
            ),
            if (images.length == 3)
              Expanded(
                  child: Image.network(
                images[0],
                fit: BoxFit.cover,
              )),
            if (images.length > 3)
              Expanded(
                  child: Stack(children: [
                Positioned.fill(
                  child: Container(
                    child: Image.network(
                      images[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                    child: Container(
                  decoration: BoxDecoration(color: Colors.black54),
                  child: Center(
                    child: Text(
                      "${images.length - 2}+",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ))
              ])),
          ],
        ))
      ]);
    }
  }

  Widget noticeCard(NoticeModel notice) {
    var size = MediaQuery.of(context).size;
    //시간 로드
    var date = TimeUtil.getDateString(notice.updatedAt ?? notice.createdAt);

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
                  Text(date, style: Theme.of(context).textTheme.subtitle1),
                  Text(notice.content,
                      style: Theme.of(context).textTheme.bodyText1),
                  //TODO:추후 이미지 여러개면 쪼개서 보여줘야함.
                  //1. 1개 이미지 -> 전체
                  //2. 2개 이미지 -> 반 나눠서
                  //3. 3개 이상 -> 3칸으로 쪼개서
                  //4. 4개 이상 -> 3칸으로 쪼개고 마지막 칸에 추가적인 이미지 숫자
                  //이미지는 클릭하면 좌우 스크롤 하는 화면
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(ImageSliderScreen(
                        imageUrlList: notice.images,
                      ));
                    },
                    child: Container(
                      width: size.width,
                      //TODO: 나중에 스크린 유틸로 사이즈 변경하기
                      height: 250,
                      child: noticeImages(notice.images),
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
                    children: [
                      Icon(Icons.ac_unit),
                      SizedBox(
                        width: 5,
                      ),
                      Text("좋아요 ${notice.favorites ?? ""}",
                          style: Theme.of(context).textTheme.bodyText2)
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Row(
                    children: [
                      Icon(Icons.ac_unit),
                      SizedBox(
                        width: 5,
                      ),
                      Text('댓글 ${notice.comments < 1 ? '쓰기' : notice.comments}',
                          style: Theme.of(context).textTheme.bodyText2)
                    ],
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
