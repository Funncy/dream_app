import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/error_model.dart';
import 'package:dream/app/data/models/notice.dart';

abstract class NoticeRepository {
  Future<void> createDummyData();

  Future<Either<ErrorModel, List<NoticeModel>>> getNoticeList();

  Future<Either<ErrorModel, List<NoticeModel>?>> getMoreNoticeList(
      DocumentReference? documentReference);

  Future<Either<ErrorModel, void>> updateCommentCount(
      {required String? noticeId, bool isIncreasement = true});

  Future<Either<ErrorModel, void>> toggleNoticeFavorite(
      {required String? noticeId,
      required String userId,
      required bool isDelete});
}