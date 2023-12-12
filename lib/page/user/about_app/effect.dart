import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/utils/toast_util.dart';

import 'action.dart';
import 'state.dart';

Effect<AboutAppState> buildEffect() {
  return combineEffects(<Object, Effect<AboutAppState>>{
    AboutAppAction.copy: _copy,
  });
}

///复制分享链接到剪切板
void _copy(Action action, Context<AboutAppState> ctx) {
  String content = action.payload as String;
  Clipboard.setData(ClipboardData(text: content));
  showToast(msg: "复制成功");
}
