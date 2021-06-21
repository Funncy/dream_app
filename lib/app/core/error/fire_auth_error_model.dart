import 'error_model.dart';

class FireAuthErrorModel extends ErrorModel {
  Map<String, Map<String, Object>> messageMap = {
    //FireAuth Login
    'expired-action-code': {'title': '에러 발생', 'content': '다시 시도해주세요.'},
    'invalid-action-code': {'title': '에러 발생', 'content': '다시 시도해주세요.'},
    'user-disabled': {'title': '에러 발생', 'content': '해당 아이디가 비활성화 상태입니다.'},
    'user-not-found': {'title': '에러 발생', 'content': '아이디와 비밀번호를 확인해주세요.'},
    //FireAuth SignUp
    'weak-password': {'title': '에러 발생', 'content': '비밀번호가 너무 쉽습니다.'},
    'email-already-in-use': {
      'title': '이메일 중복',
      'content': '해당 이메일을 이미 사용중입니다.'
    },
    'invalid-email': {'title': '이메일 오류', 'content': '이메일 형태에 문제가 있습니다.'},
    'operation-not-allowed': {'title': '에러 발생', 'content': '다시 시도해주세요.'},
  };
  FireAuthErrorModel({required String code}) : super(code: code) {
    Map<String, Object>? errorMessage = (messageMap[code] ?? null);
    if (errorMessage == null) {
      title = '에러';
      content = '다시 시도해주세요.';
      return;
    }
    title = errorMessage['title'] as String;
    content = errorMessage['content'] as String;
  }
}
