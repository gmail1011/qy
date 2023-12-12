import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/local_server/local_server.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'ys_audio_player.dart';

class AudioPlayerWidget extends StatefulWidget {
  // 播放的地址
  final String url;
  final PlayerMode mode;
  final Widget title;
  // 起始播放位置
  final Duration startDuration;
  final VoidCallback prevClick, nextClick;
  final Widget leftChild, rightChild;
  final AsyncValueGetter<bool> shouldPlay;
  // dispose 前的回调;
  final ValueChanged<AudioPosUpdate> onPosUpdate;

  final ValueChanged<AudioPlayerState> onStateChange;
  final ValueChanged<YsAudioPlayer> onInit;

  const AudioPlayerWidget(
      {Key key,
      @required this.url,
      this.mode = PlayerMode.MEDIA_PLAYER,
      this.startDuration = Duration.zero,
      this.leftChild,
      this.rightChild,
      this.prevClick,
      this.nextClick,
      this.title,
      this.onStateChange,
      this.shouldPlay,
      this.onPosUpdate,
      this.onInit})
      : super(key: key);
  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  String url;
  PlayerMode mode;
  bool loop = false;

  YsAudioPlayer _audioPlayer;
  // 播放器内部状态
  AudioPlayerState _audioPlayerState;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  StreamSubscription<Duration> _durationSubscription;
  StreamSubscription<Duration> _positionSubscription;
  StreamSubscription<void> _playerCompleteSubscription;
  StreamSubscription<String> _playerErrorSubscription;
  StreamSubscription<AudioPlayerState> _playerStateSubscription;
  StreamSubscription<PlayerControlCommand> _playerControlCommandSubscription;
  DateTime lastUpdateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  @override
  void didUpdateWidget(covariant AudioPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    l.i("audioPlayer", "old:${oldWidget.url} new:${widget.url}");
    if (oldWidget.url != widget.url) {
      () async {
        await _releasePlayer();
        if (mounted) setState(() {});
        _initPlayer();
        if (mounted) setState(() {});
      }();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _releasePlayer();
  }

  void _initPlayer() {
    loop = false;
    url = widget.url;
    url = CacheServer().getLocalUrl(url);
    // url = "https://yuan.dhuqh.com/novel/audio/307/2tl/2lv/qc/fcd635435b6a1b201533734e834437c6.mp3";
    _audioPlayer = getUniqueAudioPlayer();
    _position = widget.startDuration;
    // 音频时长
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      // l.i('audioPlayer', 'duration update');
      if (mounted) setState(() => _duration = duration);
      // if(Platform.isIOS){
      //   _audioPlayer.startHeadlessService();
      // }
    });
    // 音频位置
    _positionSubscription = _audioPlayer.onAudioPositionChanged.listen((p) {
      // l.i('audioPlayer', 'position update');
      if (mounted) setState(() => _position = p);
      if (DateTime.now().difference(lastUpdateTime).inSeconds > 3) {
        lastUpdateTime = DateTime.now();
        widget.onPosUpdate?.call(AudioPosUpdate(_position, _duration));
      }
    });
    // 播放完成
    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      if (mounted)
        setState(() {
          l.i('audioPlayer', 'completion');
          // _position = _duration;
          _position = Duration.zero;
        });
    });
    // 错误
    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      l.e('audioPlayer', 'error hanppend: $msg');
      if (mounted)
        setState(() {
          // _playerState = PlayerState.stopped;
          _duration = Duration.zero;
          _position = Duration.zero;
        });
    });
    _playerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted)
        setState(() {
          l.i('audioPlayer', 'state update:$state');
          _audioPlayerState = state;
          widget.onStateChange?.call(state);
        });
    });
    // 指令
    _playerControlCommandSubscription =
        _audioPlayer.onPlayerCommand.listen((command) {
      // print('command');
    });
    // 状态
    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      l.i('audioPlayer', 'notify state update:$state');
      if (mounted) setState(() => _audioPlayerState = state);
    });
    // 自动播放
    _play();
    widget.onInit?.call(_audioPlayer);
  }

  _releasePlayer() async {
    await _audioPlayer?.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _playerControlCommandSubscription?.cancel();
  }

  Future<int> _play([bool isClick = false]) async {
    l.i("audioPlayer", "_play()...url:$url");
    if (isClick) {
      bool shouldPlay = await widget.shouldPlay?.call();
      if (null == shouldPlay || !shouldPlay) return -1;
    }
    if (TextUtil.isEmpty(url)) return -1;
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result = await _audioPlayer.play(url, position: playPosition);
    // if (result == 1) setState(() => _playerState = PlayerState.playing);

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    _audioPlayer.setPlaybackRate(playbackRate: 1.0);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(AppPaddings.appMargin), //h:32
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: Dimens.pt20,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.title ?? Container(),
                  // Text("title"),
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {
                      if (ClickUtil.isFastClick()) return;
                      setState(() {
                        loop = !loop;
                        _audioPlayer?.setReleaseMode(
                            loop ? ReleaseMode.LOOP : ReleaseMode.STOP);
                        if (loop) {
                          showToast(
                              msg: "循环已开启", toastLength: Toast.LENGTH_SHORT);
                        } else {
                          showToast(
                              msg: "循环已关闭", toastLength: Toast.LENGTH_SHORT);
                        }
                      });
                    },
                    child: ImageLoader.withP(ImageType.IMAGE_ASSETS,
                            address: loop
                                ? AssetsImages.ICON_LOOP
                                : AssetsImages.ICON_NOT_LOOP)
                        .load(),
                  ),
                  SizedBox(width: AppPaddings.padding8),
                ],
              ),
            ),
            SizedBox(height: AppPaddings.padding8),
            Row(
              children: [
                Text(buildMMSS(_position?.inSeconds ?? 0),
                    style: TextStyle(fontSize: 10.0, color: Colors.white)),
                Expanded(
                  child: Container(
                    height: 10,
                    child: SliderTheme(
                      data: SliderThemeData(
                          thumbColor: Colors.white,
                          thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 5, pressedElevation: 1),
                          trackHeight: 1.0,
                          activeTickMarkColor: Colors.white,
                          activeTrackColor: Colors.white,
                          inactiveTrackColor:
                              Color.fromRGBO(150, 150, 150, 0.6)),
                      child: Slider(
                        onChanged: (v) {
                          final position = v * _duration.inMilliseconds;
                          _audioPlayer
                              .seek(Duration(milliseconds: position.round()));
                        },
                        value: (_position != null &&
                                _duration != null &&
                                _position.inMilliseconds > 0 &&
                                _position.inMilliseconds <
                                    _duration.inMilliseconds)
                            ? _position.inMilliseconds /
                                _duration.inMilliseconds
                            : 0.0,
                      ),
                    ),
                  ),
                ),
                Text(buildMMSS(_duration?.inSeconds ?? 0),
                    style: TextStyle(fontSize: 10.0, color: Colors.white)),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.leftChild ?? Container(),
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: widget.prevClick,
                      iconSize: 32.0,
                      icon: Icon(Icons.skip_previous, color: Colors.white),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: _buildPlayBtn(),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: widget.nextClick,
                      iconSize: 32.0,
                      icon: Icon(Icons.skip_next, color: Colors.white),
                    ),
                  ],
                ),
                widget.rightChild ?? Container()
              ],
            ),
          ],
        ));
  }

  Widget _buildPlayBtn() {
    return _audioPlayerState == AudioPlayerState.PLAYING
        ? IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              _audioPlayer?.pause();
            },
            iconSize: 42.0,
            icon: Icon(Icons.pause, color: Colors.white),
          )
        : IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              _play(true);
            },
            iconSize: 42.0,
            icon: Icon(Icons.play_arrow, color: Colors.white),
          );
  }
}
