import 'package:dream/bindings/notice_bindings.dart';
import 'package:dream/pages/bottom_navigation/main_screen.dart';
import 'package:dream/pages/notice/notice_body_widget.dart';
import 'package:dream/pages/notice_detail/notice_detail_screen.dart';
import 'package:dream/utils/time_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.signInAnonymously();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    TimeUtil.setLocalMessages();
    return ScreenUtilInit(
      designSize: Size(360, 690),
      allowFontScaling: false,
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
        getPages: [
          GetPage(
              name: '/', page: () => MainScreen(), binding: NoticeBindings()),
          GetPage(
              name: '/notice_detail',
              page: () => NoticeDetailScreen(),
              binding: NoticeBindings())
        ],
      ),
    );
  }
}

// class InitApp extends StatelessWidget {
//   // Create the initialization Future outside of `build`:
//   final Future<FirebaseApp> _initialization = Firebase.initializeApp();

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       // Initialize FlutterFire:
//       future: _initialization,
//       builder: (context, snapshot) {
//         // Check for errors
//         if (snapshot.hasError) {
//           return LoadingScreen();
//         }

//         // Once complete, show your application
//         if (snapshot.connectionState == ConnectionState.done) {
//           return MyApp();
//         }

//         // Otherwise, show something whilst waiting for initialization to complete
//         return ErrorScreen(
//           message: 'Firebase 초기화 오류',
//         );
//       },
//     );
//   }
// }
