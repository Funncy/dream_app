import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/models/core.dart';
import 'package:flutter/foundation.dart';

class NoticeModel extends Core {
  final String documentId;
  final String userId;
  final String content;
  final List<String> imageList = [];
  int commentCount;
  List<String> favoriteUserList = [];
  final DocumentReference documentReference;

  NoticeModel({
    @required this.documentId,
    @required this.userId,
    @required this.content,
    @required this.commentCount,
    @required this.favoriteUserList,
    @required this.documentReference,
  });

  factory NoticeModel.fromFirestore(DocumentSnapshot doc) {
    var json = doc.data();

    var model = NoticeModel(
      documentId: doc.id,
      userId: json['user_id'],
      content: json['content'],
      commentCount: json['comment_count'],
      favoriteUserList: json['favorite_user_list'],
      documentReference: doc.reference,
    );

    model.createdAt =
        (json['createdAt'] as Timestamp)?.toDate() ?? Timestamp.now();
    model.updatedAt =
        (json['updatedAt'] as Timestamp)?.toDate() ?? Timestamp.now();
    return model;
  }

  Map<String, dynamic> toJson() => {
        'document_id': userId,
        'user_id': userId,
        'content': content,
        'images': imageList,
        'comment_count': commentCount,
        'favorite_user_list': favoriteUserList,
        'createdAt': createdAt ?? Timestamp.now(),
        'updatedAt': updatedAt ?? Timestamp.now(),
      };

  Map<String, dynamic> toSaveJson() => {
        'user_id': userId,
        'content': content,
        'comment_count': commentCount,
        'favorite_user_list': favoriteUserList,
        'createdAt': createdAt ?? Timestamp.now(),
        'updatedAt': updatedAt ?? Timestamp.now(),
      };
}

//Inner Collection
class NoticeCommentModel extends Core {
  final String docuemtnId;
  final String userId;
  final String content;
  List<NoticeCommentReplyModel> replyList;
  List<String> favoriteUserList;
  final DocumentReference documentReference;

  NoticeCommentModel(
      {@required this.docuemtnId,
      @required this.userId,
      @required this.content,
      @required this.replyList,
      @required this.favoriteUserList,
      @required this.documentReference});

  factory NoticeCommentModel.fromFirestore(DocumentSnapshot doc) {
    var json = doc.data();

    List<Map<String, Object>> replyJsonList = json['reply_list'];
    List<NoticeCommentReplyModel> replyList =
        replyJsonList.map((e) => NoticeCommentReplyModel.fromJson(e)).toList();

    var model = NoticeCommentModel(
      docuemtnId: doc.id,
      userId: json['user_id'],
      content: json['content'],
      replyList: replyList,
      favoriteUserList: json['favorite_user_list'],
      documentReference: doc.reference,
    );

    model.createdAt =
        (json['createdAt'] as Timestamp)?.toDate() ?? Timestamp.now();
    model.updatedAt =
        (json['updatedAt'] as Timestamp)?.toDate() ?? Timestamp.now();
    return model;
  }

  Map<String, dynamic> toJson() => {
        'document_id': docuemtnId,
        'user_id': userId,
        'content': content,
        'reply_list': replyList.map((e) => e.toSaveJson()).toList(),
        'favorite_user_list': favoriteUserList,
        'createdAt': createdAt ?? Timestamp.now(),
        'updatedAt': updatedAt ?? Timestamp.now(),
      };

  Map<String, dynamic> toSaveJson() => {
        'user_id': userId,
        'content': content,
        'reply_list': replyList.map((e) => e.toSaveJson()).toList(),
        'favorite_user_list': favoriteUserList,
        'createdAt': createdAt ?? Timestamp.now(),
        'updatedAt': updatedAt ?? Timestamp.now(),
      };
}

class NoticeCommentReplyModel extends Core {
  final String userId;
  final String content;
  List<String> favoriteUserList;

  NoticeCommentReplyModel(
      {@required this.userId,
      @required this.content,
      @required this.favoriteUserList});

  factory NoticeCommentReplyModel.fromJson(Map<String, Object> json) {
    var model = NoticeCommentReplyModel(
      userId: json['user_id'],
      content: json['content'],
      favoriteUserList: json['favorite_user_list'],
    );
    model.createdAt =
        (json['createdAt'] as Timestamp)?.toDate() ?? Timestamp.now();
    model.updatedAt =
        (json['updatedAt'] as Timestamp)?.toDate() ?? Timestamp.now();
    return model;
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'content': content,
        'favorite_user_list': favoriteUserList,
        'createdAt': createdAt ?? Timestamp.now(),
        'updatedAt': updatedAt ?? Timestamp.now(),
      };

  Map<String, dynamic> toSaveJson() => {
        'user_id': userId,
        'content': content,
        'favorite_user_list': favoriteUserList,
        'createdAt': createdAt ?? Timestamp.now(),
        'updatedAt': updatedAt ?? Timestamp.now(),
      };
}
