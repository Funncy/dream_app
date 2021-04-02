import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/error/error_model.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/repositories/notice_repository_impl.dart';
import 'package:dream/viewmodels/notice_view_model.dart';
import 'package:dream/viewmodels/common/screen_status.dart';
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
    NoticeModel(uid: '123', content: 'test1', images: ['test']),
    NoticeModel(uid: '123', content: 'test2', images: ['test']),
    NoticeModel(uid: '123', content: 'test3', images: ['test']),
  ];

  test('공지사항 가져오기 - 성공', () async {
    //arrange
    when(mockNoticeRepository.getNotices()).thenAnswer((_) async => noticeList);
    //act
    await noticeViewModel.getNotices();
    //assert
    expect(noticeViewModel.notices, noticeList);
    expect(noticeViewModel.getScreenStatus(), Status.loaded);
    verify(mockNoticeRepository.getNotices()).called(1);
  });

  test('공지사항 가져오기 - 에러', () async {
    //arrange
    when(mockNoticeRepository.getNotices())
        .thenThrow(ErrorModel(message: 'Firebase Error'));
    //act
    await noticeViewModel.getNotices();
    //assert
    expect(noticeViewModel.notices.length, 0);
    expect(noticeViewModel.getScreenStatus(), Status.error);
    verify(mockNoticeRepository.getNotices()).called(1);
  });

  test('공지사항 가져오기 - Empty', () async {
    //arrange
    when(mockNoticeRepository.getNotices()).thenAnswer((_) async => []);
    //act
    await noticeViewModel.getNotices();
    //assert
    expect(noticeViewModel.notices.length, 0);
    expect(noticeViewModel.getScreenStatus(), Status.empty);
    verify(mockNoticeRepository.getNotices()).called(1);
  });
}
