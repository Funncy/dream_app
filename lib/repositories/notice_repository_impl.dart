import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/repositories/notice_repository.dart';
import 'package:flutter/foundation.dart';

class NoticeRepositoryImpl extends NoticeRepository {
  FirebaseFirestore _firebaseFirestore;

  NoticeRepositoryImpl({@required FirebaseFirestore firebaseFirestore}) {
    _firebaseFirestore = firebaseFirestore;
  }

  @override
  Future<List<NoticeModel>> getNoticeList() async {
    List<NoticeModel> notices = [];

    try {
      var noticeCollection =
          await _firebaseFirestore.collection('notice').get();
      for (var notice in noticeCollection.docs) {
        notices.add(NoticeModel.fromFirestroe(notice));
      }
    } catch (e) {
      throw ErrorModel(message: '파이어베이스 에러');
    }
    return notices;
  }
}
