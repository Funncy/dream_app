import 'package:dream/bindings/notice_bindings.dart';
import 'package:dream/pages/notice/notice_screen.dart';
import 'package:dream/utils/time_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
    return GetMaterialApp(
      title: '두드리시오',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
            headline1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            subtitle1: TextStyle(fontSize: 15, color: Colors.black54),
            bodyText1: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            bodyText2: TextStyle(fontSize: 16)),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
            name: '/', page: () => NoticeScreen(), binding: NoticeBindings())
      ],
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
