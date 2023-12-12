import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_store/local_audio_store.dart';
import 'package:flutter_app/model/audiobook_model.dart';

enum AudioNovelAction {
  refresh,
  loadData,
  playAudioEpisode,
  getAudioBookOkay,
  onClickPlayList,
  buyVip,
  buyAudio,
  collectAudioBook,
  collectAnchor,
  refreshCollectAudioBook,
  refreshCollectAnchor,
  setRecommendList,
  getRecordOkay,
}

class AudioNovelActionCreator {
  static Action loadData(String id, int episodeNumber) {
    return Action(AudioNovelAction.loadData,
        payload: {"id": id, "episodeNumber": episodeNumber});
  }

  static Action getRecordOkay(AudioEpisodeRecord record) {
    return Action(AudioNovelAction.getRecordOkay, payload: record);
  }

  static Action setRecommendList(List<AudioBook> list) {
    return Action(AudioNovelAction.setRecommendList, payload: list);
  }

  static Action onClickPlayList() {
    return const Action(AudioNovelAction.onClickPlayList);
  }

  static Action getAudioBookOkay(AudioBook audioBook) {
    return Action(AudioNovelAction.getAudioBookOkay, payload: audioBook);
  }

  static Action buyVip() {
    return Action(AudioNovelAction.buyVip);
  }

  static Action buyAudio(EpisodeModel episode) {
    return Action(AudioNovelAction.buyAudio, payload: episode);
  }

  static Action onRefresh() {
    return const Action(AudioNovelAction.refresh);
  }

  // 收藏
  static Action collectAudioBook() {
    return Action(AudioNovelAction.collectAudioBook);
  }

  static Action collectAnchor() {
    return Action(AudioNovelAction.collectAnchor);
  }

  // 收藏
  static Action refreshCollectAudioBook() {
    return Action(AudioNovelAction.refreshCollectAudioBook);
  }

  static Action refreshCollectAnchor() {
    return Action(AudioNovelAction.refreshCollectAnchor);
  }

  static Action playAudioEpisode(EpisodeModel episode) {
    return Action(AudioNovelAction.playAudioEpisode, payload: episode);
  }
}
