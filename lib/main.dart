import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/bindings/notice_bindings.dart';
import 'package:dream/bindings/pray_bindings.dart';
import 'package:dream/pages/bottom_navigation/main_screen.dart';
import 'package:dream/pages/notice_detail/notice_detail_screen.dart';
import 'package:dream/pages/pray/pray_send_screen.dart';
import 'package:dream/utils/time_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //TODO: Firestore읽기 위한 익명 유저처리 추후 삭제하고 로그인 기능으로 처리해야함.
  await FirebaseAuth.instance.signInAnonymously();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //추후 시간처리를 위한 locale처리
    TimeUtil.setLocalMessages();

    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: () => GetMaterialApp(
        title: '두드리시오',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(
              headline1:
                  TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              subtitle1: TextStyle(fontSize: 13.ssp, color: Colors.black54),
              bodyText1:
                  TextStyle(fontSize: 15.ssp, fontWeight: FontWeight.normal),
              bodyText2: TextStyle(fontSize: 14.sp)),
        ),
        initialRoute: '/',
        //페이지 라우터
        getPages: [
          GetPage(
              name: '/', page: () => MainScreen(), binding: NoticeBindings()),
          GetPage(
              name: NoticeDetailScreen.routeName,
              page: () => NoticeDetailScreen(),
              binding: NoticeBindings()),
          GetPage(
              name: PraySendScreen.routeName,
              page: () => PraySendScreen(),
              binding: PrayBindings()),
        ],
      ),
    );
  }
}
