class ErrorConstants {
  static String serverError = 'server_error';
  static String commentWriteServerError = 'comment_write_server_error';
  static String commentDeleteServerError = 'comment_delete_server_error';
  static String replyWriteServerError = 'reply_write_server_error';
  static String replyDeleteServerError = 'reply_delete_server_error';
  static Map<String, dynamic> alertMap = {
    'server_error': {
      'title': '서버 오류',
      'content': '다시 시도해주세요.',
    },
    'comment_write_server_error': {
      'title': '서버 오류',
      'content': '댓글 작성중 오류가 발생했습니다.\n다시 시도해주세요.',
    },
    'reply_write_server_error': {
      'title': '서버 오류',
      'content': '답글 작성중 오류가 발생했습니다.\n다시 시도해주세요.',
    },
    'commentDeleteServerError': {
      'title': '서버 오류',
      'content': '댓글 삭제중 오류가 발생했습니다.\n다시 시도해주세요.',
    },
    'replyDeleteServerError': {
      'title': '서버 오류',
      'content': '답글 삭제중 오류가 발생했습니다.\n다시 시도해주세요.',
    }
  };
}
