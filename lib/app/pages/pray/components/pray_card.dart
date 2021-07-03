import 'package:dream/app/core/constants/constants.dart';
import 'package:dream/app/core/utils/time_util.dart';
import 'package:dream/app/data/models/pray.dart';
import 'package:dream/app/viewmodels/pray_comment_view_model.dart';
import 'package:dream/app/viewmodels/pray_list_view_model.dart';
import 'package:dream/app/viewmodels/pray_reply_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PrayCard extends StatelessWidget {
  final PrayModel prayModel;
  //TODO: 실제 유저 아이디로 변경해야함.
  final String userId = '123';
  final bool isCommentScreen;
  final PrayListViewModel _prayListViewModel = Get.find<PrayListViewModel>();
  final PrayCommentViewModel _commentViewModel =
      Get.find<PrayCommentViewModel>();
  final PrayReplyViewModel _replyViewModel = Get.find<PrayReplyViewModel>();

  PrayCard({Key? key, required this.prayModel, this.isCommentScreen = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    //시간 로드
    var date =
        TimeUtil.getDateString(prayModel.updatedAt ?? prayModel.createdAt!);

    String content = prayModel.content!;
    if (!isCommentScreen) if (content.length > 80) {
      content = content.substring(0, 80);
      content += "....";
    }
    //TODO: User 정보 및 아이콘 필요
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
                  Text(prayModel.title!, style: Constants.titleStyle),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(content, style: Constants.contentStyle),
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
                    onTap: () async {
                      await _prayListViewModel.togglePrayFavorite(
                          prayId: prayModel.id!, userId: userId);
                      _commentViewModel.refresh();
                      _replyViewModel.refresh();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      children: [
                        //TODO: PrayMOdel에 favorite기능 넣어야함 (용어를 prayUserList로 바꿔서)
                        if (prayModel.prayUserList
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
                        Text("좋아요 ${prayModel.prayUserList.length}",
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
                          '댓글 ${prayModel.commentCount < 1 ? '쓰기' : prayModel.commentCount}',
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
