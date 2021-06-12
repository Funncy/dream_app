import 'package:dream/core/data_status/data_result.dart';
import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/core/data_status/viewmodel_result.dart';
import 'package:dream/models/notice.dart';

abstract class NoticeViewModel {
  List<NoticeModel> get noticeList;
  Status? get noticeStatus;
  set noticeStatus(Status? status);

  Future<ViewModelResult> getNoticeList();
  Future<ViewModelResult> getMoreNoticeList();
  Future<DataResult> toggleNoticeFavorite(
      {required String? noticeId, required String userId});
  void refreshNotice();
}
