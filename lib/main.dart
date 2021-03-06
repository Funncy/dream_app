import 'package:dream/app/pages/bindings/profile_bindins.dart';
import 'package:dream/app/pages/login/sign_up_screen.dart';
import 'package:dream/app/pages/notice_detail/notice_detail_screen.dart';
import 'package:dream/app/pages/pray_detail/pray_detail_screen.dart';
import 'package:dream/app/pages/pray/pray_send_screen.dart';
import 'package:dream/app/pages/profile/profile_screen.dart';
import 'package:dream/app/pages/root_screen.dart';
import 'package:dream/app/core/utils/time_util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'app/pages/bindings/notice_bindings.dart';
import 'app/pages/bindings/pray_bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
              subtitle1: TextStyle(fontSize: 13.sp, color: Colors.black54),
              bodyText1:
                  TextStyle(fontSize: 15.sp, fontWeight: FontWeight.normal),
              bodyText2: TextStyle(fontSize: 14.sp)),
        ),
        initialRoute: '/',
        //페이지 라우터
        getPages: [
          GetPage(
              name: '/',
              page: () => RootScreen(),
              bindings: [NoticeBindings(), PrayBindings()]),
          GetPage(
              name: NoticeDetailScreen.routeName,
              page: () => NoticeDetailScreen(),
              binding: NoticeBindings()),
          GetPage(
              name: PraySendScreen.routeName,
              page: () => PraySendScreen(),
              binding: PrayBindings()),
          GetPage(
            name: SignUpScreen.routeName,
            page: () => SignUpScreen(),
          ),
          GetPage(
              name: ProfileScreen.routeName,
              page: () => ProfileScreen(),
              binding: ProfileBindins()),
          GetPage(
              name: PrayDetailScreen.routeName,
              page: () => PrayDetailScreen(),
              binding: PrayBindings()),
        ],
      ),
    );
  }
}
