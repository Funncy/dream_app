import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'core.dart';

class NoticeModel extends Core with EquatableMixin {
  final String? id;
  final String? userId;
  final String? content;
  final List<String> imageList = [];
  int? commentCount;
  List<String>? favoriteUserList = [];
  final DocumentReference? documentReference;

  NoticeModel({
    required this.id,
    required this.userId,
    required this.content,
    required this.commentCount,
    required this.favoriteUserList,
    required this.documentReference,
  }) : super(DateTime.now(), DateTime.now());

  factory NoticeModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;

    var model = NoticeModel(
      id: doc.id,
      userId: json['user_id'],
      content: json['content'],
      commentCount: json['comment_count'],
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
        'comment_count': commentCount,
        'favorite_user_list': favoriteUserList,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
  @override
  List<Object?> get props => [
        id,
        userId,
        content,
        imageList,
        commentCount,
        favoriteUserList,
        documentReference
      ];
}
