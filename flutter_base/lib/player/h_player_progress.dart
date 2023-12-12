import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/player/ijk_base_video_controler.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'video_progress_colors.dart';

///自定义视频进度控制器
class HPlayerProgress extends StatefulWidget {
  HPlayerProgress(
    this.controller, {
    VideoProgressColors colors,
    this.allowScrubbing = true,
    this.padding,
    this.playHeight,
    this.pauseHeight,
    this.durationInSec = 0,
    this.onDragEnd,
  }) : colors = colors ?? VideoProgressColors();

  /// 托拽结束回调
  final VoidCallback onDragEnd;

  final IjkBaseVideoController controller;

  final VideoProgressColors colors;

  final bool allowScrubbing;

  final EdgeInsets padding;

  final double pauseHeight;

  final double playHeight;

  /// 服务器总共播放时长秒
  final int durationInSec;

  @override
  State<StatefulWidget> createState() {
    return _HPlayerProgressState();
  }
}

class _HPlayerProgressState extends State<HPlayerProgress> {
  // 当前播放位置订阅
  StreamSubscription<Duration> curPosSub;

  VideoProgressColors get colors => widget.colors;
  // double sliderValue = .0;
  Duration duration;
  Duration curPos;
  int durationInSec;

  @override
  void initState() {
    super.initState();
    durationInSec = widget.durationInSec;
    curPosSub = widget.controller.onCurrentPosUpdate.listen((pos) {
      if (mounted) setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant HPlayerProgress oldWidget) {
    // TODO: implement UpdateWidget
    super.didUpdateWidget(oldWidget);
    // l.i("progress",
    //     "UpdateWidget()...oldState:${oldWidget.controller.state} newState:${widget.controller.state}");
    playerPrint(
        "progress didUpdateWidget()...oldState:${oldWidget.controller.currentPos.inMilliseconds} newState:${widget.controller.currentPos.inMilliseconds}");
  }

  @override
  void dispose() {
    super.dispose();
    curPosSub?.cancel();
    curPosSub = null;
  }

  @override
  Widget build(BuildContext context) {
    Widget progressIndicator;
    if (widget.controller.isPlayable()) {
      if (null == duration) {
        duration = widget.controller.value.duration;
        durationInSec = duration.inSeconds;
      }

      if (widget.controller.isPlaying && !widget.controller.isBuffering) {
        // print("playing and is 111");

        ///非暂停状态展示
        curPos = widget.controller.currentPos;
        // print("playing and is not isBuffering $curPos");
        Duration maxBuffering = widget.controller.bufferPos;
        // for (DurationRange range in controller.value.buffered) {
        //   final int end = range.end.inMilliseconds;
        //   if (end > maxBuffering) {
        //     maxBuffering = end;
        //   }
        // }
        progressIndicator = Container(
          height: widget.playHeight ?? Dimens.pt0_6,

          // color: Colors.black,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.loose,
            children: <Widget>[
              //缓存位置
              LinearProgressIndicator(
                value: (maxBuffering?.inMilliseconds ?? 0) /
                    (duration?.inMilliseconds ?? 1),
                valueColor: AlwaysStoppedAnimation<Color>(colors.bufferedColor),
                backgroundColor: colors.backgroundColor,
              ),
              //当前位置
              LinearProgressIndicator(
                value: (curPos?.inMilliseconds ?? 0) /
                    (duration?.inMilliseconds ?? 1),
                valueColor: AlwaysStoppedAnimation<Color>(colors.playedColor),
                backgroundColor: Colors.transparent,
              ),
            ],
          ),
        );
      } else {
        // print("playing and is pause 22222");
        if (null == curPos) {
          // print("playing and is pause 22222 reget curPos");
          curPos = widget.controller.currentPos;
        }

        ///暂停时展示
        double sliderValue =
            ((curPos?.inMilliseconds ?? 0) / (duration?.inMilliseconds ?? 1)) *
                100;
        // print("progress update position:$position  duration:$duration sliderValue:$sliderValue");
        if (sliderValue < 0) {
          sliderValue = 0.0;
        }
        if (sliderValue > 100) {
          sliderValue = 100;
        }
        // l.i("process",
        //     "videoPause curPos:${curPos?.inMilliseconds} $sliderValue ${widget.controller.state} hash:${widget.controller.hashCode}");
        progressIndicator = Container(
          height: widget.pauseHeight ?? Dimens.pt3,
          alignment: Alignment.center,
          child: IgnorePointer(
            child: _VideoSlider(sliderValue, colors: colors),
          ),
        );
      }
    } else {
      // print("playing and is 33333");
      progressIndicator = Container(
        height: widget.playHeight ?? Dimens.pt0_6,
        alignment: Alignment.center,
        child: LinearProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(colors.playedColor),
          backgroundColor: colors.backgroundColor,
        ),
      );
    }
    // int startTime = widget.controller?.currentPos?.inSeconds ?? 0;
    int startTime = curPos?.inSeconds ?? 0;
    // print("playing and is startTime:$startTime");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Visibility(
            visible: durationInSec > 0,
            child: Container(
                // alignment: Alignment.center,
                padding: EdgeInsets.only(right: 6, left: 6),
                child: Text(buildHHMMSS(startTime),
                    style: TextStyle(color: Colors.white, fontSize: 12)))),
        // 视频拖拽
        Expanded(
            child: widget.allowScrubbing
                ? _VideoScrubber(
                    child: progressIndicator,
                    onDragUpdate: (d) {
                      // print("onDragUpdate()...$d");
                      if (mounted)
                        setState(() {
                          curPos = d;
                        });
                    },
                    controller: widget.controller,
                    onDragEnd: widget.onDragEnd)
                : progressIndicator),

