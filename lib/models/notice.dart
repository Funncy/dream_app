import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/models/core.dart';
import 'package:flutter/foundation.dart';

class NoticeModel extends Core {
  final String did;
  final String uid;
  final String content;
  final List<String> imageList = [];
  final int commentCount;
  final int favorites;

  NoticeModel({
    @required this.did,
    @required this.uid,
    @required this.content,
    @required this.commentCount,
    @required this.favorites,
  });

  factory NoticeModel.fromFirestore(DocumentSnapshot doc) {
    var json = doc.data();

    var model = NoticeModel(
      did: doc.id,
      uid: json['uid'],
      content: json['content'],
      commentCount: json['comment_count'],
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
        'images': imageList,
        'comment_count': commentCount,
        'favorites': favorites,
      };
}

class NoticeCommentModel extends Core {
  final String did;
  final String uid;
  final String content;
  final int replyCount;
  List<NoticeCommentReplyModel> replys;

  NoticeCommentModel(
      {@required this.did,
      @required this.uid,
      @required this.content,
      @required this.replyCount});

  factory NoticeCommentModel.fromFirestore(DocumentSnapshot doc) {
    var json = doc.data();

    var model = NoticeCommentModel(
      did: doc.id,
      uid: json['uid'],
      content: json['content'],
      replyCount: json['replyCount'],
    );

    model.createdAt = (json['createdAt'] as Timestamp)?.toDate() ?? null;
    model.updatedAt = (json['updatedAt'] as Timestamp)?.toDate() ?? null;
    return model;
  }

  Map<String, dynamic> toJson() => {
        'did': did,
        'uid': uid,
        'content': content,
        'reply_count': replyCount,
      };
}

class NoticeCommentReplyModel extends Core {
  final String did;
  final String uid;
  final String content;

  NoticeCommentReplyModel(
      {@required this.did, @required this.uid, @required this.content});

  factory NoticeCommentReplyModel.fromFirestore(DocumentSnapshot doc) {
    var json = doc.data();

    var model = NoticeCommentReplyModel(
      did: doc.id,
      uid: json['uid'],
      content: json['content'],
    );

    model.createdAt = (json['createdAt'] as Timestamp)?.toDate() ?? null;
    model.updatedAt = (json['updatedAt'] as Timestamp)?.toDate() ?? null;
    return model;
  }

  Map<String, dynamic> toJson() => {
        'did': did,
        'uid': uid,
        'content': content,
      };
}

class FavoriteModel extends Core {
  final String did;
  final String uid;

  FavoriteModel({@required this.did, @required this.uid});

  factory FavoriteModel.fromFirestroe(DocumentSnapshot doc) {
    var json = doc.data();

    var model = FavoriteModel(
      did: doc.id,
      uid: json['uid'],
    );

    model.createdAt = (json['createdAt'] as Timestamp)?.toDate() ?? null;
    model.updatedAt = (json['updatedAt'] as Timestamp)?.toDate() ?? null;
    return model;
  }

  Map<String, dynamic> toJson() => {
        'did': did,
        'uid': uid,
      };
}
