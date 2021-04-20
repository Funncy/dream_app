import 'package:dream/models/notice.dart';
import 'package:dream/pages/notice_detail/components/notice_reply.dart';
import 'package:dream/pages/notice_reply/notice_reply_screen.dart';
import 'package:dream/utils/time_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NoticeComment extends StatelessWidget {
  final NoticeCommentModel noticeCommentModel;
  final String nid;
  final bool isReplyScreen;
  const NoticeComment({
    Key key,
    this.noticeCommentModel,
    this.isReplyScreen,
    this.nid,
  }) : super(key: key);

  void pageToReply() {
    Get.to(NoticeReplyScreen(
      noticeCommentModel: noticeCommentModel,
      nid: nid,
    ));
  }

  @override
  Widget build(BuildContext context) {
    //시간 로드
    var date = TimeUtil.getDateString(
        noticeCommentModel.updatedAt ?? noticeCommentModel.createdAt);

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
                                noticeCommentModel.uid,
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
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: InkWell(child: Icon(Icons.more_vert)),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      width: 230.w,
                      child: Text(
                        noticeCommentModel.content,
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
                            child: Text(
                              "공감하기",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          isReplyScreen
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
                      //TODO: 좋아요 숫자에 따라 처리
                      Row(
                        children: [
                          Icon(Icons.favorite_border),
                          SizedBox(
                            width: 5,
                          ),
                          Text("${noticeCommentModel.favoriteCount ?? "0"}")
                        ],
                      )
                    ],
                  ),
                  //Reply List
                  if (noticeCommentModel.replys.length > 0)
                    ...noticeCommentModel.replys
                        .map((model) => NoticeReply(
                              noticeCommentReplyModel: model,
                            ))
                        .toList(),
                  if (noticeCommentModel.replyCount > 0 && !isReplyScreen)
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
