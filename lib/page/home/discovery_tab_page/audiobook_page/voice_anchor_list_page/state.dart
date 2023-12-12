import 'package:fish_redux/fish_redux.dart';

class VoiceAnchorListState implements Cloneable<VoiceAnchorListState> {
  @override
  VoiceAnchorListState clone() {
    return VoiceAnchorListState();
  }
}

VoiceAnchorListState initState(Map<String, dynamic> args) {
  return VoiceAnchorListState();
}
