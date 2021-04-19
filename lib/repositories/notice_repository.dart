import 'package:dartz/dartz.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/notice.dart';

abstract class NoticeRepository {
  Future<Either<ErrorModel, List<NoticeModel>>> getNoticeList();
  Future<Either<ErrorModel, List<NoticeCommentModel>>> getCommentList(
      String nid);
  Future<Either<ErrorModel, void>> writeComment(
      String nid, String uid, String content);
}
