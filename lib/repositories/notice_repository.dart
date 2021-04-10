import 'package:dartz/dartz.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/models/notice.dart';

abstract class NoticeRepository {
  Future<Either<ErrorModel, List<NoticeModel>>> getNoticeList();
}
