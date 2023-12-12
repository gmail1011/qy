import 'package:fish_redux/fish_redux.dart';

enum VoiceAnchorInfoAction { collect, refreshCollect, randomAnchor }

class VoiceAnchorInfoActionCreator {
  static Action collect() {
    return const Action(VoiceAnchorInfoAction.collect);
  }

  static Action refreshCollect() {
    return const Action(VoiceAnchorInfoAction.refreshCollect);
  }

  static Action randomAnchor() {
    return const Action(VoiceAnchorInfoAction.randomAnchor);
  }
}
