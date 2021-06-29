import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dream/app/core/error/failure.dart';
import 'package:dream/app/data/models/pray.dart';

abstract class PrayRepository {
  //기도 페이지
  //1. 기도 보내기
  //3. 공개 기도 목록 가져오기

  Future<Either<Failure, void>> sendPray(
      String userId, String title, String content, bool? isPublic);
  Future<Either<Failure, List<PrayModel>?>> initPublicPrayList();
  Future<Either<Failure, List<PrayModel>?>> getMorePublicPrayList(
      DocumentReference? documentReference);
  Future<Either<Failure, void>> togglePrayFavorite(
      {required String prayId, required String userId, required bool isDelete});
  Future<Either<Failure, void>> updateCommentCount(
      {required String prayId, bool isIncreasement = true});
}
