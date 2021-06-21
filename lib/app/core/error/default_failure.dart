import 'failure.dart';

class DefaultFailure extends Failure {
  DefaultFailure({required String code}) : super(code: code) {
    title = '에러';
    content = '다시 시도해주세요.';
  }
}
