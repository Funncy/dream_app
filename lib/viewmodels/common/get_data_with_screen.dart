import 'package:dartz/dartz.dart';
import 'package:dream/core/data_status/status_enum.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

//화면 분기 처리 mixin
//매번 viewModel 함수에 따라 화면이 4가지 상태가 변하는데
//반복되는 부분을 줄이기 위해 mixin으로 만들었습니다.
mixin GetDataWithScreen {
  Future<T> getDataWithScreenStatus<T>(
      {@required Function getData,
      @required Rx<Status> dataStatus,
      @required bool isInitial,
      @required bool isList}) async {
    //화면 로딩으로 시작
    if (isInitial) dataStatus.value = Status.loading;

    //Either Left는 실패 Right는 성공
    //fold로 좌우 분기 처리
    Either<ErrorModel, T> result = await getData();
    return result.fold((l) {
      dataStatus.value = Status.error;
      return null;
    }, (r) {
      if (!isList) dataStatus.value = Status.loaded;
      return r;
    });
  }

  //데이터가 빈 경우 Empty화면 띄워야하는 경우
  void checkEmptyWithScreenStatus<S>(
      {@required List<S> result, @required Rx<Status> dataStatus}) {
    if (result.length == 0) {
      dataStatus.value = Status.empty;
    } else {
      dataStatus.value = Status.loaded;
    }
  }
}
