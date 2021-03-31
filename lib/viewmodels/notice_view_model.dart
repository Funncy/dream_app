import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/repositories/notice_repository.dart';
import 'package:dream/repositories/notice_repository_impl.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class NoticeViewModel extends GetxController {
  NoticeRepository _noticeRepository;
  RxList<NoticeModel> notices = <NoticeModel>[].obs;

  NoticeViewModel() {
    _noticeRepository = NoticeRepositoryImpl(FirebaseFirestore.instance);
  }

  // NoticeViewModel(NoticeRepository noticeRepository) {
  //   _noticeRepository = noticeRepository;
  // }

  void getNotices() async {
    var data = await _noticeRepository.getNotices();
    if (data != null) notices.addAll(data);
  }
}
