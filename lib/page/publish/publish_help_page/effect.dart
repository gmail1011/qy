import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<PublishHelpState> buildEffect() {
  return combineEffects(<Object, Effect<PublishHelpState>>{
    PublishHelpAction.action: _onAction,
  });
}

void _onAction(Action action, Context<PublishHelpState> ctx) {
}
