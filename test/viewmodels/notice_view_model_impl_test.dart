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

  setUp(() {
    mockNoticeRepository = MockNoticeRepository();
    noticeViewModel = NoticeViewModel(noticeRepository: mockNoticeRepository);
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

  group('공지사항', () {
    test('공지사항 가져오기 - 성공', () async {
      //arrange
      when(mockNoticeRepository.getNoticeList())
          .thenAnswer((_) async => Right(noticeList));
      //act
      await noticeViewModel.getNoticeList();
      //assert
      expect(noticeViewModel.noticeList, noticeList);
      expect(noticeViewModel.noticeStatus.value, Status.loaded);
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
      expect(noticeViewModel.noticeStatus.value, Status.error);
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
      expect(noticeViewModel.noticeStatus.value, Status.empty);
      verify(mockNoticeRepository.getNoticeList()).called(1);
    });
  });
}
