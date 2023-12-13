import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/widget/chewie/utils.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:video_player/video_player.dart';

import 'chewie_player.dart';
import 'chewie_progress_colors.dart';
import 'material_progress_bar.dart';

///长视频播放器
class FilmVideoControls extends StatefulWidget {
  FilmVideoControls({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FilmVideoControlsState();
  }
}

class _FilmVideoControlsState extends State<FilmVideoControls>
    with SingleTickerProviderStateMixin {
  VideoPlayerValue _latestValue;
  double _latestVolume;
  bool _hideStuff = true;
  Timer _hideTimer;
  Timer _initTimer;
  Timer _showAfterExpandCollapseTimer;
  bool _dragging = false;
  bool _displayTapped = false;

  final barHeight = 40.0;
  final marginSize = 5.0;

  VideoPlayerController controller;
  ChewieController chewieController;
  AnimationController playPauseIconAnimationController;

  Duration seekPos;
  bool _controllerWasPlaying = false;
  bool showSeekText = false;

  void seekToAbsolutePosition(Offset delta) {
    if (seekPos == null || controller == null) return;
    seekPos = seekPos + Duration(milliseconds: 800) * delta.dx;
    if (seekPos < Duration()) {
      seekPos = Duration();
    } else if (seekPos > controller.value.duration) {
      seekPos = controller.value.duration;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_latestValue.hasError) {
      return chewieController.errorBuilder != null
          ? chewieController.errorBuilder(
              context,
              chewieController.videoPlayerController.value.errorDescription,
            )
          : Container();
    }
    Duration showDuration;
    if (seekPos != null) {
      showDuration = seekPos;
    } else {
      showDuration = controller.value.position ?? Duration.zero;
    }
    return MouseRegion(
      onHover: (_) {
        _cancelAndRestartTimer();
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _cancelAndRestartTimer();
        },
        onHorizontalDragStart: (DragStartDetails details) {
          if (controller == null) return;
          if (controller.value.initialized != true) {
            return;
          }
          _controllerWasPlaying = controller.value.isPlaying;
          if (_controllerWasPlaying) {
            controller.pause();
          }
          setState(() {
            seekPos = controller.value.position;
            showSeekText = true;
          });
        },
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          if (controller == null) return;
          if (controller.value.initialized != true) {
            return;
          }
          seekToAbsolutePosition(details.delta);
        },
        onHorizontalDragEnd: (DragEndDetails details) async {
          if (controller == null) return;
          await controller.seekTo(seekPos);
          seekPos = null;
          if (_controllerWasPlaying) {
            controller.play();
          }
          showSeekText = false;
          setState(() {});
          _cancelAndRestartTimer();
        },
        onHorizontalDragCancel: () {
          showSeekText = false;
          setState(() {});
          _cancelAndRestartTimer();
        },
        child: AbsorbPointer(
          absorbing: _hideStuff,
          child:Container(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Column(
                    children: <Widget>[
                      _buildBackButton(context),
                      Spacer(),
                      controller.value.isPlaying
                          ? _buildPlayAndPauseUI()
                          : Center(child: _buildPlayUI()),
                      Spacer(),
                      _buildBottomBar(context),
                    ],
                  ),
                  if (showSeekText)
                    Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.width / 3),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0x7f000000),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  DateTimeUtil.formatDuration(showDuration),
                                  style: TextStyle(
                                    color: Color(0xccffffff),
                                    fontSize: 18,
                                  ),
                                ),
                                if (controller != null)
                                  Text(
                                    '/' +
                                        DateTimeUtil.formatDuration(
                                            controller.value.duration),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                ],
              )
          ),
        ),
      ),
    );
  }

  GestureDetector _buildPlayAndPauseUI() {
    return GestureDetector(
      onTap: () {
        _playPause();
      },
      child: Container(color: Colors.transparent, height: 80),
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    controller.removeListener(_updateState);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
  }

  @override
  void didChangeDependencies() {
    final _oldController = chewieController;
    chewieController = ChewieController.of(context);
    controller = chewieController.videoPlayerController;

    playPauseIconAnimationController ??= AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 400),
    );

    if (_oldController != chewieController) {
      _dispose();
      _initialize();
    }
    super.didChangeDependencies();
  }

  AnimatedOpacity _buildBottomBar(
    BuildContext context,
  ) {
    final iconColor = Theme.of(context).textTheme.button.color;

    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: barHeight,
        color: Colors.black.withOpacity(0.3),
        child: Row(
          children: <Widget>[
            _buildPlayPause(controller),
            if (chewieController.isLive)
              const Expanded(child: Text('LIVE'))
            else
              _buildPosition(iconColor, false),
            if (chewieController.isLive)
              const SizedBox()
            else
              _buildProgressBar(),
            if (chewieController.isLive)
              const Expanded(child: Text('LIVE'))
            else
              _buildPosition(iconColor, true),
            // if (chewieController.allowPlaybackSpeedChanging)
            //   _buildSpeedButton(controller),
          //  if (chewieController.allowMuting) _buildMuteButton(controller),
            if (chewieController.allowFullScreen) _buildExpandButton(),
          ],
        ),
      ),
    );
  }

  AnimatedOpacity _buildBackButton(
    BuildContext context,
  ) {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: barHeight,
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(left: 8, top: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(32),
          ),
          child: InkWell(
            child: Image.asset("assets/images/video_back.png", width: 24, height: 24,),
            onTap: () {
              if (chewieController.isFullScreen) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown
                ]);
                _onExpandCollapse();
              } else {
                Config.hasVideoAd = false;
                safePopPage();
              }
            },
          ),
        ),
      ),
    );
  }

  GestureDetector _buildExpandButton() {
    return GestureDetector(
      onTap: _onExpandCollapse,
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          height: barHeight,
          margin: const EdgeInsets.only(right: 8.0),
          padding: const EdgeInsets.only(
            left: 4.0,
            right: 4.0,
          ),
          child: Center(
            child: Icon(
              chewieController.isFullScreen
                  ? Icons.fullscreen_exit
                  : Icons.fullscreen,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildMuteButton(
    VideoPlayerController controller,
  ) {
    return GestureDetector(
      onTap: () {
        _cancelAndRestartTimer();

        if (_latestValue.volume == 0) {
          controller.setVolume(_latestVolume ?? 0.5);
        } else {
          _latestVolume = controller.value.volume;
          controller.setVolume(0.0);
        }
      },
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: ClipRect(
          child: Container(
            height: barHeight,
            padding: const EdgeInsets.only(
              left: 4.0,
              right: 4.0,
            ),
            child: Icon(
              (_latestValue != null && _latestValue.volume > 0)
                  ? Icons.volume_up
                  : Icons.volume_off,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildPlayPause(VideoPlayerController controller) {
    return GestureDetector(
      onTap: _playPause,
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        margin: const EdgeInsets.only(left: 8.0, right: 1),
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 4.0,
        ),
        child: Icon(
          controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPosition(Color iconColor, bool isAll) {
    final position = _latestValue != null && _latestValue.position != null
        ? _latestValue.position
        : Duration.zero;
    final duration = _latestValue != null && _latestValue.duration != null
        ? _latestValue.duration
        : Duration.zero;

    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Text(
          isAll ?  '${formatDuration(duration)}' : '${formatDuration(position)}',
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.white,
        ),
      ),
    );
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      _hideStuff = false;
      _displayTapped = true;
    });
  }

  Future<void> _initialize() async {
    controller.addListener(_updateState);

    _updateState();

    if ((controller.value != null && controller.value.isPlaying) ||
        chewieController.autoPlay) {
      _startHideTimer();
    }

    if (chewieController.showControlsOnInitialize) {
      _initTimer = Timer(const Duration(milliseconds: 200), () {
        setState(() {
          _hideStuff = false;
        });
      });
    }
  }

  void _onExpandCollapse() {
    /*if(chewieController.isFullScreen){
      chewieController.exitFullScreen();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      //chewieController.videoPlayerController.dispose();
      //chewieController.dispose();
      //Navigator.of(context,).pop();
    }else{
      chewieController.enterFullScreen();
    }*/
    if(Config.hasVideoAd) {
      return;
    }
    setState(() {
      _hideStuff = true;
      chewieController.toggleFullScreen();
      _showAfterExpandCollapseTimer =
          Timer(const Duration(milliseconds: 300), () {
        setState(() {
          _cancelAndRestartTimer();
        });
      });
    });
  }

  void _playPause() {
    bool isFinished;
    if (_latestValue.duration != null) {
      isFinished = _latestValue.position >= _latestValue.duration;
    } else {
      isFinished = false;
    }

    setState(() {
      if (controller.value.isPlaying) {
        playPauseIconAnimationController.reverse();
        _hideStuff = false;
        _hideTimer?.cancel();
        controller.pause();
      } else {
        _cancelAndRestartTimer();

        if (!controller.value.initialized) {
          controller.initialize().then((_) {
            controller.play();
            playPauseIconAnimationController.forward();
          });
        } else {
          if (isFinished) {
            controller.seekTo(const Duration());
          }
          playPauseIconAnimationController.forward();
          controller.play();
        }
      }
    });
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  void _updateState() {
    if (mounted) {
      setState(() {
        _latestValue = controller.value;
      });
    }
  }

  Widget _buildProgressBar() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: MaterialVideoProgressBar(
          controller,
          onDragStart: () {
            setState(() {
              _dragging = true;
            });

            _hideTimer?.cancel();
          },
          onDragEnd: () {
            setState(() {
              _dragging = false;
            });

            _startHideTimer();
          },
          colors: chewieController.materialProgressColors ??
              ChewieProgressColors(
                  playedColor: AppColors.primaryTextColor,
                  handleColor: AppColors.primaryTextColor,
                  bufferedColor: Colors.grey,
                  backgroundColor: Colors.white),
        ),
      ),
    );
  }

  GestureDetector _buildPlayUI() {
    return GestureDetector(
      onTap: () {
        _playPause();
      },
      child: Image(
        image: AssetImage(AssetsImages.ICON_FILM_VIDEO_PLAY),
        width: 59,
        height: 59,
      ),
    );
  }
}

class _PlaybackSpeedDialog extends StatelessWidget {
  const _PlaybackSpeedDialog({
    Key key,
    @required List<double> speeds,
    @required double selected,
  })  : _speeds = speeds,
        _selected = selected,
        super(key: key);

  final List<double> _speeds;
  final double _selected;

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Theme.of(context).primaryColor;

    return Container(
      color: Colors.white,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          final _speed = _speeds[index];
          return ListTile(
            dense: true,
            title: Row(
              children: [
                if (_speed == _selected)
                  Icon(
                    Icons.check,
                    size: 20.0,
                    color: selectedColor,
                  )
                else
                  Container(width: 20.0),
                const SizedBox(width: 16.0),
                Text(_speed.toString()),
              ],
            ),
            selected: _speed == _selected,
            onTap: () {
              Navigator.of(context).pop(_speed);
            },
          );
        },
        itemCount: _speeds.length,
      ),
    );
  }
}
