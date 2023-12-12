import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<MineBillItemState> buildEffect() {
  return combineEffects(<Object, Effect<MineBillItemState>>{
    MineBilleItemAction.action: _onAction,
  });
}

void _onAction(Action action, Context<MineBillItemState> ctx) {
}
