import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<AgentRecordState> buildEffect() {
  return combineEffects(<Object, Effect<AgentRecordState>>{
    AgentRecordAction.action: _onAction,
  });
}

void _onAction(Action action, Context<AgentRecordState> ctx) {
}
