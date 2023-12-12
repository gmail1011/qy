import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<AudiobookState> buildReducer() {
  return asReducer(
    <Object, Reducer<AudiobookState>>{
      AudiobookAction.setAllData: _setAllData,
      AudiobookAction.setChangePush: _setChangePush,
      AudiobookAction.setLoading: _setLoading,
    },
  );
}

AudiobookState _setAllData(AudiobookState state, Action action) {
  final AudiobookState newState = state.clone();
  newState.audioBookHomeModel = action.payload;
  newState.isLoading = false;
  return newState;
}

AudiobookState _setChangePush(AudiobookState state, Action action) {
  final AudiobookState newState = state.clone();
  newState.audioBookHomeModel.pushAudioBook = action.payload;
  newState.isLoading = false;
  return newState;
}

AudiobookState _setLoading(AudiobookState state, Action action) {
  final AudiobookState newState = state.clone();
  newState.isLoading = action.payload;
  return newState;
}
