import 'package:dartz/dartz.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/comment.dart';
import 'package:dream/models/notice.dart';
import 'package:dream/models/reply.dart';
import 'package:flutter/foundation.dart';

abstract class NoticeRepository {

  Future<void> createDummyData();

  Future<Either<ErrorModel, List<NoticeModel>>> getNoticeList();

  Future<Either<ErrorModel, void>> toggleNoticeFavorite(
      {@required String noticeId,
      @required String userId,
      @required bool isDelete});
}
