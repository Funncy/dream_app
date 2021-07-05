import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/failure.dart';
import 'package:dream/app/core/state/view_state.dart';
import 'package:dream/app/data/models/notice.dart';
import 'package:dream/app/repositories/notice_repository_impl.dart';
import 'package:dream/app/viewmodels/notice_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNoticeRepository extends Mock implements NoticeRepositoryImpl {}

void main() {
  late NoticeViewModel noticeViewModel;
  late MockNoticeRepository mockNoticeRepository;
  //Stream Test
  List<ViewState?> StateList = [];
  late StreamSubscription<ViewState?> noticeStateSubscription;
  setUp(() {
    mockNoticeRepository = MockNoticeRepository();
    noticeViewModel = NoticeViewModel(noticeRepository: mockNoticeRepository);

    StateList.clear();
    noticeStateSubscription = noticeViewModel.noticeStateStream.listen((state) {
      StateList.add(state);
    });

    noticeViewModel.noticeList.add(NoticeModel(
        id: '123',
        userId: '111',
        content: 'test notice',
        commentCount: 0,
        favoriteUserList: [],
        documentReference: null));
    noticeViewModel.noticeList.add(NoticeModel(
        id: '245',
        userId: '232',
        content: 'test notice 22',
        commentCount: 2,
        favoriteUserList: ['123', '121'],
        documentReference: null));
  });

  tearDown(() {
    noticeStateSubscription.cancel();
  });

  //test 데이터
  final noticeList = [
    NoticeModel(
        id: '123',
        userId: '111',
        content: 'test notice',
        commentCount: 0,
        favoriteUserList: [],
        documentReference: null),
    NoticeModel(
        id: '245',
        userId: '232',
        content: 'test notice 22',
        commentCount: 2,
        favoriteUserList: ['123', '121'],
        documentReference: null),
  ];

  group('공지사항', () {
    test('공지사항 가져오기 - 성공', () async {
      //arrange
      when<Future<Either<Failure, List<NoticeModel>>>>(
              mockNoticeRepository.getNoticeList())
          .thenAnswer((_) async => Right(noticeList));
      //act
      await noticeViewModel.getNoticeList();
      //assert
      expect(noticeViewModel.noticeList, noticeList);
      expect(noticeViewModel.noticeState, isInstanceOf<Loaded>());
      // expect(StateList, [Loading(), Loaded()]);
      verify(mockNoticeRepository.getNoticeList()).called(1);
    });

    // test('공지사항 가져오기 - 에러', () async {
    //   //arrange
    //   noticeViewModel.noticeList.clear();
    //   when(mockNoticeRepository.getNoticeList())
    //       .thenAnswer((_) async => Left(ErrorModel(message: 'Firebase Error')));
    //   //act
    //   await noticeViewModel.getNoticeList();
    //   //assert
    //   expect(noticeViewModel.noticeList.length, 0);
    //   expect(StateList, [State.loading, State.error]);
    //   verify(mockNoticeRepository.getNoticeList()).called(1);
    // });
    // test('공지사항 가져오기 - Empty', () async {
    //   //arrange
    //   when(mockNoticeRepository.getNoticeList())
    //       .thenAnswer((_) async => Right([]));
    //   //act
    //   await noticeViewModel.getNoticeList();
    //   //assert
    //   expect(noticeViewModel.noticeList.length, 0);
    //   expect(StateList, [State.loading, State.empty]);
    //   verify(mockNoticeRepository.getNoticeList()).called(1);
    // });

    // test('공지사항 댓글 좋아요 - 성공', () async {
    //   //arrange
    //   when(mockNoticeRepository.toggleNoticeFavorite(
    //           noticeId: '123', userId: '123', isDelete: false))
    //       .thenAnswer((_) async => Right(null));
    //   when(mockNoticeRepository.toggleNoticeFavorite(
    //           noticeId: '123', userId: '123', isDelete: true))
    //       .thenAnswer((_) async => Right(null));
    //   //act
    //   await noticeViewModel.toggleNoticeFavorite(
    //       noticeId: '123', userId: '123');
    //   //assert
    //   expect(
    //       noticeViewModel.noticeList.first.favoriteUserList, equals(['123']));
    // });
    // test('공지사항 댓글 좋아요 - 실패', () async {
    //   //arrange
    //   when(mockNoticeRepository.toggleNoticeFavorite(
    //           noticeId: '123', userId: '123', isDelete: false))
    //       .thenAnswer((_) async => Left(ErrorModel(message: 'firebase error')));
    //   when(mockNoticeRepository.toggleNoticeFavorite(
    //           noticeId: '123', userId: '123', isDelete: true))
    //       .thenAnswer((_) async => Left(ErrorModel(message: 'firebase error')));
    //   //act
    //   await noticeViewModel.toggleNoticeFavorite(
    //       noticeId: '123', userId: '123');
    //   //assert
    //   expect(noticeViewModel.noticeList.first.favoriteUserList, equals([]));
    // });
  });

  // group('댓글', () {
  //   test('댓글 좋아요 - 성공', () async {
  //     //arrange
  //     when(mockNoticeRepository.toggleCommentFavorite(
  //             noticeId: '123',
  //             commentId: '123',
  //             userId: '123',
  //             isDelete: false))
  //         .thenAnswer((_) async => Right(null));
  //     when(mockNoticeRepository.toggleCommentFavorite(
  //             noticeId: '123', commentId: '123', userId: '123', isDelete: true))
  //         .thenAnswer((_) async => Right(null));
  //     //act
  //     await noticeViewModel.toggleCommentFavorite(
  //         noticeId: '123', commentId: '123', userId: '123');
  //     //assert
  //     expect(
  //         noticeViewModel.commentList.first.favoriteUserList, equals(['123']));
  //   });
  //   test('댓글 좋아요 - 실패', () async {
  //     //arrange
  //     when(mockNoticeRepository.toggleCommentFavorite(
  //             noticeId: '123',
  //             commentId: '123',
  //             userId: '123',
  //             isDelete: false))
  //         .thenAnswer((_) async => Left(ErrorModel(message: 'firebase error')));
  //     when(mockNoticeRepository.toggleCommentFavorite(
  //             noticeId: '123', commentId: '123', userId: '123', isDelete: true))
  //         .thenAnswer((_) async => Left(ErrorModel(message: 'firebase error')));
  //     //act
  //     await noticeViewModel.toggleCommentFavorite(
  //         noticeId: '123', commentId: '123', userId: '123');
  //     //assert
  //     expect(noticeViewModel.commentList.first.favoriteUserList, equals([]));
  //   });
  //   test('댓글 가져오기 - 성공', () async {
  //     //arrange
  //     when(mockNoticeRepository.getCommentList(noticeId: '123'))
  //         .thenAnswer((_) async => Right(commentList));

  //     //act
  //     await noticeViewModel.getCommentList(noticeId: '123');
  //     //assert

  //     expect(noticeViewModel.commentList, commentList);
  //     expect(StateList, [State.loading, State.loaded]);
  //     verify(mockNoticeRepository.getCommentList(noticeId: '123')).called(1);
  //   });

  //   test('댓글 가져오기 - 에러', () async {
  //     //arrange
  //     noticeViewModel.commentList.clear();
  //     when(mockNoticeRepository.getCommentList(noticeId: '123'))
  //         .thenAnswer((_) async => Left(ErrorModel(message: 'Firebase Error')));
  //     //act
  //     await noticeViewModel.getCommentList(noticeId: '123');
  //     //assert
  //     expect(noticeViewModel.commentList.length, 0);
  //     expect(StateList, [State.loading, State.error]);
  //     verify(mockNoticeRepository.getCommentList(noticeId: '123')).called(1);
  //   });
  //   test('댓글 가져오기 - Empty', () async {
  //     //arrange
  //     noticeViewModel.commentList.clear();
  //     when(mockNoticeRepository.getCommentList(noticeId: '123'))
  //         .thenAnswer((_) async => Right([]));
  //     //act
  //     await noticeViewModel.getCommentList(noticeId: '123');
  //     //assert
  //     expect(noticeViewModel.commentList.length, 0);
  //     expect(StateList, [State.loading, State.empty]);
  //     verify(mockNoticeRepository.getCommentList(noticeId: '123')).called(1);
  //   });

  //   test('댓글 작성하기 - 성공', () async {
  //     //arrange
  //     when(mockNoticeRepository.writeComment(
  //             noticeId: '123', userId: 'test123', content: 'test 001'))
  //         .thenAnswer((realInvocation) async => Right(null));
  //     when(mockNoticeRepository.getCommentList(noticeId: '123'))
  //         .thenAnswer((_) async => Right(commentList));
  //     //act
  //     await noticeViewModel.writeComment(
  //         noticeId: '123', userId: 'test123', content: 'test 001');
  //     //assert
  //     expect(noticeViewModel.commentList, commentList);
  //     expect(StateList, [State.updating, State.loaded]);
  //     verify(mockNoticeRepository.getCommentList(noticeId: '123')).called(1);
  //   });

  //   test('댓글 작성하기 - 쓰기 실패', () async {
  //     //arrange
  //     when(mockNoticeRepository.writeComment(
  //             noticeId: '123', userId: 'test123', content: 'test 001'))
  //         .thenAnswer((realInvocation) async =>
  //             Left(ErrorModel(message: 'Firebase Error')));
  //     //act
  //     await noticeViewModel.writeComment(
  //         noticeId: '123', userId: 'test123', content: 'test 001');
  //     //assert
  //     expect(StateList, [State.updating, State.error]);
  //     verify(mockNoticeRepository.writeComment(
  //             noticeId: '123', userId: 'test123', content: 'test 001'))
  //         .called(1);
  //   });

  //   test('댓글 작성하기 - 읽기 실패', () async {
  //     //arrange
  //     when(mockNoticeRepository.writeComment(
  //             noticeId: '123', userId: 'test123', content: 'test 001'))
  //         .thenAnswer((realInvocation) async => Right(null));
  //     when(mockNoticeRepository.getCommentList(noticeId: '123'))
  //         .thenAnswer((_) async => Left(ErrorModel(message: 'Firebase Error')));
  //     //act
  //     await noticeViewModel.writeComment(
  //         noticeId: '123', userId: 'test123', content: 'test 001');
  //     //assert
  //     expect(StateList, [State.updating, State.error]);
  //     verify(mockNoticeRepository.writeComment(
  //             noticeId: '123', userId: 'test123', content: 'test 001'))
  //         .called(1);
  //   });

  //   test('답글 작성하기 - 성공', () async {
  //     //arrange
  //     noticeViewModel.commentList.clear();
  //     noticeViewModel.commentList.add(commentModel);
  //     when(mockNoticeRepository.writeReply(
  //             noticeId: '123',
  //             commentId: '121',
  //             userId: '123',
  //             content: 'reply 01'))
  //         .thenAnswer((_) async => Right(null));
  //     when(mockNoticeRepository.getCommentById(
  //             noticeId: '123', commentId: '121'))
  //         .thenAnswer((_) async => Right(dummyCommentModel));
  //     //act
  //     await noticeViewModel.writeReply(
  //         noticeId: '123',
  //         commentId: '121',
  //         userId: '123',
  //         content: 'reply 01');
  //     //assert
  //     expect(noticeViewModel.commentList, equals([dummyCommentModel]));
  //     expect(StateList, [State.updating, State.loaded]);
  //     verify(mockNoticeRepository.getCommentById(
  //             noticeId: '123', commentId: '121'))
  //         .called(1);
  //     verify(mockNoticeRepository.writeReply(
  //             noticeId: '123',
  //             commentId: '121',
  //             userId: '123',
  //             content: 'reply 01'))
  //         .called(1);
  //   });

  //   test('답글 작성하기 - 작성 실패', () async {
  //     //arrange
  //     when(mockNoticeRepository.writeReply(
  //             noticeId: '123',
  //             commentId: '123',
  //             userId: '123',
  //             content: 'reply 01'))
  //         .thenAnswer((_) async => Left(ErrorModel(message: 'firebase error')));
  //     //act
  //     await noticeViewModel.writeReply(
  //         noticeId: '123',
  //         commentId: '123',
  //         userId: '123',
  //         content: 'reply 01');
  //     //assert
  //     expect(StateList, [State.updating, State.error]);
  //     verify(mockNoticeRepository.writeReply(
  //             noticeId: '123',
  //             commentId: '123',
  //             userId: '123',
  //             content: 'reply 01'))
  //         .called(1);
  //   });

  //   test('답글 작성하기 - 읽기 실패', () async {
  //     //arrange
  //     when(mockNoticeRepository.writeReply(
  //             noticeId: '123',
  //             commentId: '123',
  //             userId: '123',
  //             content: 'reply 01'))
  //         .thenAnswer((_) async => Right(null));
  //     when(mockNoticeRepository.getCommentById(
  //             noticeId: '123', commentId: '123'))
  //         .thenAnswer((_) async => Left(ErrorModel(message: 'firebase error')));
  //     //act
  //     await noticeViewModel.writeReply(
  //         noticeId: '123',
  //         commentId: '123',
  //         userId: '123',
  //         content: 'reply 01');
  //     //assert
  //     expect(StateList, [State.updating, State.error]);
  //     verify(mockNoticeRepository.getCommentById(
  //             noticeId: '123', commentId: '123'))
  //         .called(1);
  //     verify(mockNoticeRepository.writeReply(
  //             noticeId: '123',
  //             commentId: '123',
  //             userId: '123',
  //             content: 'reply 01'))
  //         .called(1);
  //   });
  // });
}
