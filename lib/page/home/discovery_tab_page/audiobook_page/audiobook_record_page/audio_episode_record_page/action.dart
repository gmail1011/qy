import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_store/local_audio_store.dart';

//TODO replace with your own action
enum AudioEpisodeRecordAction { setList }

class AudioEpisodeRecordActionCreator {
  static Action setList(List<AudioEpisodeRecord> list) {
    return  Action(AudioEpisodeRecordAction.setList,payload: list);
  }
}
