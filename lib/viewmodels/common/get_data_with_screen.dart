import 'package:dream/core/screen_status/status_enum.dart';
import 'package:dream/viewmodels/common/screen_status.dart';

//화면 분기 처리 mixin
//매번 viewModel 함수에 따라 화면이 4가지 상태가 변하는데
//반복되는 부분을 줄이기 위해 mixin으로 만들었습니다.
mixin GetDataWithScreen on ScreenStatus {
  Future<T> getDataWithScreenStatus<T>(Function getData) async {
    //화면 로딩으로 시작
    setScreenStatus(Status.loading);
    try {
      return await getData();
    } catch (e) {
      //데이터 로드 중 에러 발생시 에러 화면
      setScreenStatus(Status.error);
      return null;
    }
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
