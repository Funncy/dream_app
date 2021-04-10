import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/repositories/notice_repository.dart';
import 'package:dream/services/firestore_servie.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class NoticeRepositoryImpl extends NoticeRepository {
  FirebaseFirestore _firebaseFirestore;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  FirebaseService firebaseServie = FirebaseService();

  NoticeRepositoryImpl({@required FirebaseFirestore firebaseFirestore}) {
    _firebaseFirestore = firebaseFirestore;
  }

  @override
  Future<Either<ErrorModel, List<NoticeModel>>> getNoticeList() async {
    List<NoticeModel> notices = [];

    try {
      //1. 기존 방식
      // var noticeCollection =
      //     await _firebaseFirestore.collection('notice').get();
      // for (var notice in noticeCollection.docs) {
      //   notices.add(NoticeModel.fromFirestroe(notice));
      //   //공지별 이미지 리스트 가져오기
      //   var images =
      //       await _firebaseStorage.ref('/notice/${notice.id}').listAll();

      //   for (var item in images.items) {
      //     var url = await item.getDownloadURL();
      //     notices.last.images.add(url);
      //   }
      // }

      //2. 수정한 방식
      // 위에 방식은 loop 1번에 이미지까지 모두 가져올 수 있었지만
      // 아래와 같이 코드 재활용을 위해서 처리했더니 2번 loop 돌게 되었습니다.
      // 그리고 forEach안에 async 함수를 돌릴 수 없어 아래와 같이 복잡(?) 해졌는데
      // 어떤 방식이 더 좋은 방법인지 이것보다 더 좋은 방법이 있을까요?
      notices.addAll(await firebaseServie.getAllData<NoticeModel>(
          'notice', (e) => NoticeModel.fromFirestore(e)));

      // forEach 비동기 처리를 위한 FutureList
      List<Future<dynamic>> futureList = [];
      notices.forEach((element) {
        futureList
            .add(setNoticeImageList(element, firebaseServie.getAllImageUrl));
      });
      //javascript에서는 Promise.all
      await Future.wait(futureList);
    } catch (e) {
      return Left(ErrorModel(message: '파이어베이스 에러'));
    }
    return Right(notices);
  }

  Future<void> setNoticeImageList(
      NoticeModel model, Function getImageList) async {
    model.images
        .addAll(await firebaseServie.getAllImageUrl('/notice', model.did));
  }
}
