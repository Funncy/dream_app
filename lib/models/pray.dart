import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/models/core.dart';
import 'package:flutter/foundation.dart';

class PrayModel extends Core {
  String id;
  String userId;
  String title;
  String content;
  DocumentReference documentReference;

  PrayModel(
      {@required this.userId, @required this.title, @required this.content})
      : super(DateTime.now(), DateTime.now());

  factory PrayModel.fromFirestore(DocumentSnapshot documentSnapshot) {
    var json = documentSnapshot.data();
    var model = PrayModel(
      userId: json['user_id'],
      title: json['title'],
      content: json['content'],
    );
    model.id = documentSnapshot.id;
    model.documentReference = documentSnapshot.reference;
    model.createdAt = (json['created_at'] as Timestamp)?.toDate() ?? null;
    model.updatedAt = (json['updated_at'] as Timestamp)?.toDate() ?? null;
    return model;
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'title': title,
        'content': content,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
