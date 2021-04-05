import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/models/core.dart';
import 'package:flutter/foundation.dart';

class NoticeModel extends Core {
  final String did;
  final String uid;
  final String content;
  final List<String> images;
  final int comments;
  final int favorites;

  NoticeModel({
    @required this.did,
    @required this.uid,
    @required this.content,
    @required this.images,
    @required this.comments,
    @required this.favorites,
  });

  factory NoticeModel.fromFirestroe(DocumentSnapshot doc) {
    var json = doc.data();

    var model = NoticeModel(
      did: doc.id,
      uid: json['uid'],
      content: json['content'],
      // subType Error Solution
      images: json['images']?.cast<String>(),
      comments: json['comments'],
      favorites: json['favorites'],
    );
    // print((json['createdAt'] as Timestamp).toDate().toString());
    model.createdAt = (json['createdAt'] as Timestamp)?.toDate() ?? null;
    model.updatedAt = (json['updatedAt'] as Timestamp)?.toDate() ?? null;
    return model;
  }

  Map<String, dynamic> toJson() => {
        'did': uid,
        'uid': uid,
        'content': content,
        'images': images,
        'comments': comments,
        'favorites': favorites,
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
