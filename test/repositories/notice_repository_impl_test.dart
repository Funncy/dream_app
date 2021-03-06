// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dream/core/error/error_model.dart';
// import 'package:dream/models/comment.dart';
// import 'package:dream/models/notice.dart';
// import 'package:dream/models/reply.dart';
// import 'package:dream/repositories/notice_repository_impl.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';

// class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

// class MockCollectionReference extends Mock implements CollectionReference {}

// class MockDocumentReference extends Mock implements DocumentReference {}

// class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

// class MockQuerySnapshot extends Mock implements QuerySnapshot {}

// class MockQueryDocumentsnapshot extends Mock implements QueryDocumentSnapshot {}

// void main() {
//   NoticeRepositoryImpl noticeRepositoryImpl;
//   MockFirebaseFirestore mockFirebaseFirestore;
//   MockDocumentSnapshot mockDocumentSnapshot;
//   MockCollectionReference mockCollectionReference;
//   MockDocumentReference mockDocumentReference;
//   MockQueryDocumentsnapshot mockQueryDocumentsnapshot;
//   MockQuerySnapshot mockQuerySnapshot;

//   setUp(() {
//     mockCollectionReference = MockCollectionReference();
//     mockDocumentReference = MockDocumentReference();
//     mockDocumentSnapshot = MockDocumentSnapshot();
//     mockQuerySnapshot = MockQuerySnapshot();
//     mockQueryDocumentsnapshot = MockQueryDocumentsnapshot();
//     mockFirebaseFirestore = MockFirebaseFirestore();
//     noticeRepositoryImpl =
//         NoticeRepositoryImpl(firebaseFirestore: mockFirebaseFirestore);

//     when(mockFirebaseFirestore.collection(any))
//         .thenReturn(mockCollectionReference);
//     when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
//     when(mockCollectionReference.get())
//         .thenAnswer((_) async => mockQuerySnapshot);
//     when(mockQuerySnapshot.docs).thenAnswer(
//         (_) => [mockQueryDocumentsnapshot, mockQueryDocumentsnapshot]);

//     when(mockDocumentReference.get())
//         .thenAnswer((_) async => mockDocumentSnapshot);
//     when(mockQueryDocumentsnapshot.id).thenReturn('123');
//     when(mockDocumentSnapshot.id).thenReturn('123');

//     when(mockDocumentReference.collection(any))
//         .thenReturn(mockCollectionReference);
//   });

//   var noticeDataJson = {
//     'comment_count': 0,
//     'content': "???????????? 01",
//     'createdAt': Timestamp.now(),
//     'updatedAt': Timestamp.now(),
//     'favorite_user_list': ['245', '421'],
//     'user_id': '123'
//   };

//   var noticeDataModel = NoticeModel(
//       documentId: '123',
//       userId: '123',
//       content: "???????????? 01",
//       commentCount: 0,
//       favoriteUserList: ['245', '421'],
//       documentReference: null);

//   var commentDataJson = {
//     'user_id': '123',
//     'content': '?????? 01',
//     'reply_list': [
//       {
//         'content': '?????? 01',
//         'user_id': '123',
//         'favorite_user_list': [],
//         'createdAt': Timestamp.now(),
//         'updatedAt': Timestamp.now(),
//       },
//       {
//         'content': '?????? 02',
//         'user_id': '123',
//         'favorite_user_list': [],
//         'createdAt': Timestamp.now(),
//         'updatedAt': Timestamp.now(),
//       }
//     ],
//     'favorite_user_list': [],
//     'createdAt': Timestamp.now(),
//     'updatedAt': Timestamp.now(),
//   };

//   var commentDataModel = CommentModel(
//       documentId: '123',
//       userId: '123',
//       content: '?????? 01',
//       replyList: [
//         ReplyModel(userId: '123', content: '?????? 01', favoriteUserList: []),
//         ReplyModel(userId: '123', content: '?????? 02', favoriteUserList: []),
//       ],
//       favoriteUserList: [],
//       documentReference: null);

//   group('????????????', () {
//     test('???????????? ???????????? - ??????', () async {
//       //arrange
//       when(mockQueryDocumentsnapshot.data()).thenAnswer((_) => noticeDataJson);
//       //act
//       var result = await noticeRepositoryImpl.getNoticeList();
//       var data = result.getOrElse(() => null);
//       //assert
//       expect(result.isRight(), true);
//       expect(data.first, equals(noticeDataModel));
//     });

//     test('???????????? ???????????? - ??????', () async {
//       //arrange
//       when(mockCollectionReference.get())
//           .thenThrow(ErrorModel(message: 'firebase error'));
//       //act
//       var result = await noticeRepositoryImpl.getNoticeList();
//       //assert
//       expect(result.isLeft(), true);
//     });
//     test('???????????? ???????????? - Empty', () async {
//       //arrange
//       when(mockQuerySnapshot.docs).thenAnswer((_) => []);
//       //act
//       var result = await noticeRepositoryImpl.getNoticeList();
//       var data = result.getOrElse(() => null);
//       //assert
//       expect(result.isRight(), true);
//       expect(data.length, 0);
//     });

