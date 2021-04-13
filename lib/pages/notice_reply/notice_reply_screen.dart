import 'package:dream/models/notice.dart';
import 'package:dream/pages/notice_detail/components/bottom_input_bar.dart';
import 'package:dream/pages/notice_detail/components/notice_comment.dart';
import 'package:flutter/material.dart';

class NoticeReplyScreen extends StatefulWidget {
  final NoticeCommentModel noticeCommentModel;

  const NoticeReplyScreen({Key key, this.noticeCommentModel}) : super(key: key);
  @override
  _NoticeReplyScreenState createState() => _NoticeReplyScreenState();
}

class _NoticeReplyScreenState extends State<NoticeReplyScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  void inputReply() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '댓글',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: NoticeComment(
                  noticeCommentModel: widget.noticeCommentModel,
                  isReplyScreen: true,
                ),
              ),
              BottonInputBar(
                textEditingController: _textEditingController,
                inputFunction: inputReply,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
