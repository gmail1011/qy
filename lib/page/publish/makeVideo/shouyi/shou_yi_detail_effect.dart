import 'package:fish_redux/fish_redux.dart';

import 'shou_yi_detail_action.dart';
import 'shou_yi_detail_state.dart';

Effect<ShouYiDetailState> buildEffect() {
  return combineEffects(<Object, Effect<ShouYiDetailState>>{
    Lifecycle.initState: _initState,
  });
}

void _initState(Action action, Context<ShouYiDetailState> ctx) {
  if (ctx.state.rankTypeData?.members?.isNotEmpty ?? false) {
    ctx.state.controller?.requestSuccess();
    ctx.dispatch(ShouYiDetailActionCreator.refreshUI());
  } else {
    ctx.state.controller?.requestDataEmpty();
  }
}
