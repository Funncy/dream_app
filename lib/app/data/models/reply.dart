import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'core.dart';

class ReplyModel extends Core with EquatableMixin {
  final String? id;
  final String? userId;
  final String nickName;
  final String profileImage;
  final String? content;
  List<String>? favoriteUserList;

  ReplyModel(
      {required this.id,
      required this.userId,
      required this.content,
      required this.nickName,
      required this.profileImage,
      required this.favoriteUserList})
      : super(DateTime.now(), DateTime.now());

  @override
  List<Object?> get props => [userId, content, favoriteUserList];

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    var model = ReplyModel(
      id: json['id'],
      userId: json['user_id'],
      nickName: json['nick_name'],
      profileImage: json['profile_image'],
      content: json['content'],
      favoriteUserList: json['favorite_user_list']?.cast<String>()?.toList(),
    );
    model.createdAt = (json['created_at'] as Timestamp?)?.toDate() ?? null;
    model.updatedAt = (json['updated_at'] as Timestamp?)?.toDate() ?? null;
    return model;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'nick_name': nickName,
        'profile_image': profileImage,
        'content': content,
        'favorite_user_list': favoriteUserList,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
