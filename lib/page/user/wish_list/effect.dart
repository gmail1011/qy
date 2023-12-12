import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Effect<WishlistState> buildEffect() {
  return combineEffects(<Object, Effect<WishlistState>>{
    WishlistAction.action: _onAction,
    Lifecycle.dispose: _dispose,
  });
}

void _dispose(Action action, Context<WishlistState> ctx) {
  ctx.state.tabBarController?.dispose();
}

void _onAction(Action action, Context<WishlistState> ctx) {}
