import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum DiscoveryTabAction {
  onSearchBtm,
  onRecordingBtm,
  onRefreshUI,
  getIndex,
}

class DiscoveryTabActionCreator {
  static Action onRefreshUI() {
    return const Action(DiscoveryTabAction.onRefreshUI);
  }
  static Action onSearchBtm() {
    return const Action(DiscoveryTabAction.onSearchBtm);
  }
  static Action onRecordingBtm() {
    return const Action(DiscoveryTabAction.onRecordingBtm);
  }

  static Action onGetIndex(int index) {
    return Action(DiscoveryTabAction.getIndex,payload: index);
  }
}
