import 'package:flutter/material.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/text_util.dart';

const KEY_ORIGIN_ID = "_key_origin_id";
const KEY_SELF_ID = "_key_self_id";

/// 埋点帮助类
mixin EagleHelper {
  String _sourceId;
  String _selfId;

  /// 事件流
  String eagleId(BuildContext ctx) {
    if (TextUtil.isNotEmpty(_originId(ctx))) {
      return "${_originId(ctx)}->${selfId()}";
    } else {
      return selfId();
    }
  }

  /// 源id,祖先id
  String _originId(BuildContext ctx) {
    if (null == _sourceId) {
      var map = ModalRoute.of(ctx)?.settings?.arguments;
      if (null != map && map is Map && map.containsKey(KEY_ORIGIN_ID)) {
        _sourceId = map[KEY_ORIGIN_ID] as String;
        l.i("eagle", "_originId()...获取到事件源Id:$_sourceId");
      } else {
        _sourceId = "";
        l.e("eagle", "_originId()...获取到事件源Id err:$_sourceId");
      }
    }
    return _sourceId;
  }

  /// 自己的id uniqueId
  String selfId() {
    if (null == _selfId) {
      _selfId = this.runtimeType.toString();
    }
    return _selfId;
  }
}
