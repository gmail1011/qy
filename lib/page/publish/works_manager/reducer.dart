import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<WorksManagerState> buildReducer() {
  return asReducer(
    <Object, Reducer<WorksManagerState>>{
      WorksManagerAction.editModel: _changeEditModel,
    },
  );
}

WorksManagerState _changeEditModel(WorksManagerState state, Action action) {
  final WorksManagerState newState = state.clone();
  bool isEditModel = action.payload as bool;
  newState.isEditModel = isEditModel;
  return newState;
}
