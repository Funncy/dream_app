import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/core/error/server_error_model.dart';
import 'package:dream/models/comment.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/models/reply.dart';
import 'package:dream/repositories/notice_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:dream/constants.dart';

class NoticeRepositoryImpl extends NoticeRepository {
  late FirebaseFirestore _firebaseFirestore;
  late FirebaseStorage _firebaseStorage;

  NoticeRepositoryImpl(
      {required FirebaseFirestore firebaseFirestore,
      required FirebaseStorage firebaseStorage}) {
    _firebaseFirestore = firebaseFirestore;
    _firebaseStorage = firebaseStorage;
  }

  @override
  Future<void> createDummyData() async {
    var noticeModelList = [
      NoticeModel(
          id: null,
          userId: '123',
          content: '공지사항 01',
          commentCount: 0,
          favoriteUserList: ['245', '356'],
          documentReference: null),
      NoticeModel(
          id: null,
          userId: '123',
          content: '공지사항 02',
          commentCount: 0,
          favoriteUserList: ['245', '356'],
          documentReference: null),
      NoticeModel(
          id: null,
          userId: '123',
          content: '공지사항 03',
          commentCount: 0,
          favoriteUserList: ['123'],
          documentReference: null),
    ];

    var commentList = [
      CommentModel(
          id: null,
          userId: '123',
          content: 'comment 01',
          replyIndex: 2,
          replyList: [
            ReplyModel(
                id: '0',
                userId: '123',
                content: 'reply 01',
                favoriteUserList: []),
            ReplyModel(
                id: '1',
                userId: '123',
                content: 'reply 02',
                favoriteUserList: []),
          ],
          favoriteUserList: [],
          documentReference: null),
      CommentModel(
          id: null,
          userId: '123',
          content: 'comment 01',
          replyIndex: 1,
          replyList: [
            ReplyModel(
                id: '0',
                userId: '123',
                content: 'reply 01',
                favoriteUserList: []),
          ],
          favoriteUserList: [],
          documentReference: null),
    ];

    for (var notice in noticeModelList) {
      var documentReference = await _firebaseFirestore
          .collection(noticeCollectionName)
          .add(notice.toJson());

      for (var comment in commentList) {
        documentReference
            .collection(commentCollectionName)
            .add(comment.toJson());
      }
    }
  }

  @override
  Future<Either<ErrorModel, List<NoticeModel>>> getNoticeList() async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection(noticeCollectionName)
          .orderBy('updated_at')
          .limit(5)
          .get();
      List<NoticeModel> result =
          querySnapshot.docs.map((e) => NoticeModel.fromFirestore(e)).toList();
      //FireStorage 이미지 가져오기
      for (var noticeModel in result) {
        var images =
            await _firebaseStorage.ref('/notice/${noticeModel.id}').listAll();
        for (var item in images.items) {
          var url = await item.getDownloadURL();
          noticeModel.imageList.add(url);
        }
      }

      return Right(result);
    } catch (e) {
      return Left(ServerErrorModel(code: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<NoticeModel>?>> getMoreNoticeList(
      DocumentReference? documentReference) async {
    try {
      DocumentSnapshot documentSnapshot = await documentReference!.get();
      var querySnapshot = await _firebaseFirestore
          .collection(noticeCollectionName)
          .orderBy('updated_at')
          .startAfterDocument(documentSnapshot)
          .limit(5)
          .get();
      List<NoticeModel> result =
          querySnapshot.docs.map((e) => NoticeModel.fromFirestore(e)).toList();
      //FireStorage 이미지 가져오기
      for (var noticeModel in result) {
        var images =
            await _firebaseStorage.ref('/notice/${noticeModel.id}').listAll();
        for (var item in images.items) {
          var url = await item.getDownloadURL();
          noticeModel.imageList.add(url);
        }
      }

      return Right(result);
    } catch (e) {
      return Left(ServerErrorModel(code: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> updateCommentCount(
      {required String? noticeId, bool isIncreasement = true}) async {
    try {
      late int count;
      if (isIncreasement)
        count = 1;
      else
        count = -1;
      //notice doc에서 commentCount 증가
      DocumentReference documentReference =
          _firebaseFirestore.collection(noticeCollectionName).doc(noticeId!);
      await _firebaseFirestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (!snapshot.exists) {
          throw Exception("Comment does not exist!");
        }

        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        int? newCommentCount = (data['comment_count'] as int) + count;

        transaction
            .update(documentReference, {'comment_count': newCommentCount});

        return newCommentCount;
      });
      return Right(null);
    } catch (e) {
      return Left(ServerErrorModel(code: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> toggleNoticeFavorite(
      {required String? noticeId,
      required String userId,
      required bool isDelete}) async {
    try {
      FieldValue fieldValue;
      if (isDelete)
        fieldValue = FieldValue.arrayRemove([userId]);
      else
        fieldValue = FieldValue.arrayUnion([userId]);
      _firebaseFirestore
          .collection(noticeCollectionName)
          .doc(noticeId!)
          .update({'favorite_user_list': fieldValue});
      return Right(null);
    } catch (e) {
      return Left(ServerErrorModel(code: e.toString()));
    }
  }
}
