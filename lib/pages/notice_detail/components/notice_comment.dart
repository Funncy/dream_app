import 'package:dream/pages/notice_detail/components/notice_reply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoticeComment extends StatelessWidget {
  const NoticeComment({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 250.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "유저 아이디",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  '더드림/시온/두드림 . 25분전',
                                  style: TextStyle(color: Colors.black45),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        width: 230.w,
                        child: Text(
                          "본문 ~~~~ ~~~ \n ~~~~~~~~~~~~~~~ \n ~~~~~~~~~~~~~~ asdjaskdljaslkdjalksjdlkasjdlkjaslkdjaslkjdlkasjdlkjasldkjaslkdjlaksjdlkasjdlkasjdlkajsdlkjaslkdjaslkdjlaksjdlkasjdlkj",
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
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          child: Text(
                            "답글쓰기",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    //Reply List
                    NoticeReply(),
                    NoticeReply(),
                    NoticeReply(),
                    InkWell(
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
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: InkWell(child: Icon(Icons.more_vert)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
