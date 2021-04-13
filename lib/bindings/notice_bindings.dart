import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/repositories/notice_repository_impl.dart';
import 'package:dream/viewmodels/notice_view_model.dart';
import 'package:get/get.dart';

class NoticeBindings implements Bindings {
  @override
  void dependencies() {
    Get.create<NoticeViewModel>(() => NoticeViewModel(
        noticeRepository: NoticeRepositoryImpl(
            firebaseFirestore: FirebaseFirestore.instance)));
  }
}
