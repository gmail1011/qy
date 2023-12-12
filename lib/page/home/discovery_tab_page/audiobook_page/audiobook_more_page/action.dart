import 'package:fish_redux/fish_redux.dart';

enum AudiobookMoreAction { setTabs }

class AudiobookMoreActionCreator {
  static Action setTabs(List<String> list) {
    return  Action(AudiobookMoreAction.setTabs,payload: list);
  }
}
