import 'package:fish_redux/fish_redux.dart';

enum SearchResultAction { setKeywords, onSubmitted }

class SearchResultActionCreator {
  static Action setKeywords(String text) {
    return Action(SearchResultAction.setKeywords, payload: text);
  }

  static Action onSubmitted(String text) {
    return Action(SearchResultAction.onSubmitted, payload: text);
  }
}
