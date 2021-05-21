import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/repositories/comment_repository_impl.dart';
import 'package:dream/repositories/notice_repository_impl.dart';
import 'package:dream/repositories/reply_repository.dart';
import 'package:dream/repositories/reply_repository_impl.dart';
import 'package:dream/viewmodels/comment_reply_view_model.dart';
import 'package:dream/viewmodels/notice_view_model.dart';
import 'package:get/get.dart';

class NoticeBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<NoticeViewModel>(NoticeViewModel(
        noticeRepository: NoticeRepositoryImpl(
            firebaseFirestore: FirebaseFirestore.instance)));
    Get.put<CommentReplyViewModel>(CommentReplyViewModel(
        commentRepository: CommentRepositoryImpl(
            firebaseFirestore: FirebaseFirestore.instance),
        replyRepository: ReplyRepositoryImpl(
            firebaseFirestore: FirebaseFirestore.instance)));
  }
}
