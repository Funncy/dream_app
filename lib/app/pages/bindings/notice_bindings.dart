import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/app/repositories/comment_repository_impl.dart';
import 'package:dream/app/repositories/notice_repository_impl.dart';
import 'package:dream/app/repositories/reply_repository_impl.dart';
import 'package:dream/app/viewmodels/comment_view_model.dart';
import 'package:dream/app/viewmodels/notice_view_model.dart';
import 'package:dream/app/viewmodels/reply_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class NoticeBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<NoticeViewModel>(NoticeViewModel(
        noticeRepository: NoticeRepositoryImpl(
            firebaseFirestore: FirebaseFirestore.instance,
            firebaseStorage: FirebaseStorage.instance)));
    Get.put<CommentViewModel>(CommentViewModel(
        noticeRepository: NoticeRepositoryImpl(
            firebaseFirestore: FirebaseFirestore.instance,
            firebaseStorage: FirebaseStorage.instance),
        commentRepository: CommentRepositoryImpl(
            firebaseFirestore: FirebaseFirestore.instance)));
    Get.put<ReplyViewModel>(ReplyViewModel(
        noticeRepository: NoticeRepositoryImpl(
            firebaseFirestore: FirebaseFirestore.instance,
            firebaseStorage: FirebaseStorage.instance),
        commentRepository: CommentRepositoryImpl(
            firebaseFirestore: FirebaseFirestore.instance),
        replyRepository:
            ReplyRepositoryImpl(firebaseFirestore: FirebaseFirestore.instance),
        commentViewModel: Get.find<CommentViewModel>()));
  }
}
