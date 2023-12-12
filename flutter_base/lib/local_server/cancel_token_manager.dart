import 'package:dio/dio.dart';
import 'package:flutter_base/utils/text_util.dart';

/// 取消token管理
class CancelTokenManager {
  static CancelTokenManager _instance;
  //取消token单例
  factory CancelTokenManager() {
    if (_instance == null) {
      _instance = CancelTokenManager._();
    }
    return _instance;
  }
  CancelTokenManager._();

  /// 取消token列表
  List<CancelTokenWarp> _cancelTokens = [];

  /// 创建cancleToken如果需要
  /// [url]
  CancelToken createToken(String url, [String uniquekey]) {
    var ctw = CancelTokenWarp(url, CancelToken())..uniqueKey = uniquekey;
    _cancelTokens.add(ctw);
    return ctw.token;
  }

  /// 获取cancleToken如果需要
  /// [url]
  CancelToken getToken(String url, [String uniquekey]) {
    return _cancelTokens?.firstWhere((it) {
      if (TextUtil.isEmpty(uniquekey)) {
        return it.url == url;
      } else {
        return it.url == url && it.uniqueKey == uniquekey;
      }
    }, orElse: () => null)?.token;
  }

  List<CancelTokenWarp> get peekList => _cancelTokens;

  /// 删除
  /// [url]
  CancelToken remove(String url, [String uniquekey]) {
    var ctw = _cancelTokens?.firstWhere((it) {
      if (TextUtil.isEmpty(uniquekey)) {
        return it.url == url;
      } else {
        return it.url == url && it.uniqueKey == uniquekey;
      }
    }, orElse: () => null);
    if (null != ctw) {
      _cancelTokens.remove(ctw);
    }
    return ctw?.token;
  }

  /// 正在请求的长度
  int get length => _cancelTokens.length;
}

class CancelTokenWarp {
  String url;
  CancelToken token;
  String uniqueKey;
  CancelTokenWarp(this.url, this.token);
}
