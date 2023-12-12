import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<AudioEpisodeRecordState> buildReducer() {
  return asReducer(
    <Object, Reducer<AudioEpisodeRecordState>>{
      AudioEpisodeRecordAction.setList: _setList,
    },
  );
}

AudioEpisodeRecordState _setList(AudioEpisodeRecordState state, Action action) {
  final AudioEpisodeRecordState newState = state.clone();
  return newState..list = action.payload;
}
