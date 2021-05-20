import 'package:dream/models/notice.dart';
import 'package:dream/utils/time_util.dart';
import 'package:dream/viewmodels/notice_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NoticeReply extends StatelessWidget {
  final String noticeId;
  final String commentId;
  final NoticeCommentReplyModel noticeCommentReplyModel;
  NoticeViewModel noticeViewModel = Get.find<NoticeViewModel>();
  NoticeReply({
    Key key,
    @required this.noticeId,
    @required this.commentId,
    @required this.noticeCommentReplyModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //시간 로드
    var date = TimeUtil.getDateString(
        noticeCommentReplyModel.updatedAt ?? noticeCommentReplyModel.createdAt);

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: 30.w,
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/test-img.jpeg'),
                ),
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                //TODO: 추후에 닉네임으로 변경해야함.
                                noticeCommentReplyModel.userId,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                date,
                                style: TextStyle(color: Colors.black38),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: InkWell(child: Icon(Icons.more_vert)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      width: 180.w,
                      child: Text(
                        noticeCommentReplyModel.content,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          //TODO: userID바꿔야함
                          noticeViewModel.toggleReplyFavorite(
                              noticeId: noticeId,
                              commentId: commentId,
                              replyId: noticeCommentReplyModel.id,
                              userId: '123');
                        },
                        child: Text(
                          "공감하기",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.favorite_border),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                              "${noticeCommentReplyModel.favoriteUserList.length ?? "0"}")
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
