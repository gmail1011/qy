import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/page/home/discovery_tab_page/com/public_widget.dart';

class NovelSearchResultState implements Cloneable<NovelSearchResultState> {
  TextEditingController editingController;
  String keywords = '';
  NOVEL_SEARCH_PAGE_TYPE type = NOVEL_SEARCH_PAGE_TYPE.PAGE_NOVEL;
  @override
  NovelSearchResultState clone() {
    return NovelSearchResultState()
      ..editingController = editingController
      ..type = type
      ..keywords = keywords;
  }
}

NovelSearchResultState initState(Map<String, dynamic> args) {
  var state = NovelSearchResultState();
  if (args != null) {
    state.keywords = args['keywords'] ?? '';
    state.type = args['type'] ?? NOVEL_SEARCH_PAGE_TYPE.PAGE_NOVEL;
  }
  state.editingController = TextEditingController.fromValue(TextEditingValue(
      text: state.keywords ?? '',
      selection: TextSelection.fromPosition(TextPosition(
          affinity: TextAffinity.downstream,
          offset: (state.keywords ?? '').length))));
  return state;
}
