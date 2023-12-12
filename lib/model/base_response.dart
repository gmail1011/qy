///异常返回处理
class BaseResponse {
  int code;

  String msg;

  String time;

  dynamic data;
  bool hash;

  BaseResponse(this.code, this.msg, this.data, {this.hash = false});
}
