import 'package:cloud_firestore/cloud_firestore.dart';
import 'core.dart';

class PrayModel extends Core {
  String? id;
  String? userId;
  String? title;
  String? content;
  List<String> prayUserList;
  int commentCount;
  DocumentReference? documentReference;

  PrayModel(
      {required this.userId,
      required this.title,
      required this.content,
      this.commentCount = 0,
      this.prayUserList = const []})
      : super(DateTime.now(), DateTime.now());

  factory PrayModel.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> json = documentSnapshot.data() as Map<String, dynamic>;
    var model = PrayModel(
      userId: json['user_id'],
      title: json['title'],
      content: json['content'],
      commentCount: json['comment_count'],
      prayUserList: json['pray_user_list']?.cast<String>()?.toList(),
    );
    model.id = documentSnapshot.id;
    model.documentReference = documentSnapshot.reference;
    model.createdAt = (json['created_at'] as Timestamp?)?.toDate() ?? null;
    model.updatedAt = (json['updated_at'] as Timestamp?)?.toDate() ?? null;
    return model;
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'title': title,
        'content': content,
        'pray_user_list': prayUserList,
        'comment_count': commentCount,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
