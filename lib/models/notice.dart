import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/models/core.dart';
import 'package:flutter/foundation.dart';

class NoticeModel extends Core {
  final String did;
  final String uid;
  final String content;
  final List<String> imageList = [];
  final int commentCount;
  final DocumentReference documentReference;
  final int favoriteCount;

  NoticeModel({
    @required this.did,
    @required this.uid,
    @required this.content,
    @required this.commentCount,
    @required this.favoriteCount,
    @required this.documentReference,
  });

  factory NoticeModel.fromFirestore(DocumentSnapshot doc) {
    var json = doc.data();

    var model = NoticeModel(
      did: doc.id,
      uid: json['uid'],
      content: json['content'],
      commentCount: json['comment_count'],
      favoriteCount: json['favorite_count'],
      documentReference: doc.reference,
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
        'favorite_count': favoriteCount,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  Map<String, dynamic> toSaveJson() => {
        'uid': uid,
        'content': content,
        'comment_count': commentCount,
        'favorite_count': favoriteCount,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

class NoticeCommentModel extends Core {
  final String did;
  //Notice ID
  final String nid;
  final String uid;
  final String content;
  final int replyCount;
  final DocumentReference documentReference;
  final int favoriteCount;
  List<NoticeCommentReplyModel> replys;

  NoticeCommentModel(
      {@required this.did,
      @required this.nid,
      @required this.uid,
      @required this.content,
      @required this.replyCount,
      @required this.favoriteCount,
      @required this.documentReference});

  factory NoticeCommentModel.fromFirestore(DocumentSnapshot doc) {
    var json = doc.data();

    var model = NoticeCommentModel(
      did: doc.id,
      nid: json['nid'],
      uid: json['uid'],
      content: json['content'],
      replyCount: json['reply_count'],
      favoriteCount: json['favorite_count'],
      documentReference: doc.reference,
    );

    model.createdAt = (json['createdAt'] as Timestamp)?.toDate() ?? null;
    model.updatedAt = (json['updatedAt'] as Timestamp)?.toDate() ?? null;
    return model;
  }

  Map<String, dynamic> toJson() => {
        'did': did,
        'nid': nid,
        'uid': uid,
        'content': content,
        'reply_count': replyCount,
        'favorite_count': favoriteCount,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  Map<String, dynamic> toSaveJson() => {
        'nid': nid,
        'uid': uid,
        'content': content,
        'reply_count': replyCount,
        'favorite_count': favoriteCount,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

class NoticeCommentReplyModel extends Core {
  final String did;
  final String uid;
  final String content;
  final int favoriteCount;
  final DocumentReference documentReference;

  NoticeCommentReplyModel(
      {@required this.did,
      @required this.uid,
      @required this.content,
      @required this.favoriteCount,
      @required this.documentReference});

  factory NoticeCommentReplyModel.fromFirestore(DocumentSnapshot doc) {
    var json = doc.data();

    var model = NoticeCommentReplyModel(
      did: doc.id,
      uid: json['uid'],
      content: json['content'],
      favoriteCount: json['favorite_count'],
      documentReference: doc.reference,
    );

    model.createdAt = (json['createdAt'] as Timestamp)?.toDate() ?? null;
    model.updatedAt = (json['updatedAt'] as Timestamp)?.toDate() ?? null;
    return model;
  }

  Map<String, dynamic> toJson() => {
        'did': did,
        'uid': uid,
        'content': content,
        'favorite_count': favoriteCount,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  Map<String, dynamic> toSaveJson() => {
        'uid': uid,
        'content': content,
        'favorite_count': favoriteCount,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
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
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  Map<String, dynamic> toSaveJson() => {
        'uid': uid,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
