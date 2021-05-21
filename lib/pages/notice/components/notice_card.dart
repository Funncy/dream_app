import 'package:dream/constants.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/pages/image_slider/image_slider_screen.dart';
import 'package:dream/utils/time_util.dart';
import 'package:dream/viewmodels/notice_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'image_spliter.dart';

class NoticeCard extends StatelessWidget {
  final NoticeModel notice;
  //TODO: 실제 유저 아이디로 변경해야함.
  final String userId = '123';

  const NoticeCard({Key key, @required this.notice}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //시간 로드
    var date = TimeUtil.getDateString(notice.updatedAt ?? notice.createdAt);
    NoticeViewModel noticeViewModel = Get.find<NoticeViewModel>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //날짜 및 텍스트
                  Text(date, style: Theme.of(context).textTheme.subtitle1),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(notice.content,
                      style: Theme.of(context).textTheme.bodyText1),
                  SizedBox(
                    height: 8.h,
                  ),
                  //이미지, 슬라이더
                  if (notice.imageList.length > 0)
                    GestureDetector(
                        onTap: () {
                          // 화면 전환
                          Get.to(() => ImageSliderScreen(
                                imageUrlList: notice.imageList,
                              ));
                        },
                        child: Container(
                          width: size.width,
                          height: 250.w,
                          child: ImageSpliter(images: notice.imageList),
                        )),
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
                      noticeViewModel.toggleNoticeFavorite(
                          noticeId: notice.documentId, userId: userId);
                    },
                    child: Row(
                      children: [
                        if (notice.favoriteUserList
                            .where((u) => u == userId)
                            .isNotEmpty)
                          Icon(
                            Icons.favorite,
                            color: Constants.favoriteAndCommentColor,
                          )
                        else
                          Icon(
                            Icons.favorite_border,
                            color: Constants.favoriteAndCommentColor,
                          ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text("좋아요 ${notice.favoriteUserList.length ?? ""}",
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
                          //TODO: NULL처리 해줘야함.
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
