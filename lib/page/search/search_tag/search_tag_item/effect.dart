import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<SearchTagItemState> buildEffect() {
  return combineEffects(<Object, Effect<SearchTagItemState>>{
    SearchTagItemAction.action: _onAction,
  });
}

void _onAction(Action action, Context<SearchTagItemState> ctx) {
}
