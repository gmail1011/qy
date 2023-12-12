import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_store/local_audio_store.dart';
import 'action.dart';
import 'state.dart';

Effect<AudioEpisodeRecordState> buildEffect() {
  return combineEffects(<Object, Effect<AudioEpisodeRecordState>>{
    Lifecycle.initState: _initState,
  });
}

void _initState(Action action, Context<AudioEpisodeRecordState> ctx) async {
  var list = await LocalAudioStore().getCachedAudios();

  ctx.state.pullRefreshController.requestSuccess(
    isFirstPageNum: true,
    isEmpty: (list?.length ?? 0) == 0,
  );
  ctx.dispatch(AudioEpisodeRecordActionCreator.setList(list));
}
