import 'dart:async';

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
  StreamSubscription<Status> noticeStatusSubscription;
  StreamSubscription<Status> commentStatusSubscription;
  StreamSubscription<Status> replyStatusSubscription;

  setUp(() {
    mockNoticeRepository = MockNoticeRepository();
    noticeViewModel = NoticeViewModel(noticeRepository: mockNoticeRepository);

    statusList.clear();
    noticeStatusSubscription = noticeViewModel.commentStatus.listen((status) {
      statusList.add(status);
    });
    commentStatusSubscription = noticeViewModel.noticeStatus.listen((status) {
      statusList.add(status);
    });
    replyStatusSubscription = noticeViewModel.replyStatus.listen((status) {
      statusList.add(status);
    });
  });

  tearDown(() {
    noticeStatusSubscription.cancel();
    commentStatusSubscription.cancel();
    replyStatusSubscription.cancel();
  });

  //test 데이터
  final noticeList = [
    NoticeModel(
        documentId: '123',
        userId: '123',
        content: 'test1',
        commentCount: 0,
        favoriteUserList: ['123', '245'],
        documentReference: null),
    NoticeModel(
        documentId: '123',
        userId: '123',
        content: 'test2',
        commentCount: 0,
        favoriteUserList: ['123', '245'],
        documentReference: null),
    NoticeModel(
        documentId: '123',
        userId: '123',
        content: 'test3',
        commentCount: 0,
        favoriteUserList: ['123', '245'],
        documentReference: null),
  ];

  final commentList = [
    NoticeCommentModel(
        documentId: '121',
        userId: 'test1',
        content: 'test 001',
        replyList: [
          NoticeCommentReplyModel(
              userId: '123', content: 'test reply 01', favoriteUserList: []),
          NoticeCommentReplyModel(
              userId: '123', content: 'test reply 01', favoriteUserList: []),
        ],
        favoriteUserList: ['123', '245'],
        documentReference: null),
    NoticeCommentModel(
        documentId: '122',
        userId: 'test12',
        content: 'test 002',
        replyList: [
          NoticeCommentReplyModel(
              userId: '123', content: 'test reply 01', favoriteUserList: []),
          NoticeCommentReplyModel(
              userId: '123', content: 'test reply 01', favoriteUserList: []),
        ],
        favoriteUserList: ['123', '245'],
        documentReference: null),
    NoticeCommentModel(
        documentId: '123',
        userId: 'test1',
        content: 'test 003',
        replyList: [
          NoticeCommentReplyModel(
              userId: '123', content: 'test reply 01', favoriteUserList: []),
          NoticeCommentReplyModel(
              userId: '123', content: 'test reply 01', favoriteUserList: []),
        ],
        favoriteUserList: ['123', '245'],
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
      when(mockNoticeRepository.getCommentList(noticeId: '123'))
          .thenAnswer((_) async => Right(commentList));

      //act
      await noticeViewModel.getCommentList(noticeId: '123');
      //assert

      expect(noticeViewModel.commentList, commentList);
      expect(statusList, [Status.loading, Status.loaded]);
      verify(mockNoticeRepository.getCommentList(noticeId: '123')).called(1);
    });

    test('댓글 가져오기 - 에러', () async {
      //arrange
      when(mockNoticeRepository.getCommentList(noticeId: '123'))
          .thenAnswer((_) async => Left(ErrorModel(message: 'Firebase Error')));
      //act
      await noticeViewModel.getCommentList(noticeId: '123');
      //assert
      expect(noticeViewModel.commentList.length, 0);
      expect(statusList, [Status.loading, Status.error]);
      verify(mockNoticeRepository.getCommentList(noticeId: '123')).called(1);
    });
    test('댓글 가져오기 - Empty', () async {
      //arrange
      when(mockNoticeRepository.getCommentList(noticeId: '123'))
          .thenAnswer((_) async => Right([]));
      //act
      await noticeViewModel.getCommentList(noticeId: '123');
      //assert
      expect(noticeViewModel.commentList.length, 0);
      expect(statusList, [Status.loading, Status.empty]);
      verify(mockNoticeRepository.getCommentList(noticeId: '123')).called(1);
    });

    // test('댓글 작성하기 - 성공', () async {
    //   //arrange
    //   when(mockNoticeRepository.writeComment(
    //           noticeId: '123', userId: 'test123', content: 'test 001'))
    //       .thenAnswer((realInvocation) async => Right(null));
    //   when(mockNoticeRepository.getCommentList(noticeId: '123'))
    //       .thenAnswer((_) async => Right(commentList));
    //   //act
    //   await noticeViewModel.writeComment(
    //       noticeId: '123', userId: 'test123', content: 'test 001');
    //   //assert
    //   expect(noticeViewModel.commentList, commentList);
    //   expect(noticeViewModel.commentList[1].replyCount,
    //       noticeViewModel.commentList[1].replyList.length);
    //   expect(statusList, [Status.updating, Status.loaded]);
    //   verify(mockNoticeRepository.getCommentList(noticeId: '123')).called(1);
    // });

    // test('댓글 작성하기 - 쓰기 실패', () async {
    //   //arrange
    //   when(mockNoticeRepository.writeComment(
    //           noticeId: '123', userId: 'test123', content: 'test 001'))
    //       .thenAnswer((realInvocation) async =>
    //           Left(ErrorModel(message: 'Firebase Error')));
    //   //act
    //   await noticeViewModel.writeComment(
    //       noticeId: '123', userId: 'test123', content: 'test 001');
    //   //assert
    //   expect(statusList, [Status.updating, Status.error]);
    //   verify(mockNoticeRepository.writeComment(
    //           noticeId: '123', userId: 'test123', content: 'test 001'))
    //       .called(1);
    // });

    // test('댓글 작성하기 - 읽기 실패', () async {
    //   //arrange
    //   when(mockNoticeRepository.writeComment(
    //           noticeId: '123', userId: 'test123', content: 'test 001'))
    //       .thenAnswer((realInvocation) async => Right(null));
    //   when(mockNoticeRepository.getCommentList(noticeId: '123'))
    //       .thenAnswer((_) async => Left(ErrorModel(message: 'Firebase Error')));
    //   //act
    //   await noticeViewModel.writeComment(
    //       noticeId: '123', userId: 'test123', content: 'test 001');
    //   //assert
    //   expect(statusList, [Status.updating, Status.error]);
    //   verify(mockNoticeRepository.writeComment(
    //           noticeId: '123', userId: 'test123', content: 'test 001'))
    //       .called(1);
    // });
  });

  // group('좋아요', () {
  //   test('댓글 좋아요 - 성공', () async {});
  // });
}
