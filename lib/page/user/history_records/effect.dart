import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Effect<HistoryRecordsState> buildEffect() {
  return combineEffects(<Object, Effect<HistoryRecordsState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
  });
}

void _initState(Action action, Context<HistoryRecordsState> ctx) {
  ctx.state.tabController?.addListener(() {
    print("tabController.index:${ctx.state.tabController.index}");
    ctx.broadcast(HistoryRecordsActionCreator.clearEditState(
        ctx.state.tabController.index));
  });
}

void _dispose(Action action, Context<HistoryRecordsState> ctx) {
  ctx.state.tabController?.dispose();
}
