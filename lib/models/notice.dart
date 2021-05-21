import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/models/core.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

class NoticeModel extends Core with EquatableMixin {
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
  }) : super(DateTime.now(), DateTime.now());

  factory NoticeModel.fromFirestore(DocumentSnapshot doc) {
    var json = doc.data();

    var model = NoticeModel(
      documentId: doc.id,
      userId: json['user_id'],
      content: json['content'],
      commentCount: json['comment_count'],
      favoriteUserList: json['favorite_user_list']?.cast<String>()?.toList(),
      documentReference: doc.reference,
    );

    model.createdAt = (json['created_at'] as Timestamp)?.toDate() ?? null;
    model.updatedAt = (json['updated_at'] as Timestamp)?.toDate() ?? null;
    return model;
  }

  Map<String, dynamic> toJson() => {
        'document_id': userId,
        'user_id': userId,
        'content': content,
        'images': imageList,
        'comment_count': commentCount,
        'favorite_user_list': favoriteUserList,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  Map<String, dynamic> toSaveJson() => {
        'user_id': userId,
        'content': content,
        'comment_count': commentCount,
        'favorite_user_list': favoriteUserList,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
  @override
  List<Object> get props => [
        documentId,
        userId,
        content,
        imageList,
        commentCount,
        favoriteUserList,
        documentReference
      ];
}

//Inner Collection
class NoticeCommentModel extends Core with EquatableMixin {
  final String documentId;
  final String userId;
  final String content;
  List<NoticeCommentReplyModel> replyList;
  int replyIndex;
  List<String> favoriteUserList;
  final DocumentReference documentReference;

  NoticeCommentModel(
      {@required this.documentId,
      @required this.userId,
      @required this.content,
      @required this.replyList,
      @required this.replyIndex,
      @required this.favoriteUserList,
      @required this.documentReference})
      : super(DateTime.now(), DateTime.now());

  @override
  List<Object> get props => [
        documentId,
        userId,
        content,
        replyIndex,
        replyList.map((e) => e.props).toList(),
        favoriteUserList,
        documentReference
      ];

  factory NoticeCommentModel.fromFirestore(DocumentSnapshot doc) {
    var json = doc.data();

    List<Map<String, Object>> replyJsonList =
        json['reply_list']?.cast<Map<String, Object>>();
    List<NoticeCommentReplyModel> replyList = [];
    replyList = replyJsonList
        .map((e) => NoticeCommentReplyModel.fromJson(e, replyList.length))
        .toList()
          ..sort((a, b) => a.updatedAt.compareTo(b.updatedAt));

    var model = NoticeCommentModel(
      documentId: doc.id,
      userId: json['user_id'],
      content: json['content'],
      replyIndex: json['reply_index'],
      replyList: replyList,
      favoriteUserList: json['favorite_user_list']?.cast<String>()?.toList(),
      documentReference: doc.reference,
    );

    model.createdAt = (json['created_at'] as Timestamp)?.toDate() ?? null;
    model.updatedAt = (json['updated_at'] as Timestamp)?.toDate() ?? null;
    return model;
  }

  Map<String, dynamic> toJson() => {
        'document_id': documentId,
        'user_id': userId,
        'content': content,
        'reply_index': replyIndex,
        'reply_list': replyList.map((e) => e.toSaveJson()).toList(),
        'favorite_user_list': favoriteUserList,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  Map<String, dynamic> toSaveJson() => {
        'user_id': userId,
        'content': content,
        'reply_index': replyIndex,
        'reply_list': replyList.map((e) => e.toSaveJson()).toList(),
        'favorite_user_list': favoriteUserList,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class NoticeCommentReplyModel extends Core with EquatableMixin {
  final String id;
  final String userId;
  final String content;
  List<String> favoriteUserList;

  NoticeCommentReplyModel(
      {@required this.id,
      @required this.userId,
      @required this.content,
      @required this.favoriteUserList})
      : super(DateTime.now(), DateTime.now());

  @override
  List<Object> get props => [userId, content, favoriteUserList];

  factory NoticeCommentReplyModel.fromJson(
      Map<String, dynamic> json, int index) {
    var model = NoticeCommentReplyModel(
      id: index.toString(),
      userId: json['user_id'],
      content: json['content'],
      favoriteUserList: json['favorite_user_list']?.cast<String>()?.toList(),
    );
    model.createdAt = (json['created_at'] as Timestamp)?.toDate() ?? null;
    model.updatedAt = (json['updated_at'] as Timestamp)?.toDate() ?? null;
    return model;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'content': content,
        'favorite_user_list': favoriteUserList,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };

  Map<String, dynamic> toSaveJson() => {
        'id': id,
        'user_id': userId,
        'content': content,
        'favorite_user_list': favoriteUserList,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
