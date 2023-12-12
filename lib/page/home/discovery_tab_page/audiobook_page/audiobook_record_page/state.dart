import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class AudiobookRecordState implements Cloneable<AudiobookRecordState> {
  TabController tabController = TabController(
    length: 3,
    vsync: ScrollableState(),
  );
  TabController tabController1 = TabController(
    length: 2,
    vsync: ScrollableState(),
  );
  @override
  AudiobookRecordState clone() {
    return AudiobookRecordState()
      ..tabController = tabController
      ..tabController1 = tabController1;
  }
}

AudiobookRecordState initState(Map<String, dynamic> args) {
  return AudiobookRecordState();
}
