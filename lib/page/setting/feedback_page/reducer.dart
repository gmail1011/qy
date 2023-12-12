import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<FeedbackState> buildReducer() {
  return asReducer(
    <Object, Reducer<FeedbackState>>{
      FeedbackAction.setFeedbackList: _setFeedbackList,
      FeedbackAction.setMoreFeedbackList: _setMoreFeedbackList,
    },
  );
}

FeedbackState _setFeedbackList(FeedbackState state, Action action) {
  final FeedbackState newState = state.clone();
  newState.feedbacks = action.payload;
  return newState;
}

FeedbackState _setMoreFeedbackList(FeedbackState state, Action action) {
  final FeedbackState newState = state.clone();
  newState.feedbacks.addAll(action.payload);
  newState.pageNumber++;
  return newState;
}
