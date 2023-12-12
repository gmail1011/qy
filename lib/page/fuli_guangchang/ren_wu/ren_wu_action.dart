import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/fuli_guangchang/bean/task_entity.dart';

//TODO replace with your own action
enum RenWuAction { action , task}

class RenWuActionCreator {
  static Action onAction() {
    return const Action(RenWuAction.action);
  }

  static Action onTask(TaskData taskData) {
    return Action(RenWuAction.task,payload: taskData);
  }
}
