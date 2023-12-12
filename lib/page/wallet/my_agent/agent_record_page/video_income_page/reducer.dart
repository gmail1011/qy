import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<VideoIncomeState> buildReducer() {
  return asReducer(
    <Object, Reducer<VideoIncomeState>>{
      VideoIncomeAction.setLoadData: _setLoadData,
      VideoIncomeAction.setLoadMoreData: _setLoadMoreData,
    },
  );
}

VideoIncomeState _setLoadData(VideoIncomeState state, Action action) {
  final VideoIncomeState newState = state.clone();
  newState.model = action.payload;
  newState.videoIncomeList = newState.model?.videoIncomeList ?? [];
  newState.pageNumber = 1;
  return newState;
}

VideoIncomeState _setLoadMoreData(VideoIncomeState state, Action action) {
  final VideoIncomeState newState = state.clone();
  newState.videoIncomeList.addAll(action.payload);
  newState.pageNumber++;
  return newState;
}
