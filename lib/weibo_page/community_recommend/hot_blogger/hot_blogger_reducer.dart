import 'package:fish_redux/fish_redux.dart';

import 'hot_blogger_action.dart';
import 'hot_blogger_state.dart';

Reducer<HotBloggerState> buildReducer() {
  return asReducer(
    <Object, Reducer<HotBloggerState>>{
      HotBloggerAction.action: _onAction,
      HotBloggerAction.getHotBlogger: _onGetHotBlogger,
      HotBloggerAction.reFreshFlollowUi: _onReFreshFollowUi,
      HotBloggerAction.RefreshData: _onRefreshData,
    },
  );
}

HotBloggerState _onAction(HotBloggerState state, Action action) {
  final HotBloggerState newState = state.clone();
  return newState;
}

HotBloggerState _onGetHotBlogger(HotBloggerState state, Action action) {
  final HotBloggerState newState = state.clone();
  newState.bloggerDataList = action.payload;
  return newState;
}

HotBloggerState _onReFreshFollowUi(HotBloggerState state, Action action) {
  final HotBloggerState newState = state.clone();
  newState.bloggerDataList = action.payload;
  return newState;
}


HotBloggerState _onRefreshData(HotBloggerState state, Action action) {
  final HotBloggerState newState = state.clone();
  return newState;
}
