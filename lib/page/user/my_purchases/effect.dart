import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Effect<MyPurchasesState> buildEffect() {
  return combineEffects(<Object, Effect<MyPurchasesState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
  });
}

void _initState(Action action, Context<MyPurchasesState> ctx) {}

void _dispose(Action action, Context<MyPurchasesState> ctx) {
  ctx.state.tabController?.dispose();
}
