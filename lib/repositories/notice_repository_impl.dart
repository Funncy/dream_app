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

  NoticeRepositoryImpl({@required FirebaseFirestore firebaseFirestore}) {
    _firebaseFirestore = firebaseFirestore;
  }

  @override
  Future<Either<ErrorModel, List<NoticeModel>>> getNoticeList() async {
    List<NoticeModel> noticeList = [];

    try {
      //1. 기존 방식
      var noticeCollection =
          await _firebaseFirestore.collection('notice').get();
      for (var notice in noticeCollection.docs) {
        noticeList.add(NoticeModel.fromFirestore(notice));
        //공지별 이미지 리스트 가져오기
        ListResult images =
            await _firebaseStorage.ref('/notice/${notice.id}').listAll();

        for (Reference item in images.items) {
          String url = await item.getDownloadURL();
          noticeList.last.imageList.add(url);
        }

        //공지별 좋아요 리스트 가져오기
        //좋아요 숫자가 0이면 접근 하지 않음
        if (noticeList.last.favoriteCount > 0) {
          var favoriteList = await getFavoriteList(
              collectionName: noticeCollectionName, documentId: notice.id);
          if (favoriteList.isLeft()) {
            return Left(ErrorModel(message: 'get Notice favorite error'));
          }
          noticeList.last.favoriteList = favoriteList.getOrElse(() => null);
        }
      }
    } catch (e) {
      return Left(ErrorModel(message: '파이어베이스 에러'));
    }
    return Right(noticeList);
  }

  @override
  Future<Either<ErrorModel, List<NoticeCommentModel>>> getCommentList(
      {@required String noticeId}) async {
    List<NoticeCommentModel> commentList = [];

    try {
      //댓글 가져오기
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(commentCollectionName)
          .where(noticeColumnName, isEqualTo: noticeId)
          .orderBy('updatedAt')
          .get();
      commentList.addAll(querySnapshot.docs
          .map((e) => NoticeCommentModel.fromFirestore(e))
          .toList());

      for (var comment in commentList) {
        var result = await getReplyList(commentId: comment.docuemtnId);
        result.fold((l) {
          throw ErrorModel(message: '파이어베이스 에러');
        }, (r) {
          comment.replyList = r;
        });
      }
    } catch (e) {
      return Left(ErrorModel(message: '파이어베이스 에러'));
    }
    return Right(commentList);
  }

  Future<Either<ErrorModel, List<FavoriteModel>>> getFavoriteList(
      {@required String collectionName, @required String documentId}) async {
    try {
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(collectionName)
          .doc(documentId)
          .collection(favoriteCollectionName)
          .orderBy('user_id')
          .get();
      return Right(querySnapshot.docs
          .map((e) => FavoriteModel.fromFirestroe(e))
          .toList());
    } catch (e) {
      return Left(ErrorModel(message: 'Firebase Error'));
    }
  }

  @override
  Future<Either<ErrorModel, List<NoticeCommentReplyModel>>> getReplyList(
      {@required String commentId}) async {
    try {
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(commentCollectionName)
          .doc(commentId)
          .collection(replyCollectionName)
          .orderBy('updatedAt')
          .get();

      return Right(querySnapshot.docs
          .map((e) => NoticeCommentReplyModel.fromFirestore(e))
          .toList());
    } catch (e) {
      return Left(ErrorModel(message: '파이어베이스 에러'));
    }
  }

  @override
  Future<void> setNoticeImageList(
      {@required NoticeModel model, @required Function getImageList}) async {
    var imageList = await _firebaseStorage
        .ref('$noticeImagePath/${model.documentId}')
        .listAll();
    List<String> imageUrlList = [];
    for (var item in imageList.items)
      imageUrlList.add(await item.getDownloadURL());

    model.imageList.clear();
    model.imageList.addAll(imageUrlList);
  }

  //댓글 쓰기 함수
  //nid는 notice doucment id로 해당 document값을 저장하기 위함
  @override
  Future<Either<ErrorModel, void>> writeComment(
      {@required String noticeId,
      @required String userId,
      @required String content}) async {
    NoticeCommentModel model = NoticeCommentModel(
        docuemtnId: null,
        noticeId: noticeId,
        userId: userId,
        content: content,
        replyCount: 0,
        favoriteCount: 0,
        documentReference: null);
    model.createdAt = DateTime.now();
    model.updatedAt = model.createdAt;
    try {
      await _firebaseFirestore
          .collection(commentCollectionName)
          .add(model.toSaveJson());

      var noticeSnapshot = await _firebaseFirestore
          .collection(noticeCollectionName)
          .doc(noticeId)
          .get();

      await _firebaseFirestore
          .collection(noticeCollectionName)
          .doc(noticeId)
          .update({
        'comment_count': (noticeSnapshot.data()['comment_count'] ?? 0) + 1
      });

      return Right(null);
    } catch (e) {
      return Left(ErrorModel(message: '파이어베이스 에러'));
    }
  }

  //답글 쓰기 함수
  //did는 notice_comment doucment id로 해당 inner Collection으로 들어가기 위함
  @override
  Future<Either<ErrorModel, void>> writeReply(
      {@required String commentId,
      @required String userId,
      @required String content}) async {
    NoticeCommentReplyModel model = NoticeCommentReplyModel(
        documentId: null,
        userId: userId,
        content: content,
        favoriteCount: 0,
        documentReference: null);
    model.createdAt = DateTime.now();
    model.updatedAt = model.createdAt;
    try {
      await _firebaseFirestore
          .collection(commentCollectionName)
          .doc(commentId)
          .collection(replyCollectionName)
          .add(model.toSaveJson());

      //답글 갯수 증가 시키기 위한 로직
      var commentSnapshot = await _firebaseFirestore
          .collection(commentCollectionName)
          .doc(commentId)
          .get();

      await _firebaseFirestore
          .collection(commentCollectionName)
          .doc(commentId)
          .update({
        'reply_count': (commentSnapshot.data()['reply_count'] ?? 0) + 1
      });

      return Right(null);
    } catch (e) {
      return Left(ErrorModel(message: '파이어베이스 에러'));
    }
  }

  @override
  Future<Either<ErrorModel, void>> addFavorite(
      {@required String collectionName,
      @required String documentId,
      @required String userId}) async {
    FavoriteModel favoriteModel =
        FavoriteModel(documentId: documentId, userId: userId);

    try {
      await _firebaseFirestore
          .collection(collectionName)
          .doc(documentId)
          .collection(favoriteCollectionName)
          .add(favoriteModel.toSaveJson());
    } catch (e) {
      return Left(ErrorModel(message: 'Firebase Error'));
    }
    return Right(null);
  }
}
