import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';

class GameRulesState implements Cloneable<GameRulesState> {
  ScrollController scrollController = new ScrollController();
  @override
  GameRulesState clone() {
    return GameRulesState()..scrollController = scrollController;
  }
}

GameRulesState initState(Map<String, dynamic> args) {
  return GameRulesState();
}
