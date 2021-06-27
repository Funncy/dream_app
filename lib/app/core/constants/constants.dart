import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Constants {
  static Color backgroundColor = Colors.white;
  static Color? primaryColor = Colors.amber[300];
  static Color iconColor = Colors.black26;
  static Color iconSelectedColor = Colors.black;
  static Color favoriteAndCommentColor = Colors.black;

  static TextStyle titleStyle = TextStyle(fontSize: 18.sp, color: Colors.black);

  static TextStyle contentStyle =
      TextStyle(fontSize: 16.sp, color: Colors.black);

  static const double commonGap = 14.0;
  static const double commonLGap = 16.0;
}

//FireStore Name
const String userCollectionName = 'user';
const String noticeCollectionName = 'notice';
const String commentCollectionName = 'comment';
const String replyCollectionName = 'notice_reply';
const String noticeColumnName = 'notice_id';
const String favoriteCollectionName = 'favorite_list';
const String publicPrayCollectionName = 'public_pray';
const String privatePrayCollectionName = 'private_pray';

//Firebase Storage URL
const String noticeImagePath = '/notice';
