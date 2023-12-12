import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<NakeChatReportState> buildReducer() {
  return asReducer(
    <Object, Reducer<NakeChatReportState>>{
      YuePaoReportAction.type: _onTypeChange,
      YuePaoReportAction.updatePic: _onUpdatePic,
      YuePaoReportAction.deleteItem: _onDeleteItem,
    },
  );
}

NakeChatReportState _onTypeChange(NakeChatReportState state, Action action) {
  final NakeChatReportState newState = state.clone()
  ..type = action.payload??0;
  return newState;
}
NakeChatReportState _onUpdatePic(NakeChatReportState state, Action action) {
  final NakeChatReportState newState = state.clone()
  ..localPicList.addAll(action.payload??[]);
  return newState;
}
NakeChatReportState _onDeleteItem(NakeChatReportState state, Action action) {
  final NakeChatReportState newState = state.clone()
  ..localPicList.removeAt(action.payload);
  return newState;
}

