import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/repositories/notice_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class NoticeRepositoryImpl extends NoticeRepository {
  FirebaseFirestore _firebaseFirestore;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

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
        //공지별 이미지 리스트 가져오기
        var images =
            await _firebaseStorage.ref('/notice/${notice.id}').listAll();

        for (var item in images.items) {
          var url = await item.getDownloadURL();
          notices.last.images.add(url);
        }
      }
    } catch (e) {
      throw ErrorModel(message: '파이어베이스 에러');
    }
    return notices;
  }
}
