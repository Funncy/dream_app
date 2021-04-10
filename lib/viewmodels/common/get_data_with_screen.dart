import 'package:dartz/dartz.dart';
import 'package:dream/core/error/error_model.dart';
import 'package:dream/core/screen_status/status_enum.dart';
import 'package:dream/viewmodels/common/screen_status.dart';

//화면 분기 처리 mixin
//매번 viewModel 함수에 따라 화면이 4가지 상태가 변하는데
//반복되는 부분을 줄이기 위해 mixin으로 만들었습니다.
mixin GetDataWithScreen on ScreenStatus {
  Future<T> getDataWithScreenStatus<T>(Function getData) async {
    //화면 로딩으로 시작
    setScreenStatus(Status.loading);

    //Either Left는 실패 Right는 성공
    //fold로 좌우 분기 처리
    Either<ErrorModel, T> result = await getData();
    return result.fold((l) {
      setScreenStatus(Status.error);
      return null;
    }, (r) => r);
  }

  //데이터가 빈 경우 Empty화면 띄워야하는 경우
  void checkEmptyWithScreenStatus<S>(List<S> result) {
    if (result.length == 0) {
      setScreenStatus(Status.empty);
    } else {
      setScreenStatus(Status.loaded);
    }
  }
}
