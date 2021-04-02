import 'package:dream/models/notice.dart';

abstract class NoticeRepository {
  Future<List<NoticeModel>> getNoticeList();
}
