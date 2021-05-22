import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/comment.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/models/reply.dart';
import 'package:dream/repositories/notice_repository.dart';
import 'package:flutter/foundation.dart';

import 'package:dream/constants.dart';

class NoticeRepositoryImpl extends NoticeRepository {
  FirebaseFirestore _firebaseFirestore;
  // FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  NoticeRepositoryImpl({@required FirebaseFirestore firebaseFirestore}) {
    _firebaseFirestore = firebaseFirestore;
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
      var querySnapshot =
          await _firebaseFirestore.collection(noticeCollectionName).get();
      List<NoticeModel> result =
          querySnapshot.docs.map((e) => NoticeModel.fromFirestore(e)).toList();
      return Right(result);
    } catch (e) {
      return Left(ErrorModel(message: 'firebase Error'));
    }
  }

  @override
  Future<Either<ErrorModel, void>> updateCommentCount(
      String noticeId, int commentCount) async {
    try {
      //notice doc에서 commentCount 증가
      DocumentReference documentReference =
          _firebaseFirestore.collection(noticeCollectionName).doc(noticeId);
      await _firebaseFirestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (!snapshot.exists) {
          throw Exception("Comment does not exist!");
        }

        int newCommentCount = snapshot.data()['comment_count'] + 1;

        transaction
            .update(documentReference, {'comment_count': newCommentCount});

        return newCommentCount;
      });
      return Right(null);
    } catch (e) {
      return Left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> toggleNoticeFavorite(
      {@required String noticeId,
      @required String userId,
      @required bool isDelete}) async {
    try {
      FieldValue fieldValue;
      if (isDelete)
        fieldValue = FieldValue.arrayRemove([userId]);
      else
        fieldValue = FieldValue.arrayUnion([userId]);
      _firebaseFirestore
          .collection(noticeCollectionName)
          .doc(noticeId)
          .update({'favorite_user_list': fieldValue});
      return Right(null);
    } catch (e) {
      return Left(ErrorModel(message: e.toString()));
    }
  }
}
