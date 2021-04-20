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
  FirebaseService firebaseService = FirebaseService();

  //FireStore Name
  final String noticeCollectionName = 'notice';
  final String commentCollectionName = 'notice_comment';
  final String replyCollectionName = 'notice_reply';
  final String noticeColumnName = 'nid';

  //Firebase Storage URL
  final String noticeImagePath = '/notice';

  NoticeRepositoryImpl({@required FirebaseFirestore firebaseFirestore}) {
    _firebaseFirestore = firebaseFirestore;
  }

  @override
  Future<Either<ErrorModel, List<NoticeModel>>> getNoticeList() async {
    List<NoticeModel> noticeList = [];

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
      noticeList.addAll(await firebaseService.getAllData<NoticeModel>(
          collectionName: noticeCollectionName,
          toModelFunction: (e) => NoticeModel.fromFirestore(e)));

      // forEach 비동기 처리를 위한 FutureList
      List<Future<dynamic>> futureList = [];
      noticeList.forEach((element) {
        futureList
            .add(setNoticeImageList(element, firebaseService.getAllImageUrl));
      });
      //javascript에서는 Promise.all
      await Future.wait(futureList);
    } catch (e) {
      return Left(ErrorModel(message: '파이어베이스 에러'));
    }
    return Right(noticeList);
  }

  @override
  Future<Either<ErrorModel, List<NoticeCommentModel>>> getCommentList(
      String nid) async {
    List<NoticeCommentModel> commentList = [];

    try {
      //댓글 가져오기
      commentList.addAll(
          await firebaseService.getAllDataByDid<NoticeCommentModel>(
              collectionName: commentCollectionName,
              columnName: noticeColumnName,
              did: nid,
              toModelFunction: (e) => NoticeCommentModel.fromFirestore(e)));
      //답글 가져오기
      for (var comment in commentList) {
        comment.replys =
            await firebaseService.getAllDataInnerCollectionByReference(
                documentReference: comment.documentReference,
                collectionName: replyCollectionName,
                toModelFunction: (e) =>
                    NoticeCommentReplyModel.fromFirestore(e));
      }
    } catch (e) {
      return Left(ErrorModel(message: '파이어베이스 에러'));
    }
    return Right(commentList);
  }

  @override
  Future<Either<ErrorModel, List<NoticeCommentReplyModel>>> getReplyList(
      String did) async {
    List<NoticeCommentReplyModel> replyList = [];
    try {
      replyList.addAll(await firebaseService
          .getAllDataInnerCollectionById<NoticeCommentReplyModel>(
              did: did,
              parentCollectionName: commentCollectionName,
              childCollectionName: replyCollectionName,
              toModelFunction: (e) =>
                  NoticeCommentReplyModel.fromFirestore(e)));
      return Right(replyList);
    } catch (e) {
      return Left(ErrorModel(message: '파이어베이스 에러'));
    }
  }

  Future<void> setNoticeImageList(
      NoticeModel model, Function getImageList) async {
    model.imageList.addAll(await firebaseService.getAllImageUrl(
        path: noticeImagePath, docId: model.did));
  }

  //댓글 쓰기 함수
  //nid는 notice doucment id로 해당 document값을 저장하기 위함
  Future<Either<ErrorModel, void>> writeComment(
      {@required String nid,
      @required String uid,
      @required String content}) async {
    NoticeCommentModel model = NoticeCommentModel(
        did: null,
        nid: nid,
        uid: uid,
        content: content,
        replyCount: 0,
        favoriteCount: 0,
        documentReference: null);
    model.createdAt = DateTime.now();
    model.updatedAt = model.createdAt;
    try {
      await firebaseService.writeDataInCollection(
          collectionName: commentCollectionName, json: model.toSaveJson());
      //댓글 갯수 증가 시키기 위한 로직
      var noticeData = await firebaseService.getData(
          collectionName: noticeCollectionName, did: nid);
      await firebaseService.updateInCollection(
          collectionName: noticeCollectionName,
          did: nid,
          updateJson: {
            'comment_count': (noticeData['comment_count'] ?? 0) + 1
          });
      return Right(null);
    } catch (e) {
      return Left(ErrorModel(message: '파이어베이스 에러'));
    }
  }

  //답글 쓰기 함수
  //did는 notice_comment doucment id로 해당 inner Collection으로 들어가기 위함
  Future<Either<ErrorModel, void>> writeReply(
      {@required String did,
      @required String uid,
      @required String content}) async {
    NoticeCommentReplyModel model = NoticeCommentReplyModel(
        did: null,
        uid: uid,
        content: content,
        favoriteCount: 0,
        documentReference: null);
    model.createdAt = DateTime.now();
    model.updatedAt = model.createdAt;
    try {
      await firebaseService.writeDataInInnerCollection(
          parentCollectionName: commentCollectionName,
          did: did,
          childCollectionName: replyCollectionName,
          json: model.toSaveJson());
      //답글 갯수 증가 시키기 위한 로직
      var commentData = await firebaseService.getData(
          collectionName: commentCollectionName, did: did);
      await firebaseService.updateInCollection(
          collectionName: commentCollectionName,
          did: did,
          updateJson: {'reply_count': (commentData['reply_count'] ?? 0) + 1});
      //로컬 데이터도 증가가 필요함. 이건 ViewModel에서
      return Right(null);
    } catch (e) {
      return Left(ErrorModel(message: '파이어베이스 에러'));
    }
  }
}
