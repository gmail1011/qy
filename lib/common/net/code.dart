///错误编码
class Code {
  ///网络异常
  static const NETWORK_ERROR = 2001;

  ///网络超时
  static const NETWORK_TIMEOUT = 2002;

  ///无网络
  static const LOCAL_NO_NETWORK = 2003;

  ///取消请求
  static const LOCAL_CANCEL_REQUEST = 2004;

  ///账号被封禁
  static const ACCOUNT_INVISIBLE = 1000;

  ///数据返回异常
  static const PARSE_DATE_ERROR = 1001;

  ///需要进行强制更新
  static const FORCE_UPDATE_VERSION = 1006;

  ///token异常
  static const TOKEN_ABNORMAL = 5009;

  ///验证码1分钟重复异常
  static const VERIFY_CODE_REPEAT = 5007;

  ///重放请求
  static const REPLAY_ATTACK = 4009;

  static const SUCCESS = 200;

  static errorHandleFunction(code, message) {
    return message;
  }
}