        Visibility(
            visible: durationInSec > 0,
            child: Container(
                padding: EdgeInsets.only(right: 6, left: 6),
                // color: Colors.black,
                // alignment: Alignment.center,
                child: Text(buildHHMMSS(durationInSec),
                    style: TextStyle(color: Colors.white, fontSize: 12)))),
      ],
    );
  }
}

class _VideoScrubber extends StatefulWidget {
  final Widget child;
  final IjkBaseVideoController controller;
  final ValueChanged<Duration> onDragUpdate;
  final VoidCallback onDragEnd;
  _VideoScrubber(
      {@required this.child,
      @required this.controller,
      this.onDragUpdate,
      this.onDragEnd});

  @override
  _VideoScrubberState createState() => _VideoScrubberState();
}

class _VideoScrubberState extends State<_VideoScrubber> {
  bool isDragging = false;
  bool _controllerWasPlaying = false;

  String currentPosition, totalPosition;
  Duration position;

  void seekToRelativePosition(Offset globalPosition) {
    // l.i("FUCK", "seekToRelativePosition()...");
    final RenderBox box = context.findRenderObject();
    final Offset tapPos = box.globalToLocal(globalPosition);
    final double relative = tapPos.dx / box.size.width;
    final Duration position = widget.controller.value.duration * relative;
    currentPosition = _timeConvertStr(position);
    totalPosition = _timeConvertStr(widget.controller.value.duration);
    widget.onDragUpdate?.call(position);
    widget.controller.seekTo(position.inMilliseconds);
  }

