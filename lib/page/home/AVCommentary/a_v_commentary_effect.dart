import 'package:fish_redux/fish_redux.dart';

import 'a_v_commentary_action.dart';
import 'a_v_commentary_state.dart';

Effect<AVCommentaryState> buildEffect() {
  return combineEffects(<Object, Effect<AVCommentaryState>>{
    AVCommentaryAction.action: _onAction,
  });
}

void _onAction(Action action, Context<AVCommentaryState> ctx) {
}
