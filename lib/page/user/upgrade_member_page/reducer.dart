import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<UpgradeMemberState> buildReducer() {
  return asReducer(
    <Object, Reducer<UpgradeMemberState>>{
      UpgradeMemberAction.getInfoOkay: _getInfoOkay,
    },
  );
}

UpgradeMemberState _getInfoOkay(UpgradeMemberState state, Action action) {
  return state.clone()..upgradeInfo = action.payload;
}
