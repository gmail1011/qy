import 'package:fish_redux/fish_redux.dart';

import 'select_tags_action.dart';
import 'select_tags_state.dart';

Effect<SelectTagsState> buildEffect() {
  return combineEffects(<Object, Effect<SelectTagsState>>{
    SelectTagsAction.action: _onAction,
  });
}

void _onAction(Action action, Context<SelectTagsState> ctx) {
}
