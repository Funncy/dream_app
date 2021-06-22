import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/failure.dart';
import 'package:dream/app/data/models/notice.dart';

abstract class NoticeRepository {
  Future<void> createDummyData();

  Future<Either<Failure, List<NoticeModel>>> getNoticeList();

  Future<Either<Failure, List<NoticeModel>?>> getMoreNoticeList(
      DocumentReference? documentReference);

  Future<Either<Failure, void>> updateCommentCount(
      {required String? noticeId, bool isIncreasement = true});

  Future<Either<Failure, void>> toggleNoticeFavorite(
      {required String? noticeId,
      required String userId,
      required bool isDelete});
}
