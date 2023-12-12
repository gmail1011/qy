import 'package:fish_redux/fish_redux.dart';

enum OfficialCommunityAction { updateUI, }

class OfficialCommunityActionCreator {
  static Action updateUI() {
    return const Action(OfficialCommunityAction.updateUI);
  }
}
