import 'error_model.dart';

class ServerErrorModel extends ErrorModel {
  ServerErrorModel({required String code}) : super(code: code) {
    title = '서버 에러';
    content = '네트워크에 문제가 있습니다. 다시 시도해주세요.';
  }
}
