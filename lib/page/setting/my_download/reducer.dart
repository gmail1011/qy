import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<MyDownloadState> buildReducer() {
  return asReducer(
    <Object, Reducer<MyDownloadState>>{
      MyDownloadAction.updateListOkay: _onUpdateListOkay,
    },
  );
}

MyDownloadState _onUpdateListOkay(MyDownloadState state, Action action) {
  final MyDownloadState newState = state.clone()..list = action.payload;
  return newState;
}
