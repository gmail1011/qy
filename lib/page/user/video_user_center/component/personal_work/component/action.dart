import 'package:fish_redux/fish_redux.dart';

enum WorkItemAction { onTapItem }

class WorkItemActionCreator {
  static Action onTapItem(String uniqueId) {
    return Action(WorkItemAction.onTapItem,payload: uniqueId);
  }
}
