import 'package:fish_redux/fish_redux.dart';

import 'publish_action.dart';
import 'publish_state.dart';

Effect<PublishState> buildEffect() {
  return combineEffects(<Object, Effect<PublishState>>{
    PublishAction.action: _onAction,
  });
}

void _onAction(Action action, Context<PublishState> ctx) {
}
