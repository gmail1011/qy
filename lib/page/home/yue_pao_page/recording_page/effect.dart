import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<RecordingState> buildEffect() {
  return combineEffects(<Object, Effect<RecordingState>>{
    RecordingAction.action: _onAction,
  });
}

void _onAction(Action action, Context<RecordingState> ctx) {
}
