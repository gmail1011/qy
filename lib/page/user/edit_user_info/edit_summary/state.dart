import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class EditSummaryState implements Cloneable<EditSummaryState> {
  TextEditingController editingController = TextEditingController();

  @override
  EditSummaryState clone() {
    return EditSummaryState()..editingController = editingController;
  }
}

EditSummaryState initState(Map<String, dynamic> args) {
  return EditSummaryState();
}
