import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/app/data/models/user.dart';
import 'package:dream/app/pages/common_mixin/alert_mixin.dart';
import 'package:dream/app/viewmodels/auth_view_model.dart';
import 'package:dream/app/viewmodels/pray_send_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PraySendScreen extends StatefulWidget {
  static final routeName = '/pray_send';
  @override
  _PraySendScreenState createState() => _PraySendScreenState();
}

class _PraySendScreenState extends State<PraySendScreen> with AlertMixin {
  bool? isPublic = Get.arguments;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  PraySendViewModel prayViewModel = Get.find<PraySendViewModel>();
  final UserModel user = Get.find<AuthViewModel>().user!;
  @override
  void initState() {
    super.initState();
  }

  void sendPray() async {
    await prayViewModel.sendPray(
        user: user,
        title: titleController.text,
        content: contentController.text,
        isPublic: isPublic);
    ViewState sendState = prayViewModel.sendState!;
    if (sendState is Loaded)
      //전송 완료 뒤로가기
      Get.back();
    else if (sendState is Error) alert(sendState);
  }

  @override
  Widget build(BuildContext context) {
    String title = isPublic! ? "공개 기도편지" : "비밀 기도편지";
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('기도제목'),
                    TextField(
                      controller: titleController,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text('기도 내용'),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black38),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              controller: contentController,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: null,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendPray,
        child: Icon(Icons.send),
      ),
    );
  }
}
