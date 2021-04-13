import 'package:dream/models/notice.dart';
import 'package:dream/utils/time_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoticeReply extends StatelessWidget {
  final NoticeCommentReplyModel noticeCommentReplyModel;
  const NoticeReply({
    Key key,
    this.noticeCommentReplyModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //시간 로드
    var date = TimeUtil.getDateString(
        noticeCommentReplyModel.updatedAt ?? noticeCommentReplyModel.createdAt);

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Flexible(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              //TODO: 추후에 닉네임으로 변경해야함.
                              noticeCommentReplyModel.uid,
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
                      children: [
                        InkWell(
                          child: Text(
                            "공감하기",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    //Reply List
                    Container()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: InkWell(child: Icon(Icons.more_vert)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
