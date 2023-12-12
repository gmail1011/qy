import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<VoiceState> buildEffect() {
  return combineEffects(<Object, Effect<VoiceState>>{
    VoiceAction.action: _onAction,
  });
}

void _onAction(Action action, Context<VoiceState> ctx) {
}
