import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/repositories/notice_repository_impl.dart';
import 'package:dream/viewmodels/notice_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class NoticeScreen extends StatefulWidget {
  @override
  _NoticeScreenState createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  final noticeViewmodel = Get.find<NoticeViewModel>();

  @override
  void initState() {
    noticeViewmodel.getNoticeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("공지사항"),
      ),
      body: Container(
        child: Obx(() {
          var screenStatus = noticeViewmodel.getScreenStatus();
          var notices = noticeViewmodel.notices;

          if (notices.length == 0) {
            // TODO: Empty , Error 구분
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: notices.length,
              itemBuilder: (context, index) {
                if (notices[index].comments.length != 0) {
                  print("Notices ${notices[index].comments[0].content}");
                  print(
                      "Reply ${notices[index].comments[0].replys[0].content}");
                }
                return ListTile(
                  title: Text(notices[index].content),
                );
              });
        }),
      ),
    );
  }
}
