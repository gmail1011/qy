import 'package:audioplayers/audioplayers.dart';

YsAudioPlayer curAudioPlayer;

class YsAudioPlayer extends AudioPlayer {
  bool isDispose = false;
  // dispose 前的回调;

  YsAudioPlayer();
  @override
  Future<void> dispose() {
    isDispose = true;
    return super.dispose();
  }
}

class AudioPosUpdate {
  Duration pos = Duration.zero;
  Duration duration = Duration.zero;
  AudioPosUpdate(this.pos, this.duration);
}

// 获取唯一的音频播放控制器
YsAudioPlayer getUniqueAudioPlayer() {
  if (null != curAudioPlayer && !curAudioPlayer.isDispose) {
    curAudioPlayer.dispose();
    curAudioPlayer = null;
  }
  curAudioPlayer = YsAudioPlayer();
  return curAudioPlayer;
}
