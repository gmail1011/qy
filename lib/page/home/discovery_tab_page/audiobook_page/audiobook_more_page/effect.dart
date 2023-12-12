import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'action.dart';
import 'state.dart';

Effect<AudiobookMoreState> buildEffect() {
  return combineEffects(<Object, Effect<AudiobookMoreState>>{
    Lifecycle.initState: _initState,
  });
}

void _initState(Action action, Context<AudiobookMoreState> ctx) async {
  try {
    var model = await netManager.client.getAudioBookType();
    ctx.dispatch(AudiobookMoreActionCreator.setTabs(model.audiobookType));
  } catch (e) {}
}
