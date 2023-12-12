import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart';

class SelectTagsState implements Cloneable<SelectTagsState> {

  TextEditingController textEditingController  =  new TextEditingController(text: "");



  @override
  SelectTagsState clone() {
    return SelectTagsState()..textEditingController = textEditingController;
  }
}

SelectTagsState initState(Map<String, dynamic> args) {
  return SelectTagsState();
}
