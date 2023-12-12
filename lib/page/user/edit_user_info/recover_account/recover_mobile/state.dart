import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class RecoverMobileState implements Cloneable<RecoverMobileState> {
  GlobalKey globalKey = GlobalKey();
  TextEditingController mobileEditingController = TextEditingController();

  @override
  RecoverMobileState clone() {
    return RecoverMobileState()
      ..globalKey = globalKey
      ..mobileEditingController = mobileEditingController;
  }
}

RecoverMobileState initState(Map<String, dynamic> args) {
  return RecoverMobileState();
}
