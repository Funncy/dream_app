import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/models/core.dart';
import 'package:dream/models/reply.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

//Inner Collection
class CommentModel extends Core with EquatableMixin {
  final String? id;
  final String? userId;
  final String? content;
  List<ReplyModel> replyList;
  int? replyIndex;
  List<String>? favoriteUserList;
  final DocumentReference? documentReference;

  CommentModel(
      {required this.id,
      required this.userId,
      required this.content,
      required this.replyList,
      required this.replyIndex,
      required this.favoriteUserList,
      required this.documentReference})
      : super(DateTime.now(), DateTime.now());

  @override
  List<Object?> get props => [
        id,
        userId,
        content,
        replyIndex,
        replyList.map((e) => e.props).toList(),
        favoriteUserList,
        documentReference
      ];

  factory CommentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? json = doc.data() as Map<String, dynamic>;

    List<Map<String, Object>> replyJsonList =
        json['reply_list']?.cast<Map<String, Object>>();
    List<ReplyModel> replyList = [];
    replyList = replyJsonList.map((e) => ReplyModel.fromJson(e)).toList()
      ..sort((a, b) => a.updatedAt!.compareTo(b.updatedAt!));

    var model = CommentModel(
      id: doc.id,
      userId: json['user_id'],
      content: json['content'],
      replyIndex: json['reply_index'],
      replyList: replyList,
      favoriteUserList: json['favorite_user_list']?.cast<String>()?.toList(),
      documentReference: doc.reference,
    );

    model.createdAt = (json['created_at'] as Timestamp?)?.toDate() ?? null;
    model.updatedAt = (json['updated_at'] as Timestamp?)?.toDate() ?? null;
    return model;
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'content': content,
        'reply_index': replyIndex,
        'reply_list': replyList.map((e) => e.toJson()).toList(),
        'favorite_user_list': favoriteUserList,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
