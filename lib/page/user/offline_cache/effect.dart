import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Effect<OfflineCacheState> buildEffect() {
  return combineEffects(<Object, Effect<OfflineCacheState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
  });
}

void _initState(Action action, Context<OfflineCacheState> ctx) {
  ctx.state.tabController?.addListener(() {
    print("tabController.index:${ctx.state.tabController.index}");
    ctx.broadcast(OfflineCacheActionCreator.clearEditState(
        ctx.state.tabController.index));
  });
}

void _dispose(Action action, Context<OfflineCacheState> ctx) {
  ctx.state.tabController?.dispose();
}
