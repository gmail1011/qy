import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/global_store/store.dart';

class EditNickNameState implements Cloneable<EditNickNameState> {
  TextEditingController nickController = TextEditingController();

  @override
  EditNickNameState clone() {
    return EditNickNameState()..nickController = nickController;
  }
}

EditNickNameState initState(Map<String, dynamic> args) {
  return EditNickNameState()..nickController.text = GlobalStore.getMe()?.name ?? "";
}
