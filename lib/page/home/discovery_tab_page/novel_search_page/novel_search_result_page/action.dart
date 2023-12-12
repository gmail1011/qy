import 'package:fish_redux/fish_redux.dart';

enum NovelSearchResultAction { onSubmitted, setKeywords }

class NovelSearchResultActionCreator {
  static Action onSubmitted(String text) {
    return Action(NovelSearchResultAction.onSubmitted, payload: text);
  }

  static Action setKeywords(String text) {
    return Action(NovelSearchResultAction.setKeywords, payload: text);
  }
}
