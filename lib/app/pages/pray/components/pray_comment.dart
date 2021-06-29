import 'package:dream/app/core/utils/time_util.dart';
import 'package:dream/app/data/models/comment.dart';
import 'package:dream/app/pages/pray/components/pray_reply.dart';
import 'package:dream/app/viewmodels/pray_comment_view_model.dart';
import 'package:dream/app/viewmodels/pray_reply_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrayComment extends StatefulWidget {
  final CommentModel? commentModel;
  final String? id;
  final bool? isReplyScreen;
  final Function? deleteComment;
  final Function? deleteReply;
  const PrayComment(
      {Key? key,
      this.commentModel,
      this.isReplyScreen,
      this.id,
      this.deleteComment,
      this.deleteReply})
      : super(key: key);

  @override
  _PrayCommentState createState() => _PrayCommentState();
}

class _PrayCommentState extends State<PrayComment> {
  PrayCommentViewModel commentViewModel = Get.find<PrayCommentViewModel>();
  PrayReplyViewModel replyViewModel = Get.find<PrayReplyViewModel>();

  void pageToReply() {
    // Get.to(NoticeReplyScreen(
    //   commentId: widget.commentModel!.id,
    //   noticeId: widget.noticeId,
    // ));
  }

  @override
  Widget build(BuildContext context) {
    //시간 로드
    var date = TimeUtil.getDateString(
        widget.commentModel!.updatedAt ?? widget.commentModel!.createdAt!);

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 250.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                //TODO: 추후 유저 아이디가 아닌 닉네임으로 수정해야함.
                                widget.commentModel!.userId!,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                date,
                                style: TextStyle(color: Colors.black45),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //TODO: 유저 아이디가 내 아이디일때만 띄움 (삭제를 위함)
                      GestureDetector(
                        onTap: () {
                          widget.deleteComment!(widget.commentModel!.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: InkWell(child: Icon(Icons.more_vert_rounded)),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      width: 230.w,
                      child: Text(
                        widget.commentModel!.content!,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              //TODO: 댓글 좋아요 => userId 수정해야함.
                              commentViewModel.toggleCommentFavorite(
                                  prayId: widget.id,
                                  commentId: widget.commentModel!.id,
                                  userId: '123');
                            },
                            child: Text(
                              "공감하기",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          widget.isReplyScreen!
                              ? Container()
                              : InkWell(
                                  onTap: pageToReply,
                                  child: Text(
                                    "답글쓰기",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          //TODO: 댓글 좋아요 => userId 수정해야함.
                          commentViewModel.toggleCommentFavorite(
                              prayId: widget.id,
                              commentId: widget.commentModel!.id,
                              userId: '123');
                          if (widget.isReplyScreen == true) {
                            replyViewModel.refresh();
                          }
                        },
                        child: Row(
                          children: [
                            //TODO: 가짜 유저 아이디 실제 유저 아이디로 변경 필요
                            if (widget.commentModel!.favoriteUserList!
                                .where((userId) => userId == '123')
                                .isNotEmpty)
                              Icon(Icons.favorite)
                            else
                              Icon(Icons.favorite_border),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                                "${widget.commentModel!.favoriteUserList!.length}")
                          ],
                        ),
                      )
                    ],
                  ),
                  //Reply List
                  if (widget.commentModel!.replyList.length > 0)
                    ...(widget.commentModel!.replyList
                        .map((model) => PrayReply(
                              prayId: widget.id,
                              commentId: widget.commentModel!.id,
                              replyModel: model,
                              deleteReply: widget.deleteReply,
                            ))
                        .toList()),
                  if (widget.commentModel!.replyList.length > 0 &&
                      !widget.isReplyScreen!)
                    InkWell(
                      onTap: pageToReply,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 250.w,
                            height: 25.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26),
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                '답글을 입력해주세요.',
                                style: TextStyle(
                                    color: Colors.black38, fontSize: 15),
                              )),
                            ),
                          ),
                        ),
                      ),
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
