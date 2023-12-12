import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<PassionRecordingState> buildEffect() {
  return combineEffects(<Object, Effect<PassionRecordingState>>{
    PassionRecordingAction.action: _onAction,
  });
}

void _onAction(Action action, Context<PassionRecordingState> ctx) {
}
