/// future 扔出的异常
class ApiException implements Exception {
  int code = -200;
  final message;
  ApiException([this.code, this.message]);

  String toString() {
    if (message == null) return "ApiException:code:$code";
    return "ApiException:code:$code message:$message";
  }
}
