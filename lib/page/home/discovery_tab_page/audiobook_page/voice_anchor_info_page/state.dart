import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/audiobook_model.dart';

class VoiceAnchorInfoState implements Cloneable<VoiceAnchorInfoState> {
  Anchor model;
  @override
  VoiceAnchorInfoState clone() {
    return VoiceAnchorInfoState()..model = model;
  }
}

VoiceAnchorInfoState initState(Map<String, dynamic> args) {
  return VoiceAnchorInfoState()..model = args == null ? null : args['model'];
}
