import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/models/core.dart';
import 'package:flutter/foundation.dart';

class NoticeModel extends Core {
  String uid;
  String content;
  List<String> images;
  List<NoticeCommentModel> comments;
  List<FavoriteModel> favorites;

  NoticeModel(
      {@required this.uid,
      @required this.content,
      @required this.images,
      this.comments,
      this.favorites});

  factory NoticeModel.fromFirestroe(DocumentSnapshot doc) {
    var json = doc.data();

    return NoticeModel(
        uid: json['uid'],
        content: json['content'],
        // subType Error Solution
        images: json['images']?.cast<String>());
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'content': content,
        'images': images,
      };
}

class NoticeCommentModel extends Core {
  String uid;
  String content;
  List<NoticeCommentReplyModel> replys;

  NoticeCommentModel({@required this.uid, @required this.content});

  NoticeCommentModel.fromFirestroe(DocumentSnapshot doc)
      : uid = doc.data()['uid'],
        content = doc.data()['content'];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'content': content,
      };
}

class NoticeCommentReplyModel extends Core {
  String uid;
  String content;

  NoticeCommentReplyModel({@required this.uid, @required this.content});

  NoticeCommentReplyModel.fromFirestroe(DocumentSnapshot doc)
      : uid = doc.data()['uid'],
        content = doc.data()['content'];

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'content': content,
      };
}

class FavoriteModel extends Core {
  String uid;

  FavoriteModel({@required this.uid});

  FavoriteModel.fromFirestroe(DocumentSnapshot doc) : uid = doc.data()['uid'];

  Map<String, dynamic> toJson() => {
        'uid': uid,
      };
}
