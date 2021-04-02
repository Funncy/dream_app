import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream/error/error_model.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/repositories/notice_repository.dart';
import 'package:flutter/foundation.dart';

class NoticeRepositoryImpl extends NoticeRepository {
  FirebaseFirestore _firebaseFirestore;

  NoticeRepositoryImpl({@required FirebaseFirestore firebaseFirestore}) {
    _firebaseFirestore = firebaseFirestore;
  }

  @override
  Future<List<NoticeModel>> getNotices() async {
    List<NoticeModel> notices = [];

    try {
      var noticeCollection =
          await _firebaseFirestore.collection('notice').get();
      for (var notice in noticeCollection.docs) {
        notices.add(NoticeModel.fromFirestroe(notice));

        // Comment 가져오기
        List<NoticeCommentModel> comments = [];
        var commentCollection =
            await notice.reference.collection('comment').get();
        for (var comment in commentCollection.docs) {
          comments.add(NoticeCommentModel.fromFirestroe(comment));
          // Reply 가져오기
          List<NoticeCommentReplyModel> replys = [];
          var replyCollection =
              await comment.reference.collection('reply').get();
          for (var reply in replyCollection.docs) {
            replys.add(NoticeCommentReplyModel.fromFirestroe(reply));
          }
          comments.last.replys = replys?.cast<NoticeCommentReplyModel>();
        }
        notices.last.comments = comments?.cast<NoticeCommentModel>();
      }
    } catch (e) {
      throw ErrorModel(message: '파이어베이스 에러');
    }
    return notices;
  }
}
