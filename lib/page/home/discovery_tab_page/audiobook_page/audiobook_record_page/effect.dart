import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<AudiobookRecordState> buildEffect() {
  return combineEffects(<Object, Effect<AudiobookRecordState>>{
    AudiobookRecordAction.action: _onAction,
  });
}

void _onAction(Action action, Context<AudiobookRecordState> ctx) {
}
