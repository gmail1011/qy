import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'action.dart';
import 'state.dart';

Reducer<MemberCentreState> buildReducer() {
  return asReducer(
    <Object, Reducer<MemberCentreState>>{

    },
  );
}
