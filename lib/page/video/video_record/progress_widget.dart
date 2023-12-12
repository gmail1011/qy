import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/event/video_recorder_event.dart';
import 'package:flutter_app/utils/global_variable.dart';
import 'package:flutter_base/utils/screen.dart';

typedef RecorderComplete = Function(int time);

// ignore: must_be_immutable
class ProgressWidget extends StatefulWidget {
  int time = 0;
  RecorderComplete recorderComplete;

  // ignore: cancel_subscriptions
  StreamSubscription timeEvent;

  ProgressWidget(this.recorderComplete);

  @override
  State<StatefulWidget> createState() {
    return ProgressWidgetState();
  }
}

class ProgressWidgetState extends State<ProgressWidget> {
  var progress = 0.0;
  Timer timer;

  @override
  void initState() {
    super.initState();
    widget.timeEvent =
        GlobalVariable.eventBus.on<VideoRecorderEvent>().listen((event) {
      if (event.isStartRecorder == 0) {
        ///开始录制
        startCountDownTime(event.timeTag);
      } else if (event.isStartRecorder == 1) {
        ///停止录制
        if (widget.recorderComplete != null) {
          widget.recorderComplete(widget.time);
        }
        timer.cancel();
      } else {
        //重新录制
        if (!mounted) {
          return;
        }
        setState(() {
          progress = 0.0;
        });
      }
    });
  }

  @override
  void dispose() {
    widget?.timeEvent?.cancel();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: Dimens.pt0,
        child: Container(
          width: screen.screenWidth,
          child: LinearProgressIndicator(
            backgroundColor: Colors.black,
            value: progress,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
          ),
        ));
  }

  ///开始计时
  void startCountDownTime(int timeTag) async {
    int timeMax = 0;
    widget.time = 0;
    if (timeTag == 0) {
      timeMax = 60;
    } else {
      timeMax = 300;
    }
    const oneSec = const Duration(seconds: 1);
    var callback = (timer) => {
          timer = timer,
          if (widget.time == timeMax)
            {
              ///然后停止录制
              if (widget.recorderComplete != null)
                {widget.recorderComplete(widget.time)},
              timer.cancel()
            }
          else
            {
              widget.time = widget.time + 1,
              if (mounted)
                {
                  setState(() {
                    progress = (widget.time / timeMax);
                  })
                }
            }
        };
    timer = Timer.periodic(oneSec, callback);
  }
}
