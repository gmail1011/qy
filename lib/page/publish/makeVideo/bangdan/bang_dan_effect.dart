import 'package:fish_redux/fish_redux.dart';

import 'bang_dan_state.dart';

Effect<BangDanState> buildEffect() {
  return combineEffects(<Object, Effect<BangDanState>>{
    Lifecycle.dispose: _dispose,
  });
}

void _dispose(Action action, Context<BangDanState> ctx) {
  ctx.state.tabController?.dispose();
}
