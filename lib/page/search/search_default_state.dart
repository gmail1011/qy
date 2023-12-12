import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/search_default_entity.dart';

class SearchDefaultState implements Cloneable<SearchDefaultState> {


  SearchDefaultData searchDefaultData;

  TextEditingController textEditingController = new TextEditingController(text: "");

  @override
  SearchDefaultState clone() {
    return SearchDefaultState()..searchDefaultData = searchDefaultData..textEditingController = textEditingController;
  }
}

SearchDefaultState initState(Map<String, dynamic> args) {
  return SearchDefaultState();
}
