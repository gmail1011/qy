import 'package:fish_redux/fish_redux.dart';

enum WishQuestionAction { refreshData, loadMoreData, updateUI }

class WishQuestionActionCreator {
  static Action refreshData() {
    return const Action(WishQuestionAction.refreshData);
  }

  static Action loadMoreData() {
    return const Action(WishQuestionAction.loadMoreData);
  }

  static Action updateUI() {
    return const Action(WishQuestionAction.updateUI);
  }
}
