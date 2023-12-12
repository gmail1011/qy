import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/fuli_guangchang/bean/task_entity.dart';

class RenWuState implements Cloneable<RenWuState> {

  TaskData taskData;

  @override
  RenWuState clone() {
    return RenWuState()..taskData = taskData;
  }
}

RenWuState initState(Map<String, dynamic> args) {
  return RenWuState();
}
