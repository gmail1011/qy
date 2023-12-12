import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/local_store/local_audio_store.dart';
import 'package:flutter_app/model/audiobook_model.dart';
import 'package:flutter_app/page/audio_novel_page/rotate_image.dart';
import 'package:rive/rive.dart';

class AudioNovelState implements Cloneable<AudioNovelState> {
  // String url = "https://luan.xyz/files/audio/ambient_c_motion.mp3";
  // 加密测试的url
  // String url =
  //     "http://192.168.1.160:8090/novel/audio/1or/320/1dw/ex/72fd1fe0f5d29efe10bbea841744c6de.mp3";
  String url;
  Artboard riveArtboard;
  RiveAnimationController riveController;
  GlobalKey<RotateImageState> imageKey = GlobalKey();
  // 书名id
  String id;
  // 书名实体
  AudioBook audioBook;
  // 当前播放的第几集
  // EpisodeModel curEpisode; 使用id代替bean
  int episodeNumber = 0;
  // 当前播放的第几集查出来的历史播放记录
  AudioEpisodeRecord record;

  List<AudioBook> recommendList;

  @override
  AudioNovelState clone() {
    return AudioNovelState()
      ..url = url
      ..id = id
      ..imageKey = imageKey
      ..riveController = riveController
      ..riveArtboard = riveArtboard
      ..recommendList = recommendList
      // ..curEpisode = curEpisode
      ..episodeNumber = episodeNumber
      ..record = record
      ..audioBook = audioBook;
  }
}

AudioNovelState initState(Map<String, dynamic> args) {
  var state = AudioNovelState();
  if (args != null) {
    state.id = args['id'] ?? "";
    state.episodeNumber = args['episodeNumber'] ?? 0;
  }
  return state;
}
