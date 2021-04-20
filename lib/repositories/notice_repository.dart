import 'package:dartz/dartz.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/notice.dart';
import 'package:flutter/foundation.dart';

abstract class NoticeRepository {
  Future<Either<ErrorModel, List<NoticeModel>>> getNoticeList();
  Future<Either<ErrorModel, List<NoticeCommentModel>>> getCommentList(
      String nid);
  Future<Either<ErrorModel, List<NoticeCommentReplyModel>>> getReplyList(
      String did);
  Future<Either<ErrorModel, void>> writeComment(
      {@required String nid, @required String uid, @required String content});
  Future<Either<ErrorModel, void>> writeReply(
      {@required String did, @required String uid, @required String content});
}
