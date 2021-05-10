import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/repositories/notice_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

class MockQueryDocumentsnapshot extends Mock implements QueryDocumentSnapshot {}

void main() {
  NoticeRepositoryImpl noticeRepositoryImpl;
  MockFirebaseFirestore mockFirebaseFirestore;
  MockDocumentSnapshot mockDocumentSnapshot;
  MockCollectionReference mockCollectionReference;
  MockDocumentReference mockDocumentReference;
  MockQueryDocumentsnapshot mockQueryDocumentsnapshot;
  MockQuerySnapshot mockQuerySnapshot;

  setUp(() {
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    mockDocumentSnapshot = MockDocumentSnapshot();
    mockQuerySnapshot = MockQuerySnapshot();
    mockQueryDocumentsnapshot = MockQueryDocumentsnapshot();
    mockFirebaseFirestore = MockFirebaseFirestore();
    noticeRepositoryImpl =
        NoticeRepositoryImpl(firebaseFirestore: mockFirebaseFirestore);

    when(mockFirebaseFirestore.collection(any))
        .thenReturn(mockCollectionReference);
    when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
    when(mockCollectionReference.get())
        .thenAnswer((_) async => mockQuerySnapshot);
    when(mockQuerySnapshot.docs).thenAnswer(
        (_) => [mockQueryDocumentsnapshot, mockQueryDocumentsnapshot]);

    when(mockDocumentReference.get())
        .thenAnswer((_) async => mockDocumentSnapshot);
    when(mockQueryDocumentsnapshot.id).thenReturn('123');
  });

  var noticeDataJson = {
    'comment_count': 0,
    'content': "공지사항 01",
    'createdAt': Timestamp.now(),
    'updatedAt': Timestamp.now(),
    'favorite_user_list': ['245', '421'],
    'user_id': '123'
  };

  var noticeDataModel = NoticeModel(
      documentId: '123',
      userId: '123',
      content: "공지사항 01",
      commentCount: 0,
      favoriteUserList: ['245', '421'],
      documentReference: null);
  group('공지사항', () {
    test('공지사항 가져오기 - 성공', () async {
      //arrange
      when(mockQueryDocumentsnapshot.data()).thenAnswer((_) => noticeDataJson);
      //act
      var result = await noticeRepositoryImpl.getNoticeList();
      var data = result.getOrElse(() => null);
      //assert
      expect(result.isRight(), true);
      expect(data.first, equals(noticeDataModel));
    });

    test('공지사항 가져오기 - 에러', () async {
      //arrange
      //act
      //assert
    });
    test('공지사항 가져오기 - Empty', () async {
      //arrange
      //act
      //assert
    });
  });
}
