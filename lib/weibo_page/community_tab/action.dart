import 'package:fish_redux/fish_redux.dart';

enum CommunityTabAction { updateUI, updateCommunityList }

class CommunityTabActionCreator {
  static Action updateUI() {
    return const Action(CommunityTabAction.updateUI);
  }

  static Action updateCommunityList(var updateCommunityList) {
    return Action(CommunityTabAction.updateCommunityList,
        payload: updateCommunityList);
  }
}
