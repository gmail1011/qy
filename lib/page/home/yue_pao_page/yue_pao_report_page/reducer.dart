import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<YuePaoReportState> buildReducer() {
  return asReducer(
    <Object, Reducer<YuePaoReportState>>{
      YuePaoReportAction.type: _onTypeChange,
      YuePaoReportAction.updatePic: _onUpdatePic,
      YuePaoReportAction.deleteItem: _onDeleteItem,
    },
  );
}

YuePaoReportState _onTypeChange(YuePaoReportState state, Action action) {
  final YuePaoReportState newState = state.clone()
  ..type = action.payload??0;
  return newState;
}
YuePaoReportState _onUpdatePic(YuePaoReportState state, Action action) {
  final YuePaoReportState newState = state.clone()
  ..localPicList.addAll(action.payload??[]);
  return newState;
}
YuePaoReportState _onDeleteItem(YuePaoReportState state, Action action) {
  final YuePaoReportState newState = state.clone()
  ..localPicList.removeAt(action.payload);
  return newState;
}

