import 'package:cached_network_image/cached_network_image.dart';
import 'package:dream/app/core/utils/time_util.dart';
import 'package:dream/app/data/models/reply.dart';
import 'package:dream/app/data/models/user.dart';
import 'package:dream/app/viewmodels/comment_view_model.dart';
import 'package:dream/app/viewmodels/reply_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NoticeReply extends StatelessWidget {
  final String? noticeId;
  final String? commentId;
  final ReplyModel replyModel;
  final Function? deleteReply;
  final ReplyViewModel replyViewModel = Get.find<ReplyViewModel>();
  final CommentViewModel commentViewModel = Get.find<CommentViewModel>();
  final UserModel user;
  late final ImageProvider profileImage;
  NoticeReply({
    Key? key,
    required this.noticeId,
    required this.commentId,
    required this.replyModel,
    required this.deleteReply,
    required this.user,
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
                  backgroundImage:
                      CachedNetworkImageProvider(replyModel.profileImage),
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
                                replyModel.nickName,
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
                        if (replyModel.userId == user.id)
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
                              noticeId: noticeId,
                              commentId: commentId,
                              replyId: replyModel.id,
                              userId: user.id);
                        },
                        child: Text(
                          "공감하기",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await replyViewModel.toggleReplyFavorite(
                              noticeId: noticeId,
                              commentId: commentId,
                              replyId: replyModel.id,
                              userId: user.id);
                          //답글의 좋아요 버튼을 눌러도 댓글화면에도 바로 반영하기 위함.
                          commentViewModel.refresh();
                        },
                        child: Row(
                          children: [
                            if (replyModel.favoriteUserList!
                                .where((userId) => userId == user.id)
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
