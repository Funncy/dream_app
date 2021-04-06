import 'package:dream/constants.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/pages/notice/components/notice_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoticeDetailScreen extends StatelessWidget {
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
          color: Colors.black12,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    NoticeCard(
                      notice: notice,
                    ),
                    Container(
                      child: Text("동역자를 존중하며 따뜻한 교회 문화를 함께 만들어가요."),
                    ),
                  ],
                  //댓글 리스트 만들어야함.
                ),
              ),
              //TODO: 대화창 만들어야함.
              Container(
                height: 80,
                child: Row(
                  children: [],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