  Duration calculDuration(Offset globalPosition) {
    // l.i("FUCK", "seekToRelativePosition()...");
    final RenderBox box = context.findRenderObject();
    final Offset tapPos = box.globalToLocal(globalPosition);
    double relative = tapPos.dx / box.size.width;
    if (relative < .0) {
      relative = .0;
    } else if (relative > 1.0) {
      relative = 1.0;
    }
    return widget.controller.value.duration * relative;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Expanded(flex: 1, child: Container()),
        // Flexible(child: Container(), flex: 8),
        // Flexible(
        //   flex: 10,
        // child:
        //  isDragging
        //     ? Text(
        //         '$currentPosition',
        //         style: TextStyle(
        //           color: Colors.black,
        //           backgroundColor: Colors.white.withOpacity(0.3),
        //           fontSize: 12,
        //         ),
        //       )
        //     : Container(),
        // ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: Dimens.pt8),
              // color: Colors.blue,
              child: widget.child),
          onHorizontalDragStart: (DragStartDetails details) {
            if (!widget.controller.isPlayable()) {
              return;
            }
            // l.i("FUCK", "onHorizontalDragStart()...");
            setState(() {
              isDragging = true;
            });
            _controllerWasPlaying = widget.controller.isPlaying;
            if (_controllerWasPlaying) {
              widget.controller.pause();
            }
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            if (!widget.controller.isPlayable()) {
              return;
            }
            // l.i("FUCK", "onHorizontalDragUpdate()...");
            // seekToRelativePosition(details.globalPosition);
            position = calculDuration(details.globalPosition);
            widget.onDragUpdate?.call(position);
          },
          onHorizontalDragEnd: (DragEndDetails details) async {
            // l.i("FUCK", "onHorizontalDragEnd()...");
            setState(() {
              isDragging = false;
            });
            widget.onDragEnd?.call();
            await widget.controller.seekTo(position.inMilliseconds);
            if (_controllerWasPlaying) {
              await Future.delayed(Duration(milliseconds: 300));
              await widget.controller.start();
            }
          },
          onTapUp: (TapUpDetails details) {
            if (!widget.controller.isPlayable()) {
              return;
            }
            // l.i("FUCK", "onTapDown()...");
            // l.i("FUCK", "onHorizontalDragUpdate()...");
            seekToRelativePosition(details.globalPosition);
          },
        ),
      ],
    );
  }

  _timeConvertStr(Duration duration) {
    int second = duration.inSeconds;
    int value = second ~/ 60;
    String minuteStr = value >= 10 ? "$value" : "0$value";
    value = second % 60;
    String secondStr = value >= 10 ? "$value" : "0$value";
    return "$minuteStr:$secondStr";
  }
}

class _VideoSlider extends StatelessWidget {
  final double sliderHeight;

  final double sliderValue;
  final VideoProgressColors colors;

  _VideoSlider(this.sliderValue, {this.sliderHeight, this.colors});

  @override
  Widget build(BuildContext context) {
    Widget slider = SliderTheme(
      //自定义风格
      data: SliderTheme.of(context).copyWith(
          //进度条滑块左边颜色
          activeTrackColor: colors?.playedColor ?? Colors.white,
          inactiveTrackColor: Color.fromRGBO(200, 200, 200, 0.5),
          //进���条滑块右边颜色
          thumbColor: Colors.white,
          //滑块颜色
          overlayColor: Colors.white,
          //滑块拖拽时外圈的颜色
          overlayShape: RoundSliderOverlayShape(
            //可继承SliderComponentShape自定义���状
            overlayRadius: 0, //滑块外圈大小
          ),
          thumbShape: RoundSliderThumbShape(
            //可继承SliderComponentShape自定义形状
            disabledThumbRadius: Dimens.pt4, //禁用是滑块大小
            enabledThumbRadius: Dimens.pt4, //滑块大小
          ),
          inactiveTickMarkColor: Colors.black,
          tickMarkShape: RoundSliderTickMarkShape(
            //继承SliderTickMarkShape可自定义刻度形状
            tickMarkRadius: 4.0, //刻度大小
          ),
          showValueIndicator: ShowValueIndicator.onlyForDiscrete,
          //气泡显示的形式
          valueIndicatorColor: Colors.red,
          //气泡颜色
          valueIndicatorShape: PaddleSliderValueIndicatorShape(),
          //气泡形状
          valueIndicatorTextStyle: TextStyle(color: Colors.black),
          //气泡里值的风格
          trackHeight: Dimens.pt2 //进度条高度

          ),
      child: Slider(
        value: sliderValue,
        onChanged: (v) {
          // print("SlideronChanged()... v$v  sliderValue:$sliderValue");
        },
        //进度条上显示多少个刻度点
        max: 100,
        min: 0,
      ),
    );
    return slider;
  }
}
