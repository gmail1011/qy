import 'package:fish_redux/fish_redux.dart';

enum EditSummaryAction {
  editSummary,
  updateUI,
}

class EditSummaryActionCreator {
  static Action editSummary() {
    return const Action(EditSummaryAction.editSummary);
  }

  static Action updateUI() {
    return const Action(EditSummaryAction.updateUI);
  }
}
