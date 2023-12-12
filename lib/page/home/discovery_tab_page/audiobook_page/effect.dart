import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_base/utils/log.dart';
import 'action.dart';
import 'state.dart';

Effect<AudiobookState> buildEffect() {
  return combineEffects(<Object, Effect<AudiobookState>>{
    Lifecycle.initState: _initState,
    AudiobookAction.loadData: _loadData,
    AudiobookAction.changePush: _changePush,
  });
}

void _initState(Action action, Context<AudiobookState> ctx) {
  _loadData(action, ctx);
}

void _loadData(Action action, Context<AudiobookState> ctx) async {
  try {
    var model = await netManager.client.getAudioBookHome();
    ctx.dispatch(AudiobookActionCreator.setAllData(model));
    ctx.state.pullRefreshController.requestSuccess(isFirstPageNum: true);
  } catch (e) {
    l.d("getAudioBookHome", e.toString());
    ctx.state.pullRefreshController.requestFail(isFirstPageNum: true);
  }
}

void _changePush(Action action, Context<AudiobookState> ctx) async {
  try {
    var model = await netManager.client.getAudioBookRandomList(6);
    ctx.dispatch(AudiobookActionCreator.setChangePush(model.list));
  } catch (e) {
    l.d("getAudioBookHome", e.toString());
  }
}
