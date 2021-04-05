import 'package:dream/models/notice.dart';
import 'package:dream/utils/time_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../image_slider_screen.dart';
import 'image_spliter.dart';

class NoticeCard extends StatelessWidget {
  final NoticeModel notice;

  const NoticeCard({Key key, this.notice}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                  //날짜 및 텍스트
                  Text(date, style: Theme.of(context).textTheme.subtitle1),
                  Text(notice.content,
                      style: Theme.of(context).textTheme.bodyText1),
                  SizedBox(
                    height: 8,
                  ),
                  //이미지, 슬라이더
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ImageSliderScreen(
                            imageUrlList: notice.images,
                          ));
                    },
                    child: Container(
                      width: size.width,
                      //TODO: 나중에 스크린 유틸로 사이즈 변경하기
                      height: 250,
                      child: ImageSpliter(images: notice.images),
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
