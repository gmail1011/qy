
import 'package:flutter/material.dart';

List<int> indexList = List();

class VisibilityState {
  const VisibilityState({this.firstIndex, this.lastIndex});

  final int firstIndex;
  final int lastIndex;

}

class ChangeSet {
  final List<int> exposure = [];
  final List<int> hidden = [];

  bool get empty => exposure.length == 0 && hidden.length == 0;
}

class VisibilityMonitor {
  VisibilityState lastState;

  addSequenceToList(List<int> list, int sequenceStart, int sequenceEnd) {
    if (sequenceStart <= sequenceEnd) {
      for (var i = sequenceStart; i <= sequenceEnd; i++) {
        list.add(i);
      }
    } else {
      for (var i = sequenceEnd; i >= sequenceStart; i--) {
        list.add(i);
      }
    }
  }

  update(VisibilityState newState) {
    if (lastState != null &&
        newState.firstIndex == lastState.firstIndex &&
        newState.lastIndex == lastState.lastIndex) {
      return;
    }

    final changeSet = ChangeSet();

    if (lastState == null) {
      addSequenceToList(
          changeSet.exposure, newState.firstIndex, newState.lastIndex);
    } else if (newState.firstIndex > lastState.lastIndex) {
      addSequenceToList(
          changeSet.exposure, newState.firstIndex, newState.lastIndex);
      addSequenceToList(
          changeSet.hidden, lastState.firstIndex, lastState.lastIndex);
    } else if (newState.lastIndex < lastState.firstIndex) {
      addSequenceToList(
          changeSet.exposure, newState.lastIndex, newState.firstIndex);
      addSequenceToList(
          changeSet.hidden, lastState.lastIndex, lastState.firstIndex);
    } else {
      if (newState.firstIndex < lastState.firstIndex) {
        addSequenceToList(
            changeSet.exposure, lastState.firstIndex - 1, newState.firstIndex);
      }

      if (newState.firstIndex > lastState.firstIndex) {
        addSequenceToList(
            changeSet.hidden, lastState.firstIndex, newState.firstIndex - 1);
      }

      if (newState.lastIndex > lastState.lastIndex) {
        addSequenceToList(
            changeSet.exposure, lastState.lastIndex + 1, newState.lastIndex);
      }

      if (newState.lastIndex < lastState.lastIndex) {
        addSequenceToList(
            changeSet.hidden, lastState.lastIndex, newState.lastIndex + 1);
      }
    }

    lastState = newState;

    if (!changeSet.empty) {
      changeSet.exposure.forEach((i) {
        // print('第 $i 张卡片曝光了');
        indexList.add(i);
      });
    }
  }
}

class MySliverChildBuilderDelegate extends SliverChildBuilderDelegate {
  MySliverChildBuilderDelegate(
    Widget Function(BuildContext, int) builder, {
    int childCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
  }) : super(builder,
            childCount: childCount,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,);

  final visibilityMonitor = VisibilityMonitor();

  @override
  void didFinishLayout(int firstIndex, int lastIndex) {
    visibilityMonitor.update(VisibilityState(
      firstIndex: firstIndex,
      lastIndex: lastIndex,
    ));
  }
}

List <int> currentVisibleItem(int index){
  if (indexList.contains(index)){
    indexList.remove(index);
  }
  indexList.insert(0,index);
  return indexList;
}
List<int> getList(){
  return indexList;
}