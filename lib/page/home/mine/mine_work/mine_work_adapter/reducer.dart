import 'package:fish_redux/fish_redux.dart';
import '../state.dart';
import 'action.dart';

Reducer<MineWorkState> buildReducer() {
  return asReducer(
    <Object, Reducer<MineWorkState>>{
      MineWorkAction.action: _onAction,
    },
  );
}

MineWorkState _onAction(MineWorkState state, Action action) {
  final MineWorkState newState = state.clone();
  return newState;
}
