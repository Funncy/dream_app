import 'package:cloud_firestore/cloud_firestore.dart';

import 'core.dart';

class UserModel extends Core {
  late String id;
  late String? nickName;
  late String email;
  late String? profileImageUrl;
  late bool isActivate;

  UserModel({
    required this.id,
    required this.email,
    this.isActivate = false,
    this.nickName,
    this.profileImageUrl,
  }) : super(DateTime.now(), DateTime.now());

  factory UserModel.fromFirebase(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> json = documentSnapshot.data() as Map<String, dynamic>;
    UserModel userModel = UserModel(
      id: documentSnapshot.id,
      email: json['email'],
      isActivate: json['is_activate'],
      nickName: json['nick_name'],
      profileImageUrl: json['profile_image_url'],
    );
    userModel.createdAt = (json['created_at'] as Timestamp).toDate();
    userModel.updatedAt = (json['updated_at'] as Timestamp).toDate();

    return userModel;
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'nick_name': nickName,
        'email': email,
        'profile_image_url': profileImageUrl,
        'is_activate': isActivate,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
