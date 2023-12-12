import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/widget/chewie/utils.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;
import 'chewie_player.dart';
import 'chewie_progress_colors.dart';
import 'material_progress_bar.dart';

class MaterialControls extends StatefulWidget {
  const MaterialControls({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MaterialControlsState();
  }
}

class _MaterialControlsState extends State<MaterialControls>
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
          : const Center(
              child: Icon(
                Icons.error,
                color: Colors.white,
                size: 42,
              ),
            );
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
        onTap: () => _cancelAndRestartTimer(),
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
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: <Widget>[
                  if (_latestValue != null &&
                      !_latestValue.isPlaying &&
                      _latestValue.duration == null ||
                      _latestValue.isBuffering)
                    const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                  // _buildHitArea(),
                    Spacer(),


                  AnimatedOpacity(
                    opacity: _hideStuff ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        //_buildSkipBack(Colors.white, barHeight),

                        //_buildSkipForward(Colors.white, barHeight),
                      ],
                    ),
                  ),

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
    );
  }


  GestureDetector _buildSkipBack(Color iconColor, double barHeight) {
    return GestureDetector(
      onTap: _skipBack,
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        margin: const EdgeInsets.only(left: 10.0),
        padding: const EdgeInsets.only(
          left: 6.0,
          right: 6.0,
        ),
        child: Icon(
          CupertinoIcons.gobackward_15,
          color: iconColor,
          size: 38.0,
        ),
      ),
    );
  }

  GestureDetector _buildSkipForward(Color iconColor, double barHeight) {
    return GestureDetector(
      onTap: _skipForward,
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        padding: const EdgeInsets.only(
          left: 6.0,
          right: 8.0,
        ),
        margin: const EdgeInsets.only(
          right: 8.0,
        ),
        child: Icon(
          CupertinoIcons.goforward_15,
          color: iconColor,
          size: 38.0,
        ),
      ),
    );
  }


  void _skipBack() {
    _cancelAndRestartTimer();
    final beginning = const Duration().inMilliseconds;
    final skip =
        (_latestValue.position - const Duration(seconds: 15)).inMilliseconds;
    controller.seekTo(Duration(milliseconds: math.max(skip, beginning)));
  }

  void _skipForward() {
    _cancelAndRestartTimer();
    final end = _latestValue.duration.inMilliseconds;
    final skip =
        (_latestValue.position + const Duration(seconds: 15)).inMilliseconds;
    controller.seekTo(Duration(milliseconds: math.min(skip, end)));
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
        color: Colors.black.withOpacity(0.6),
        child: Row(
          children: <Widget>[
            _buildPlayPause(controller),
            if (chewieController.isLive)
              const Expanded(child: Text('LIVE'))
            else
              _buildPosition(iconColor),
            if (chewieController.isLive)
              const SizedBox()
            else
              _buildProgressBar(),
            if (chewieController.allowPlaybackSpeedChanging)
              _buildSpeedButton(controller),
            if (chewieController.allowMuting) _buildMuteButton(controller),
            if (chewieController.allowFullScreen) _buildExpandButton(),
          ],
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

  Expanded _buildHitArea() {
    final bool isFinished = _latestValue.position >= _latestValue.duration;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_latestValue != null && _latestValue.isPlaying) {
            if (_displayTapped) {
              setState(() {
                _hideStuff = true;
              });
            } else {
              _cancelAndRestartTimer();
            }
          } else {
            _playPause();

            setState(() {
              _hideStuff = true;
            });
          }
        },
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: AnimatedOpacity(
              opacity:
                  _latestValue != null && !_latestValue.isPlaying && !_dragging
                      ? 1.0
                      : 0.0,
              duration: const Duration(milliseconds: 300),
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(48.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: IconButton(
                        icon: isFinished
                            ? const Icon(Icons.replay, size: 32.0,color: Colors.white,)
                            : AnimatedIcon(
                                icon: AnimatedIcons.play_pause,
                                progress: playPauseIconAnimationController,
                                size: 32.0,
                              ),
                        onPressed: () {
                          _playPause();
                        }),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedButton(
    VideoPlayerController controller,
  ) {
    return GestureDetector(
      onTap: () async {
        _hideTimer?.cancel();

        final chosenSpeed = await showModalBottomSheet<double>(
          context: context,
          isScrollControlled: true,
          useRootNavigator: true,
          builder: (context) => _PlaybackSpeedDialog(
            speeds: chewieController.playbackSpeeds,
            selected: _latestValue.playbackSpeed,
          ),
        );

        if (chosenSpeed != null) {
          controller.setPlaybackSpeed(chosenSpeed);

        }

        if (_latestValue.isPlaying) {
          _startHideTimer();
        }
      },
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: ClipRect(
          child: Container(
            height: barHeight,
            padding: const EdgeInsets.only(
             // left: 8.0,
              right: 3.0,
            ),
            child: const Icon(Icons.speed,color: Colors.white,),
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

  Widget _buildPosition(Color iconColor) {
    final position = _latestValue != null && _latestValue.position != null
        ? _latestValue.position
        : Duration.zero;
    final duration = _latestValue != null && _latestValue.duration != null
        ? _latestValue.duration
        : Duration.zero;

    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Text(
        '${formatDuration(position)} / ${formatDuration(duration)}',
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
    if(mounted){
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
                  playedColor: Color.fromRGBO(242, 19, 19, 1),
                  handleColor: Color.fromRGBO(242, 19, 19, 1),
                  bufferedColor: Colors.grey,
                  backgroundColor: Colors.white),
        ),
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
