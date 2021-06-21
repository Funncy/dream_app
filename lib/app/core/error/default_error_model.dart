import 'error_model.dart';

class DefaultErrorModel extends ErrorModel {
  DefaultErrorModel({required String code}) : super(code: code) {
    title = '에러';
    content = '다시 시도해주세요.';
  }
}
