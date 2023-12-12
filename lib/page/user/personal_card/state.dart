import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/global_store/state.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class PersonalCardState extends GlobalBaseState
    with EagleHelper implements Cloneable<PersonalCardState> {
  GlobalKey boundaryKey = new GlobalKey();

  @override
  PersonalCardState clone() {
    return PersonalCardState()..boundaryKey = boundaryKey;
  }
}

PersonalCardState initState(Map<String, dynamic> args) {
  return PersonalCardState();
}
