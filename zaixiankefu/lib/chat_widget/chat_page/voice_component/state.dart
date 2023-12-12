import 'package:fish_redux/fish_redux.dart';

class VoiceState implements Cloneable<VoiceState> {
  String voiceContent;
  @override
  VoiceState clone() {
    return VoiceState()
    ..voiceContent = voiceContent;
  }
}

VoiceState initState(Map<String, dynamic> args) {
  return VoiceState();
}