//     test('???????????? ?????????  - ??????', () async {
//       //arrange
//       //act
//       var result = await noticeRepositoryImpl.toggleNoticeFavorite(
//           noticeId: '123', userId: '123', isDelete: false);
//       //assert
//       expect(result.isRight(), true);
//     });

//     test('???????????? ????????? - ??????', () async {
//       //arrange
//       when(mockDocumentReference.update(any))
//           .thenThrow(ErrorModel(message: 'firebase error'));
//       var result = await noticeRepositoryImpl.toggleNoticeFavorite(
//           noticeId: '123', userId: '123', isDelete: false);
//       //assert
//       expect(result.isLeft(), true);
//     });
//   });

//   group('??????', () {
//     test('?????? ???????????? - ??????', () async {
//       //arrange
//       when(mockQueryDocumentsnapshot.data()).thenAnswer((_) => commentDataJson);
//       //act
//       var result = await noticeRepositoryImpl.getCommentList(noticeId: '123');
//       var data = result.getOrElse(() => null);
//       //assert
//       expect(result.isRight(), true);
//       expect(data, equals([commentDataModel, commentDataModel]));
//     });

//     test('?????? ???????????? - ??????', () async {
//       //arrange
//       when(mockCollectionReference.get())
//           .thenThrow(ErrorModel(message: 'firebase error'));
//       //act
//       var result = await noticeRepositoryImpl.getCommentList(noticeId: '123');
//       //assert
//       expect(result.isLeft(), true);
//     });

//     test('?????? ???????????? - Empty', () async {
//       //arrange
//       when(mockQuerySnapshot.docs).thenAnswer((_) => []);
//       //act
//       var result = await noticeRepositoryImpl.getNoticeList();
//       var data = result.getOrElse(() => null);
//       //assert
//       expect(result.isRight(), true);
//       expect(data.length, 0);
//     });

//     test('?????? ???????????? - ??????', () async {
//       //arrange
//       when(mockCollectionReference.add(any))
//           .thenAnswer((realInvocation) async => mockDocumentReference);
//       when(mockQueryDocumentsnapshot.data()).thenAnswer((_) => commentDataJson);
//       //act
//       var result = await noticeRepositoryImpl.writeComment(
//           noticeId: '123', userId: '123', content: '?????? 03');
//       //assert
//       expect(result.isRight(), true);
//     });

//     test('?????? ???????????? - ??????', () async {
//       //arrange
//       when(mockCollectionReference.add(any))
//           .thenThrow(ErrorModel(message: 'firebase error'));
//       //act
//       var result = await noticeRepositoryImpl.writeComment(
//           noticeId: '123', userId: '123', content: '?????? 03');
//       //assert
//       expect(result.isLeft(), true);
//     });

//     test('?????? ?????????  - ??????', () async {
//       //arrange
//       //act
//       var result = await noticeRepositoryImpl.toggleCommentFavorite(
//           noticeId: '123', commentId: '123', userId: '123', isDelete: false);
//       //assert
//       expect(result.isRight(), true);
//     });

//     test('?????? ????????? - ??????', () async {
//       //arrange
//       when(mockDocumentReference.update(any))
//           .thenThrow(ErrorModel(message: 'firebase error'));
//       //act
//       var result = await noticeRepositoryImpl.toggleCommentFavorite(
//           noticeId: '123', commentId: '123', userId: '123', isDelete: false);
//       //assert
//       expect(result.isLeft(), true);
//     });

//     test('?????? ???????????? - ??????', () async {
//       //arrange
//       when(mockCollectionReference.add(any))
//           .thenAnswer((realInvocation) async => mockDocumentReference);
//       when(mockQueryDocumentsnapshot.data()).thenAnswer((_) => commentDataJson);
//       //act
//       var result = await noticeRepositoryImpl.writeReply(
//           noticeId: '123',
//           commentId: '123',
//           userId: '123',
//           content: 'test reply 01');
//       //assert
//       expect(result.isRight(), true);
//     });

//     test('?????? ???????????? - ??????', () async {
//       //arrange
//       when(mockDocumentReference.update(any))
//           .thenThrow(ErrorModel(message: 'firebase error'));
//       //act
//       var result = await noticeRepositoryImpl.writeReply(
//           noticeId: '123',
//           commentId: '123',
//           userId: '123',
//           content: 'test reply 01');
//       //assert
//       expect(result.isLeft(), true);
//     });

//     test('?????? ?????? ???????????? - ??????', () async {
//       //arrange
//       when(mockDocumentSnapshot.data()).thenAnswer((_) => commentDataJson);
//       //act
//       var result = await noticeRepositoryImpl.getCommentById(
//           noticeId: '123', commentId: '123');
//       var data = result.getOrElse(() => null);
//       //assert
//       expect(result.isRight(), true);
//       expect(data, equals(commentDataModel));
//     });

//     test('?????? ?????? ???????????? - ??????', () async {
//       //arrange
//       when(mockCollectionReference.get())
//           .thenThrow(ErrorModel(message: 'firebase error'));
//       //act
//       var result = await noticeRepositoryImpl.getCommentById(
//           noticeId: '123', commentId: '123');
//       //assert
//       expect(result.isLeft(), true);
//     });
//   });
// }
