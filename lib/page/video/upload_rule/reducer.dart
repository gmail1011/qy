import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/video/upload_rule/action.dart';

import 'state.dart';

Reducer<UploadRuleState> buildReducer() {
  return asReducer(
    <Object, Reducer<UploadRuleState>>{
    UploadRuleAction.initSuccessAction:_initSuccess
    },
  );
}


UploadRuleState _initSuccess(UploadRuleState state, Action action) {
  final UploadRuleState newState = state.clone();
  return newState;
}
