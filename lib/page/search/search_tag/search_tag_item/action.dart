import 'package:fish_redux/fish_redux.dart';

enum SearchTagItemAction { action }

class SearchTagItemActionCreator {
  static Action onAction() {
    return const Action(SearchTagItemAction.action);
  }
}
