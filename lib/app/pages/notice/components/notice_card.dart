import 'package:dream/app/core/constants/constants.dart';
import 'package:dream/app/data/models/notice.dart';
import 'package:dream/app/pages/image_slider/image_slider_screen.dart';
import 'package:dream/app/core/utils/time_util.dart';
import 'package:dream/app/viewmodels/auth_view_model.dart';
import 'package:dream/app/viewmodels/comment_view_model.dart';
import 'package:dream/app/viewmodels/notice_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'image_spliter.dart';

class NoticeCard extends StatelessWidget {
  final NoticeModel? notice;
  final bool isCommentScreen;
  //실제 유저 모델 가져오기
  final String userId = Get.find<AuthViewModel>().user?.id ?? "";
  //ViewModel 연결
  final NoticeViewModel noticeViewModel = Get.find<NoticeViewModel>();

  NoticeCard({Key? key, required this.notice, this.isCommentScreen = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //시간 로드
    var date = TimeUtil.getDateString(notice!.updatedAt ?? notice!.createdAt!);

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
                  Text(notice!.content!,
                      style: Theme.of(context).textTheme.bodyText1),
                  SizedBox(
                    height: 8.h,
                  ),
                  //이미지, 슬라이더
                  if (notice!.imageList.length > 0)
                    GestureDetector(
                        onTap: () {
                          // 화면 전환
                          Get.to(() => ImageSliderScreen(
                                imageUrlList: notice!.imageList,
                              ));
                        },
                        child: Container(
                          width: size.width,
                          height: 250.w,
                          child: ImageSpliter(images: notice!.imageList),
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
                          noticeId: notice!.id, userId: userId);
                      if (isCommentScreen) {
                        Get.find<CommentViewModel>().refresh();
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        if (notice!.favoriteUserList!
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
                        Container(
                          width: 5.w,
                        ),
                        Text("좋아요 ${notice!.favoriteUserList!.length}",
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
                          '댓글 ${notice!.commentCount! < 1 ? '쓰기' : notice!.commentCount}',
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
