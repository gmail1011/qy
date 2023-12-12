import 'dart:async';

import 'package:flutter/material.dart';

class TimerCountDownWidget extends StatefulWidget {
  final Function onTimerFinish;
  final Function onTimerStart;

  TimerCountDownWidget({Key key, this.onTimerStart, this.onTimerFinish})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => TimerCountDownWidgetState();
}

class TimerCountDownWidgetState extends State<TimerCountDownWidget> {
  Timer _timer;
  int _countdownTime = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_countdownTime == 0) {
          widget.onTimerStart();
          setState(() {
            _countdownTime = 60;
          });
          //开始倒计时
          startCountdownTimer();
        }
      },
      child: Container(
        child: Text(
          _countdownTime > 0 ? '$_countdownTime秒后重新获取' : '发送验证码',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFFFF7F0F),
          ),
        ),
      ),
    );
  }

  void startCountdownTimer() {
    _timer = Timer.periodic(
        Duration(seconds: 1),
        (Timer timer) => {
              setState(() {
                if (_countdownTime < 1) {
                  widget.onTimerFinish();
                  _timer.cancel();
                } else {
                  _countdownTime = _countdownTime - 1;
                }
              })
            });
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }
}
