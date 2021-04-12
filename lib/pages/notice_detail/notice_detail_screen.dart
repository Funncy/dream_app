import 'package:dream/constants.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/pages/bottom_navigation/notice/components/notice_card.dart';
import 'package:dream/pages/notice_detail/components/bottom_input_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoticeDetailScreen extends StatefulWidget {
  @override
  _NoticeDetailScreenState createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends State<NoticeDetailScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //댓글 목록을 가져와야함.
  }

  void inputComment() {
    //TODO: FireStore에 댓글 추가하는 로직 추가해야함. viewmodel 통해서
  }

  @override
  Widget build(BuildContext context) {
    var notice = Get.arguments as NoticeModel;
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Constants.backgroundColor,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    NoticeCard(
                      notice: notice,
                    ),
                    Divider(
                      thickness: 1.0,
                      color: Colors.black26,
                    ),
                    NoticeComment(),
                    NoticeComment(),
                    NoticeComment()
                  ],
                  //댓글 리스트 만들어야함.
                ),
              ),
              //TODO: 대화창 만들어야함.
              BottonInputBar(
                textEditingController: _textEditingController,
                inputFunction: inputComment,
              )
            ],
          ),
        ),
      ),
    );
  }
}

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60.w,
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/test-img.jpeg'),
              ),
            ),
            Column(
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
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              "유저 아이디",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text('더드림/시온/두드림 . 25분전'),
                          ),
                        ],
                      ),
                    ),
                    InkWell(child: Icon(Icons.more_vert))
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
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
