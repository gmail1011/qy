import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/global_store/state.dart';

class FilmTelevisionState extends GlobalBaseState implements Cloneable<FilmTelevisionState> {
  TabController tabController;
  bool isAlreadyShow;
  int dataType = 0 ;
  @override
  FilmTelevisionState clone() {
    return FilmTelevisionState()..tabController = tabController
      ..dataType = dataType
    ..isAlreadyShow = isAlreadyShow
    ;
  }
}

FilmTelevisionState initState(Map<String, dynamic> args) {
  return FilmTelevisionState()..dataType = args["dataType"];
}
