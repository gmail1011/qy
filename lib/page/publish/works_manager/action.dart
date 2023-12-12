import 'package:fish_redux/fish_redux.dart';

enum WorksManagerAction { editModel, notifyDel }

class WorksManagerActionCreator {
  static Action changeEditModel(bool isEditModel) {
    return Action(WorksManagerAction.editModel, payload: isEditModel);
  }

  static Action notifyDel() {
    return const Action(WorksManagerAction.notifyDel);
  }
}
