import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/player/ijk_base_video_controler.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'video_progress_colors.dart';

///自定义视频进度控制器
class VPlayerProgress extends StatefulWidget {
  VPlayerProgress(this.controller,
      {VideoProgressColors colors,
      this.allowScrubbing = true,
      this.playHeight,
      this.pauseHeight,
      this.onDrogEnd,
      this.durationInSec = 0})
      : colors = colors ?? VideoProgressColors();

  final IjkBaseVideoController controller;

  final VideoProgressColors colors;

  final bool allowScrubbing;

  final double pauseHeight;

  final double playHeight;

  /// 服务器总共播放时长秒
  final int durationInSec;

  final VoidCallback onDrogEnd;

  @override
  State<StatefulWidget> createState() {
    return _VPlayerProgressState();
  }
}

class _VPlayerProgressState extends State<VPlayerProgress> {
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
  void didUpdateWidget(covariant VPlayerProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    // l.i("progress",
    //     "didUpdateWidget()...oldState:${oldWidget.controller.state} newState:${widget.controller.state}");
    // playerPrint(
    //     "progress didUpdateWidget()...oldState:${oldWidget.controller.currentPos.inMilliseconds} newState:${widget.controller.currentPos.inMilliseconds}");
  }

  @override
  void dispose() {
    super.dispose();
    curPosSub.cancel();
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
        ///非暂停状态展示
        curPos = widget.controller.currentPos;

        Duration maxBuffering = widget.controller.bufferPos;
        // for (DurationRange range in controller.value.buffered) {
        //   final int end = range.end.inMilliseconds;
        //   if (end > maxBuffering) {
        //     maxBuffering = end;
        //   }
        // }
        progressIndicator = Container(
          height: widget.playHeight ?? Dimens.pt0_6,
          child: Stack(
            fit: StackFit.passthrough,
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
          child: IgnorePointer(
            child: _VideoSlider(sliderValue, colors: colors),
          ),
        );
      }
    } else {
      progressIndicator = Container(
        height: widget.playHeight ?? Dimens.pt0_6,
        child: LinearProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(colors.playedColor),
          backgroundColor: colors.backgroundColor,
        ),
      );
    }
    // int startTime = widget.controller?.currentPos?.inSeconds ?? 0;
    int startTime = curPos?.inSeconds ?? 0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Visibility(
          visible: durationInSec > 0,
          child: Container(
            padding: EdgeInsets.only(right: 6, left: 6),
            child: Text(
              buildMMSS(startTime),
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
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
                    controller: widget.controller)
                : progressIndicator),
        Visibility(
          visible: durationInSec > 0,
          child: Container(
            padding: EdgeInsets.only(right: 6, left: 6),
            child: Text(
              buildMMSS(durationInSec),
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class _VideoScrubber extends StatefulWidget {
  final Widget child;
  final IjkBaseVideoController controller;
  final ValueChanged<Duration> onDragUpdate;
  _VideoScrubber(
      {@required this.child, @required this.controller, this.onDragUpdate});

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
    final double relative = tapPos.dx / box.size.width;
    position = widget.controller.value.duration * relative;
    currentPosition = _timeConvertStr(position);
    totalPosition = _timeConvertStr(widget.controller.value.duration);
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 1,
          child: isDragging
              ? Center(
                  child: Container(
                    height: Dimens.pt40,
                    width: Dimens.pt180,
                    color: Color(0x80000000),
                    child: Center(
                      child: Text(
                        "$currentPosition / $totalPosition",
                        style: TextStyle(
                            fontSize: Dimens.pt20, color: Color(0xffdddddd)),
                      ),
                    ),
                  ),
                )
              : Container(),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
              // color: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: Dimens.pt6),
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
            if (_controllerWasPlaying) {
              widget.controller.start();
            }
            setState(() {
              isDragging = false;
            });
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
          activeTrackColor: colors?.playedColor ?? Colors.white,
          //进度条滑块左边颜色
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
