import 'package:fish_redux/fish_redux.dart';

import 'publish_detail_action.dart';
import 'publish_detail_state.dart';

Effect<PublishDetailState> buildEffect() {
  return combineEffects(<Object, Effect<PublishDetailState>>{
    PublishDetailAction.action: _onAction,
  });
}

void _onAction(Action action, Context<PublishDetailState> ctx) {
}
