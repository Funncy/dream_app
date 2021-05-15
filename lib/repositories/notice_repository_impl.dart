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
  // FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  NoticeRepositoryImpl({@required FirebaseFirestore firebaseFirestore}) {
    _firebaseFirestore = firebaseFirestore;
  }

  @override
  Future<void> createDummyData() async {
    var noticeModelList = [
      NoticeModel(
          documentId: null,
          userId: '123',
          content: '공지사항 01',
          commentCount: 0,
          favoriteUserList: ['245', '356'],
          documentReference: null),
      NoticeModel(
          documentId: null,
          userId: '123',
          content: '공지사항 02',
          commentCount: 0,
          favoriteUserList: ['245', '356'],
          documentReference: null),
      NoticeModel(
          documentId: null,
          userId: '123',
          content: '공지사항 03',
          commentCount: 0,
          favoriteUserList: ['123'],
          documentReference: null),
    ];

    var commentList = [
      NoticeCommentModel(
          documentId: null,
          userId: '123',
          content: 'comment 01',
          replyList: [
            NoticeCommentReplyModel(
                userId: '123', content: 'reply 01', favoriteUserList: []),
            NoticeCommentReplyModel(
                userId: '123', content: 'reply 02', favoriteUserList: []),
          ],
          favoriteUserList: [],
          documentReference: null),
      NoticeCommentModel(
          documentId: null,
          userId: '123',
          content: 'comment 01',
          replyList: [
            NoticeCommentReplyModel(
                userId: '123', content: 'reply 01', favoriteUserList: []),
          ],
          favoriteUserList: [],
          documentReference: null),
    ];

    for (var notice in noticeModelList) {
      var documentReference = await _firebaseFirestore
          .collection(noticeCollectionName)
          .add(notice.toSaveJson());

      for (var comment in commentList) {
        documentReference
            .collection(commentCollectionName)
            .add(comment.toSaveJson());
      }
    }
  }

  @override
  Future<Either<ErrorModel, void>> addFavorite(
      {@required String collectionName,
      @required String documentId,
      @required String userId}) {
    // TODO: implement addFavorite
    throw UnimplementedError();
  }

  @override
  Future<Either<ErrorModel, List<NoticeCommentModel>>> getCommentList(
      {@required String noticeId}) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection(noticeCollectionName)
          .doc(noticeId)
          .collection(commentCollectionName)
          .get();
      List<NoticeCommentModel> result = querySnapshot.docs
          .map((e) => NoticeCommentModel.fromFirestore(e))
          .toList();
      return Right(result);
    } catch (e) {
      return Left(ErrorModel(message: 'firebase Error'));
    }
  }

  @override
  Future<Either<ErrorModel, NoticeCommentModel>> getCommentById(
      {@required String noticeId, @required String commentId}) async {
    try {
      DocumentSnapshot documentSnapshot = await _firebaseFirestore
          .collection(noticeCollectionName)
          .doc(noticeId)
          .collection(commentCollectionName)
          .doc(commentId)
          .get();
      return Right(NoticeCommentModel.fromFirestore(documentSnapshot));
    } catch (e) {
      return Left(ErrorModel(message: e.toString()));
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
  Future<Either<ErrorModel, List<NoticeCommentReplyModel>>> getReplyList(
      {@required String commentId}) {
    // TODO: implement getReplyList
    throw UnimplementedError();
  }

  @override
  Future<Either<ErrorModel, void>> writeComment(
      {@required String noticeId,
      @required String userId,
      @required String content}) async {
    try {
      var commentModel = NoticeCommentModel(
          documentId: null,
          userId: userId,
          content: content,
          replyList: [],
          favoriteUserList: [],
          documentReference: null);
      commentModel.createdAt = Timestamp.now().toDate();
      commentModel.updatedAt = Timestamp.now().toDate();

      _firebaseFirestore
          .collection(noticeCollectionName)
          .doc(noticeId)
          .collection(commentCollectionName)
          .add(commentModel.toSaveJson());

      //notice doc에서 commentCount 증가
      DocumentReference documentReference =
          _firebaseFirestore.collection(noticeCollectionName).doc(noticeId);
      await _firebaseFirestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (!snapshot.exists) {
          throw Exception("User does not exist!");
        }

        int newCommentCount = snapshot.data()['comment_count'] + 1;

        transaction
            .update(documentReference, {'comment_count': newCommentCount});

        return newCommentCount;
      });
      return Right(null);
    } catch (e) {
      return Left(ErrorModel(message: 'firebase error'));
    }
  }

  @override
  Future<Either<ErrorModel, void>> writeReply(
      {@required String noticeId,
      @required String commentId,
      @required String userId,
      @required String content}) async {
    try {
      //TODO: Notice Reference 혹은 comment Reference 필요
      var replyModel = NoticeCommentReplyModel(
          userId: userId, content: content, favoriteUserList: []);
      await _firebaseFirestore
          .collection(noticeCollectionName)
          .doc(noticeId)
          .collection(commentCollectionName)
          .doc(commentId)
          .update({
        'reply_list': FieldValue.arrayUnion([replyModel.toJson()])
      });
      return Right(null);
    } catch (e) {
      return Left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> addCommentFavorite(
      {@required String commentId, @required String userId}) {
    // TODO: implement addCommentFavorite
    throw UnimplementedError();
  }

  @override
  Future<Either<ErrorModel, void>> addNoticeFavorite(
      {@required String noticeId, @required String userId}) async {
    try {
      _firebaseFirestore.collection(noticeCollectionName).doc(noticeId).update({
        'favorite_user_list': FieldValue.arrayUnion([userId])
      });
      return Right(null);
    } catch (e) {
      return Left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> addReplyFavorite(
      {@required String commentId, @required String userId}) {
    // TODO: implement addReplyFavorite
    throw UnimplementedError();
  }

  // @override
  // Future<Either<ErrorModel, List<NoticeModel>>> getNoticeList() async {
  //   List<NoticeModel> noticeList = [];

  //   try {
  //     //1. 기존 방식
  //     var noticeCollection =
  //         await _firebaseFirestore.collection('notice').get();
  //     for (var notice in noticeCollection.docs) {
  //       noticeList.add(NoticeModel.fromFirestore(notice));
  //       //공지별 이미지 리스트 가져오기
  //       ListResult images =
  //           await _firebaseStorage.ref('/notice/${notice.id}').listAll();

  //       for (Reference item in images.items) {
  //         String url = await item.getDownloadURL();
  //         noticeList.last.imageList.add(url);
  //       }

  //       //공지별 좋아요 리스트 가져오기
  //       //좋아요 숫자가 0이면 접근 하지 않음
  //       if (noticeList.last.favoriteCount > 0) {
  //         var favoriteList = await getFavoriteList(
  //             collectionName: noticeCollectionName, documentId: notice.id);
  //         if (favoriteList.isLeft()) {
  //           return Left(ErrorModel(message: 'get Notice favorite error'));
  //         }
  //         noticeList.last.favoriteList = favoriteList.getOrElse(() => null);
  //       }
  //     }
  //   } catch (e) {
  //     return Left(ErrorModel(message: '파이어베이스 에러'));
  //   }
  //   return Right(noticeList);
  // }

  // @override
  // Future<Either<ErrorModel, List<NoticeCommentModel>>> getCommentList(
  //     {@required String noticeId}) async {
  //   List<NoticeCommentModel> commentList = [];

  //   try {
  //     //댓글 가져오기
  //     QuerySnapshot querySnapshot = await _firebaseFirestore
  //         .collection(commentCollectionName)
  //         .where(noticeColumnName, isEqualTo: noticeId)
  //         .orderBy('updatedAt')
  //         .get();
  //     commentList.addAll(querySnapshot.docs
  //         .map((e) => NoticeCommentModel.fromFirestore(e))
  //         .toList());

  //     for (var comment in commentList) {
  //       var result = await getReplyList(commentId: comment.docuemtnId);
  //       result.fold((l) {
  //         throw ErrorModel(message: '파이어베이스 에러');
  //       }, (r) {
  //         comment.replyList = r;
  //       });
  //     }
  //   } catch (e) {
  //     return Left(ErrorModel(message: '파이어베이스 에러'));
  //   }
  //   return Right(commentList);
  // }

  // Future<Either<ErrorModel, List<FavoriteModel>>> getFavoriteList(
  //     {@required String collectionName, @required String documentId}) async {
  //   try {
  //     QuerySnapshot querySnapshot = await _firebaseFirestore
  //         .collection(collectionName)
  //         .doc(documentId)
  //         .collection(favoriteCollectionName)
  //         .orderBy('user_id')
  //         .get();
  //     return Right(querySnapshot.docs
  //         .map((e) => FavoriteModel.fromFirestroe(e))
  //         .toList());
  //   } catch (e) {
  //     return Left(ErrorModel(message: 'Firebase Error'));
  //   }
  // }

  // @override
  // Future<Either<ErrorModel, List<NoticeCommentReplyModel>>> getReplyList(
  //     {@required String commentId}) async {
  //   try {
  //     QuerySnapshot querySnapshot = await _firebaseFirestore
  //         .collection(commentCollectionName)
  //         .doc(commentId)
  //         .collection(replyCollectionName)
  //         .orderBy('updatedAt')
  //         .get();

  //     return Right(querySnapshot.docs
  //         .map((e) => NoticeCommentReplyModel.fromFirestore(e))
  //         .toList());
  //   } catch (e) {
  //     return Left(ErrorModel(message: '파이어베이스 에러'));
  //   }
  // }

  // @override
  // Future<void> setNoticeImageList(
  //     {@required NoticeModel model, @required Function getImageList}) async {
  //   var imageList = await _firebaseStorage
  //       .ref('$noticeImagePath/${model.documentId}')
  //       .listAll();
  //   List<String> imageUrlList = [];
  //   for (var item in imageList.items)
  //     imageUrlList.add(await item.getDownloadURL());

  //   model.imageList.clear();
  //   model.imageList.addAll(imageUrlList);
  // }

  // //댓글 쓰기 함수
  // //nid는 notice doucment id로 해당 document값을 저장하기 위함
  // @override
  // Future<Either<ErrorModel, void>> writeComment(
  //     {@required String noticeId,
  //     @required String userId,
  //     @required String content}) async {
  //   NoticeCommentModel model = NoticeCommentModel(
  //       docuemtnId: null,
  //       noticeId: noticeId,
  //       userId: userId,
  //       content: content,
  //       replyCount: 0,
  //       favoriteCount: 0,
  //       documentReference: null);
  //   model.createdAt = DateTime.now();
  //   model.updatedAt = model.createdAt;
  //   try {
  //     await _firebaseFirestore
  //         .collection(commentCollectionName)
  //         .add(model.toSaveJson());

  //     var noticeSnapshot = await _firebaseFirestore
  //         .collection(noticeCollectionName)
  //         .doc(noticeId)
  //         .get();

  //     await _firebaseFirestore
  //         .collection(noticeCollectionName)
  //         .doc(noticeId)
  //         .update({
  //       'comment_count': (noticeSnapshot.data()['comment_count'] ?? 0) + 1
  //     });

  //     return Right(null);
  //   } catch (e) {
  //     return Left(ErrorModel(message: '파이어베이스 에러'));
  //   }
  // }

  // //답글 쓰기 함수
  // //did는 notice_comment doucment id로 해당 inner Collection으로 들어가기 위함
  // @override
  // Future<Either<ErrorModel, void>> writeReply(
  //     {@required String commentId,
  //     @required String userId,
  //     @required String content}) async {
  //   NoticeCommentReplyModel model = NoticeCommentReplyModel(
  //       documentId: null,
  //       userId: userId,
  //       content: content,
  //       favoriteCount: 0,
  //       documentReference: null);
  //   model.createdAt = DateTime.now();
  //   model.updatedAt = model.createdAt;
  //   try {
  //     await _firebaseFirestore
  //         .collection(commentCollectionName)
  //         .doc(commentId)
  //         .collection(replyCollectionName)
  //         .add(model.toSaveJson());

  //     //답글 갯수 증가 시키기 위한 로직
  //     var commentSnapshot = await _firebaseFirestore
  //         .collection(commentCollectionName)
  //         .doc(commentId)
  //         .get();

  //     await _firebaseFirestore
  //         .collection(commentCollectionName)
  //         .doc(commentId)
  //         .update({
  //       'reply_count': (commentSnapshot.data()['reply_count'] ?? 0) + 1
  //     });

  //     return Right(null);
  //   } catch (e) {
  //     return Left(ErrorModel(message: '파이어베이스 에러'));
  //   }
  // }

  // @override
  // Future<Either<ErrorModel, void>> addFavorite(
  //     {@required String collectionName,
  //     @required String documentId,
  //     @required String userId}) async {
  //   FavoriteModel favoriteModel =
  //       FavoriteModel(documentId: documentId, userId: userId);

  //   try {
  //     await _firebaseFirestore
  //         .collection(collectionName)
  //         .doc(documentId)
  //         .collection(favoriteCollectionName)
  //         .add(favoriteModel.toSaveJson());
  //   } catch (e) {
  //     return Left(ErrorModel(message: 'Firebase Error'));
  //   }
  //   return Right(null);
  // }
}
