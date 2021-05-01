import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/models/core.dart';
import 'package:flutter/foundation.dart';

class NoticeModel extends Core {
  final String documentId;
  final String userId;
  final String content;
  final List<String> imageList = [];
  int commentCount;
  final DocumentReference documentReference;
  int favoriteCount;
  List<FavoriteModel> favoriteList = [];

  NoticeModel({
    @required this.documentId,
    @required this.userId,
    @required this.content,
    @required this.commentCount,
    @required this.favoriteCount,
    @required this.documentReference,
  });

  factory NoticeModel.fromFirestore(DocumentSnapshot doc) {
    var json = doc.data();

    var model = NoticeModel(
      documentId: doc.id,
      userId: json['user_id'],
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
        'document_id': userId,
        'user_id': userId,
        'content': content,
        'images': imageList,
        'comment_count': commentCount,
        'favorite_count': favoriteCount,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  Map<String, dynamic> toSaveJson() => {
        'user_id': userId,
        'content': content,
        'comment_count': commentCount,
        'favorite_count': favoriteCount,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

class NoticeCommentModel extends Core {
  final String docuemtnId;
  //Notice ID
  final String noticeId;
  final String userId;
  final String content;
  int replyCount;
  final DocumentReference documentReference;
  int favoriteCount;
  List<NoticeCommentReplyModel> replyList;

  NoticeCommentModel(
      {@required this.docuemtnId,
      @required this.noticeId,
      @required this.userId,
      @required this.content,
      @required this.replyCount,
      @required this.favoriteCount,
      @required this.documentReference});

  factory NoticeCommentModel.fromFirestore(DocumentSnapshot doc) {
    var json = doc.data();

    var model = NoticeCommentModel(
      docuemtnId: doc.id,
      noticeId: json['notice_id'],
      userId: json['user_id'],
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
        'document_id': docuemtnId,
        'notice_id': noticeId,
        'user_id': userId,
        'content': content,
        'reply_count': replyCount,
        'favorite_count': favoriteCount,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  Map<String, dynamic> toSaveJson() => {
        'notice_id': noticeId,
        'user_id': userId,
        'content': content,
        'reply_count': replyCount,
        'favorite_count': favoriteCount,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

class NoticeCommentReplyModel extends Core {
  final String documentId;
  final String userId;
  final String content;
  int favoriteCount;
  final DocumentReference documentReference;

  NoticeCommentReplyModel(
      {@required this.documentId,
      @required this.userId,
      @required this.content,
      @required this.favoriteCount,
      @required this.documentReference});

  factory NoticeCommentReplyModel.fromFirestore(DocumentSnapshot doc) {
    var json = doc.data();

    var model = NoticeCommentReplyModel(
      documentId: doc.id,
      userId: json['user_id'],
      content: json['content'],
      favoriteCount: json['favorite_count'],
      documentReference: doc.reference,
    );

    model.createdAt = (json['createdAt'] as Timestamp)?.toDate() ?? null;
    model.updatedAt = (json['updatedAt'] as Timestamp)?.toDate() ?? null;
    return model;
  }

  Map<String, dynamic> toJson() => {
        'document_id': documentId,
        'user_id': userId,
        'content': content,
        'favorite_count': favoriteCount,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  Map<String, dynamic> toSaveJson() => {
        'user_id': userId,
        'content': content,
        'favorite_count': favoriteCount,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

class FavoriteModel extends Core {
  final String documentId;
  final String userId;

  FavoriteModel({@required this.documentId, @required this.userId});

  factory FavoriteModel.fromFirestroe(DocumentSnapshot doc) {
    var json = doc.data();

    var model = FavoriteModel(
      documentId: doc.id,
      userId: json['user_id'],
    );

    model.createdAt = (json['createdAt'] as Timestamp)?.toDate() ?? null;
    model.updatedAt = (json['updatedAt'] as Timestamp)?.toDate() ?? null;
    return model;
  }

  Map<String, dynamic> toJson() => {
        'document_id': documentId,
        'user_id': userId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  Map<String, dynamic> toSaveJson() => {
        'user_id': userId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
