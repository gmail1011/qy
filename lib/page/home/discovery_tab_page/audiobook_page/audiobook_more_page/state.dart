import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class AudiobookMoreState implements Cloneable<AudiobookMoreState> {
  TabController tabController = TabController(
    length: 0,
    vsync: ScrollableState(),
  );
  var typeTabs = <String>[];
  @override
  AudiobookMoreState clone() {
    return AudiobookMoreState()
      ..tabController = tabController
      ..typeTabs = typeTabs;
  }
}

AudiobookMoreState initState(Map<String, dynamic> args) {
  return AudiobookMoreState();
}
