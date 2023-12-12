import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_base/utils/navigator_util.dart';

import 'action.dart';
import 'state.dart';

Effect<ViewAvatarState> buildEffect() {
  return combineEffects(<Object, Effect<ViewAvatarState>>{
      ViewAvatarAction.backAction: _backAction,
      Lifecycle.initState: _initState,
  });
}

void _backAction(Action action, Context<ViewAvatarState> ctx) {
  safePopPage();
}

void _initState(Action action, Context<ViewAvatarState> ctx) {

}

