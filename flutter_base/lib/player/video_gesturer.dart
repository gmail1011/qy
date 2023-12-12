import 'package:flutter/material.dart';
import 'package:flutter_base/flutter_base.dart';

/// 视频手势
class VideoGesturer extends StatefulWidget {
  final double width;
  final double height;
  final IjkBaseVideoController controller;

  final VoidCallback onDragStart;
  final VoidCallback onDragEnd;

  /// 非滑动时候的child
  final Widget child;
  const VideoGesturer({
    Key key,
    this.width,
    this.height,
    this.controller,
    this.onDragStart,
    this.onDragEnd,
    this.child,
  }) : super(key: key);
  @override
  _VideoGesturerState createState() => _VideoGesturerState();
}

class _VideoGesturerState extends State<VideoGesturer> {
  DragStartDetails startDetails;
  double dx = .0;
  @override
  Widget build(BuildContext context) {
    if (widget.controller?.isDisposed ?? true) {
      return Container();
    } else {
      var seconds =
          widget.controller.currentPos.inSeconds + _getDiffDx(dx.round());
      if (seconds <= 0) {
        seconds = 0;
      } else if (seconds > widget.controller.value.duration.inSeconds) {
        seconds = widget.controller.value.duration.inSeconds;
      }
      return Listener(
        behavior: HitTestBehavior.deferToChild,
        child: Container(
          width: widget.width,
          height: widget.height,
          alignment: Alignment.center,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragStart: (details) {
              widget.onDragStart?.call();
              setState(() {
                startDetails = details;
              });
            },
            onHorizontalDragUpdate: (details) {
              if (startDetails == null) return;
              setState(() {
                dx = details.globalPosition.dx - startDetails.globalPosition.dx;
              });
            },
            onHorizontalDragEnd: (details) {
              widget.onDragEnd?.call();
              widget.controller.isFullScreen;
              var seconds = widget.controller.currentPos.inSeconds +
                  _getDiffDx(dx.round());
              if (seconds <= 0) {
                seconds = 0;
              } else if (seconds > widget.controller.value.duration.inSeconds) {
                seconds = widget.controller.value.duration.inSeconds;
              }
              widget.controller.seekTo(seconds * 1000);
              setState(() {
                startDetails = null;
              });
            },
            child: Container(
              width: widget.width,
              // color: Colors.blue,
              height: Dimens.pt100,
              alignment: Alignment.center,
              child: null != startDetails
                  ? Column(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  width: 100,
                                  padding: EdgeInsets.only(top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(dx >= 0 ? "快进" : "快退",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            Icon(
                                                dx >= 0
                                                    ? Icons.fast_forward
                                                    : Icons.fast_rewind,
                                                color: Colors.white)
                                          ]),
                                      // 直接加的意义就是一个像素点1秒
                                      Text(buildHHMMSS(seconds),
                                          style:
                                              TextStyle(color: Colors.white)),
                                      Text(
                                          buildHHMMSS(widget.controller?.value
                                                  ?.duration?.inSeconds ??
                                              0),
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  : (widget.child ?? Container()),
            ),
          ),
        ),
      );
    }
  }
}

/// 扩大等级
const int _DIFF_GRADE = 30;

/// 根据查分扩大dx倍数
/// <=100 ;<=100
/// 120;=>100*1+20*2
/// 220;=>100*1+100*2+20*3
/// 320;=>100*1+100*2+100*3+20*4
/// 420;=>100*1+100*2+100*3+100*4+20*5
/// Sn=n*a1+n(n-1)d/2 等差求和公式
int _getDiffDx(int dx, [bool isFullScreen = false]) {
  int _diffGrade = isFullScreen ? (_DIFF_GRADE * 2) : _DIFF_GRADE;
  var n = dx.abs() ~/ _diffGrade;
  var mod = dx.abs() % _diffGrade;
  // var sum = n * _diffGrade + n * (n - 1) * _diffGrade / 2;
  var sum = n * (n + 1) * _diffGrade ~/ 2 + mod * (n + 1);
  if (dx >= 0)
    return sum;
  else
    return sum * (-1);
}
