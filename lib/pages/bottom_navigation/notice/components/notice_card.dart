import 'package:dream/constants.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/utils/time_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../image_slider/image_slider_screen.dart';
import 'image_spliter.dart';

class NoticeCard extends StatelessWidget {
  final NoticeModel notice;

  const NoticeCard({Key key, @required this.notice}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //시간 로드
    var date = TimeUtil.getDateString(notice.updatedAt ?? notice.createdAt);

    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
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
                    height: 8.h,
                  ),
                  //이미지, 슬라이더
                  GestureDetector(
                    onTap: () {
                      // 화면 전환
                      Get.to(() => ImageSliderScreen(
                            imageUrlList: notice.imageList,
                          ));
                    },
                    child: notice.imageList.length > 0
                        ? Container(
                            width: size.width,
                            height: 250.w,
                            child: ImageSpliter(images: notice.imageList),
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1.0,
              color: Colors.black26,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      print("favorite");
                    },
                    child: Row(
                      children: [
                        //TODO: 내가 눌렀는지에 따라 이미지 변경해야함.
                        Icon(
                          Icons.favorite_border,
                          color: Constants.favoriteAndCommentColor,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text("좋아요 ${notice.favorites ?? ""}",
                            style: Theme.of(context).textTheme.bodyText2)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 30.w,
                  ),
                  Row(
                    children: [
                      Icon(Icons.messenger_outline_rounded,
                          color: Constants.favoriteAndCommentColor),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                          '댓글 ${notice.commentCount < 1 ? '쓰기' : notice.commentCount}',
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
