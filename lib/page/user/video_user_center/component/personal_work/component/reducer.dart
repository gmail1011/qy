import 'package:fish_redux/fish_redux.dart';

import 'state.dart';

Reducer<WorkItemState> buildReducer() {
  return asReducer(
    <Object, Reducer<WorkItemState>>{},
  );
}
