import 'package:dream/constants.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/pages/bottom_navigation/notice/components/notice_card.dart';
import 'package:dream/pages/notice_detail/components/bottom_input_bar.dart';
import 'package:dream/pages/notice_detail/components/notice_comment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
