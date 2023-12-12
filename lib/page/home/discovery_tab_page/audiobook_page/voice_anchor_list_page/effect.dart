import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<VoiceAnchorListState> buildEffect() {
  return combineEffects(<Object, Effect<VoiceAnchorListState>>{
    VoiceAnchorListAction.action: _onAction,
  });
}

void _onAction(Action action, Context<VoiceAnchorListState> ctx) {}
