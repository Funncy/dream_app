import 'package:dartz/dartz.dart';
import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/repositories/notice_repository_impl.dart';
import 'package:dream/viewmodels/notice_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNoticeRepository extends Mock implements NoticeRepositoryImpl {}

void main() {
  NoticeViewModel noticeViewModel;
  MockNoticeRepository mockNoticeRepository;
  //Stream Test
  List<Status> statusList = [];

  setUp(() {
    mockNoticeRepository = MockNoticeRepository();
    noticeViewModel = NoticeViewModel(noticeRepository: mockNoticeRepository);

    statusList.clear();
    noticeViewModel.commentStatus.listen((status) {
      statusList.add(status);
    });
    noticeViewModel.noticeStatus.listen((status) {
      statusList.add(status);
    });
    noticeViewModel.replyStatus.listen((status) {
      statusList.add(status);
    });
  });

  //test 데이터
  final noticeList = [
    NoticeModel(
        did: '123',
        uid: '123',
        content: 'test1',
        commentCount: 0,
        favoriteCount: 0,
        documentReference: null),
    NoticeModel(
        did: '123',
        uid: '123',
        content: 'test2',
        commentCount: 0,
        favoriteCount: 0,
        documentReference: null),
    NoticeModel(
        did: '123',
        uid: '123',
        content: 'test3',
        commentCount: 0,
        favoriteCount: 0,
        documentReference: null),
  ];

  final commentList = [
    NoticeCommentModel(
        did: '123',
        nid: '123',
        uid: 'test1',
        content: 'test 001',
        replyCount: 0,
        favoriteCount: 0,
        documentReference: null),
    NoticeCommentModel(
        did: '123',
        nid: '123',
        uid: 'test12',
        content: 'test 002',
        replyCount: 1,
        favoriteCount: 1,
        documentReference: null),
    NoticeCommentModel(
        did: '123',
        nid: '123',
        uid: 'test1',
        content: 'test 003',
        replyCount: 3,
        favoriteCount: 2,
        documentReference: null),
  ];
  commentList[1].replyList = [
    NoticeCommentReplyModel(
        did: '123',
        uid: 'test21',
        content: 'reply001',
        favoriteCount: 0,
        documentReference: null),
  ];

  commentList[2].replyList = [
    NoticeCommentReplyModel(
        did: '123',
        uid: 'test21',
        content: 'reply001',
        favoriteCount: 0,
        documentReference: null),
    NoticeCommentReplyModel(
        did: '123',
        uid: 'test21',
        content: 'reply002',
        favoriteCount: 0,
        documentReference: null),
    NoticeCommentReplyModel(
        did: '123',
        uid: 'test21',
        content: 'reply003',
        favoriteCount: 0,
        documentReference: null),
  ];

  group('공지사항', () {
    test('공지사항 가져오기 - 성공', () async {
      //arrange
      when(mockNoticeRepository.getNoticeList())
          .thenAnswer((_) async => Right(noticeList));
      //act
      await noticeViewModel.getNoticeList();
      //assert
      expect(noticeViewModel.noticeList, noticeList);
      expect(statusList, [Status.loading, Status.loaded]);
      verify(mockNoticeRepository.getNoticeList()).called(1);
    });

    test('공지사항 가져오기 - 에러', () async {
      //arrange
      when(mockNoticeRepository.getNoticeList())
          .thenAnswer((_) async => Left(ErrorModel(message: 'Firebase Error')));
      //act
      await noticeViewModel.getNoticeList();
      //assert
      expect(noticeViewModel.noticeList.length, 0);
      expect(statusList, [Status.loading, Status.error]);
      verify(mockNoticeRepository.getNoticeList()).called(1);
    });
    test('공지사항 가져오기 - Empty', () async {
      //arrange
      when(mockNoticeRepository.getNoticeList())
          .thenAnswer((_) async => Right([]));
      //act
      await noticeViewModel.getNoticeList();
      //assert
      expect(noticeViewModel.noticeList.length, 0);
      expect(statusList, [Status.loading, Status.empty]);
      verify(mockNoticeRepository.getNoticeList()).called(1);
    });
  });

  group('댓글', () {
    test('댓글 가져오기 - 성공', () async {
      //arrange
      when(mockNoticeRepository.getCommentList('123'))
          .thenAnswer((_) async => Right(commentList));

      //act
      await noticeViewModel.getCommentList(nid: '123');
      //assert

      expect(noticeViewModel.commentList, commentList);
      expect(noticeViewModel.commentList[1].replyCount,
          noticeViewModel.commentList[1].replyList.length);
      expect(statusList, [Status.loading, Status.loaded]);
      verify(mockNoticeRepository.getCommentList('123')).called(1);
    });

    test('댓글 가져오기 - 에러', () async {
      //arrange
      when(mockNoticeRepository.getCommentList('123'))
          .thenAnswer((_) async => Left(ErrorModel(message: 'Firebase Error')));
      //act
      await noticeViewModel.getCommentList(nid: '123');
      //assert
      expect(noticeViewModel.commentList.length, 0);
      expect(statusList, [Status.loading, Status.error]);
      verify(mockNoticeRepository.getCommentList('123')).called(1);
    });
    test('댓글 가져오기 - Empty', () async {
      //arrange
      when(mockNoticeRepository.getCommentList('123'))
          .thenAnswer((_) async => Right([]));
      //act
      await noticeViewModel.getCommentList(nid: '123');
      //assert
      expect(noticeViewModel.commentList.length, 0);
      expect(statusList, [Status.loading, Status.empty]);
      verify(mockNoticeRepository.getCommentList('123')).called(1);
    });

    test('댓글 작성하기 - 성공', () async {
      //arrange
      when(mockNoticeRepository.writeComment(
              nid: '123', uid: 'test123', content: 'test 001'))
          .thenAnswer((realInvocation) async => Right(null));
      when(mockNoticeRepository.getCommentList('123'))
          .thenAnswer((_) async => Right(commentList));
      //act
      await noticeViewModel.writeComment(
          nid: '123', uid: 'test123', content: 'test 001');
      //assert
      expect(noticeViewModel.commentList, commentList);
      expect(noticeViewModel.commentList[1].replyCount,
          noticeViewModel.commentList[1].replyList.length);
      expect(statusList, [Status.updating, Status.loaded]);
      verify(mockNoticeRepository.getCommentList('123')).called(1);
    });
  });
}
