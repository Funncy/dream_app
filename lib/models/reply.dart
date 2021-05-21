import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/models/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ReplyModel extends Core with EquatableMixin {
  final String id;
  final String userId;
  final String content;
  List<String> favoriteUserList;

  ReplyModel(
      {@required this.id,
      @required this.userId,
      @required this.content,
      @required this.favoriteUserList})
      : super(DateTime.now(), DateTime.now());

  @override
  List<Object> get props => [userId, content, favoriteUserList];

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    var model = ReplyModel(
      id: json['id'],
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
