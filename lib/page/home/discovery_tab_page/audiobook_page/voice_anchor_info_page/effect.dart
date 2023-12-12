import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/page/home/discovery_tab_page/audiobook_page/voice_anchor_info_page/page.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'action.dart';
import 'state.dart';

Effect<VoiceAnchorInfoState> buildEffect() {
  return combineEffects(<Object, Effect<VoiceAnchorInfoState>>{
    Lifecycle.initState: _initState,
    VoiceAnchorInfoAction.collect: _collect,
    VoiceAnchorInfoAction.randomAnchor: _randomAnchor,
  });
}

void _collect(Action action, Context<VoiceAnchorInfoState> ctx) async {
  try {
    await netManager.client.clickCollect(
        ctx.state.model.id, "audioAnchor", !ctx.state.model.isCollect);
    ctx.dispatch(VoiceAnchorInfoActionCreator.refreshCollect());
  } catch (e) {}
}

void _initState(Action action, Context<VoiceAnchorInfoState> ctx) async {
  _isRequest = false;
}

bool _isRequest = false;
void _randomAnchor(Action action, Context<VoiceAnchorInfoState> ctx) async {
  if (_isRequest) {
    showToast(msg: "正在切换中");
  }
  _isRequest = true;
  try {
    var model = await netManager.client.getAnchorRandomList(1);
    if ((model.list?.length ?? 0) > 0) {
      Map<String, dynamic> map = {'model': model.list.first};
      // Navigator.popAndPushNamed(
      //   ctx.context,
      //   PAGE_VOICE_ANCHOR_INFO,
      //   arguments: map,
      // );
      safePopPage();
      _isRequest = false;
      Navigator.of(ctx.context).push(MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return VoiceAnchorInfoPage().buildPage(map);
          },
          fullscreenDialog: true));
    } else {
      showToast(msg: "切换下一失败");
    }
  } catch (e) {
    showToast(msg: "切换下一失败");
  }
  _isRequest = false;
}
