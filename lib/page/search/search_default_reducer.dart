import 'package:fish_redux/fish_redux.dart';

import 'search_default_action.dart';
import 'search_default_state.dart';

Reducer<SearchDefaultState> buildReducer() {
  return asReducer(
    <Object, Reducer<SearchDefaultState>>{
      SearchDefaultAction.action: _onAction,
      SearchDefaultAction.initData: _onInitData,
    },
    );
  }

  SearchDefaultState _onAction(SearchDefaultState state, Action action) {
    final SearchDefaultState newState = state.clone();
    return newState;
  }

  SearchDefaultState _onInitData(SearchDefaultState state, Action action) {
    final SearchDefaultState newState = state.clone();
    newState.searchDefaultData = action.payload;
    return newState;
  }
