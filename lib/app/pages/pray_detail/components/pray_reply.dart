import 'package:dream/app/core/utils/time_util.dart';
import 'package:dream/app/data/models/reply.dart';
import 'package:dream/app/viewmodels/pray_comment_view_model.dart';
import 'package:dream/app/viewmodels/pray_reply_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrayReply extends StatelessWidget {
  final String? prayId;
  final String? commentId;
  final ReplyModel replyModel;
  final Function? deleteReply;
  final PrayReplyViewModel replyViewModel = Get.find<PrayReplyViewModel>();
  final PrayCommentViewModel commentViewModel =
      Get.find<PrayCommentViewModel>();
  PrayReply({
    Key? key,
    required this.prayId,
    required this.commentId,
    required this.replyModel,
    required this.deleteReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //시간 로드
    var date =
        TimeUtil.getDateString(replyModel.updatedAt ?? replyModel.createdAt!);

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
                                replyModel.userId!,
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
                          child: InkWell(
                              onTap: () {
                                deleteReply!(commentId, replyModel);
                              },
                              child: Icon(Icons.more_vert)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      width: 180.w,
                      child: Text(
                        replyModel.content!,
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
                          replyViewModel.toggleReplyFavorite(
                              prayId: prayId,
                              commentId: commentId,
                              replyId: replyModel.id,
                              userId: '123');
                        },
                        child: Text(
                          "공감하기",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          //TODO: userID바꿔야함
                          await replyViewModel.toggleReplyFavorite(
                              prayId: prayId,
                              commentId: commentId,
                              replyId: replyModel.id,
                              userId: '123');
                          //답글의 좋아요 버튼을 눌러도 댓글화면에도 바로 반영하기 위함.
                          commentViewModel.refresh();
                        },
                        child: Row(
                          children: [
                            //TODO: 가짜 유저 아이디 실제 유저 아이디로 변경 필요
                            if (replyModel.favoriteUserList!
                                .where((userId) => userId == '123')
                                .isNotEmpty)
                              Icon(Icons.favorite)
                            else
                              Icon(Icons.favorite_border),
                            SizedBox(
                              width: 5,
                            ),
                            Text("${replyModel.favoriteUserList!.length}")
                          ],
                        ),
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
