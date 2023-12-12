import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_store/local_audio_store.dart';
import 'package:flutter_app/widget/common_widget/pull_refresh_view.dart';

class AudioEpisodeRecordState implements Cloneable<AudioEpisodeRecordState> {
  List<AudioEpisodeRecord> list;
  PullRefreshController pullRefreshController = PullRefreshController();
  @override
  AudioEpisodeRecordState clone() {
    return AudioEpisodeRecordState()
      ..list = list
      ..pullRefreshController = pullRefreshController;
  }
}

AudioEpisodeRecordState initState(Map<String, dynamic> args) {
  return AudioEpisodeRecordState();
}
