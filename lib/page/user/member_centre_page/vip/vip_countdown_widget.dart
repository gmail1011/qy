import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_base/flutter_base.dart';

///倒计时
class VIPCountDownWidget extends StatefulWidget {
  final int seconds;
  final Color color;
  final VoidCallback countdownEnd;
  final ValueChanged<int> countdownChange;
  final double fontSize;
  final FontWeight fontWeight;

  const VIPCountDownWidget({
    Key key,
    this.seconds = 10,
    this.countdownEnd,
    this.countdownChange,
    this.fontSize,
    this.color,
    this.fontWeight
  }) : super(key: key);

  @override
  _CountDowntate createState() => _CountDowntate();
}

class _CountDowntate extends State<VIPCountDownWidget> {
  int _seconds;
  var _widgetList = <InlineSpan>[];
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _seconds = widget.seconds;
    updatePage();
  }

  /// 刷新页面
  void updatePage() {
    if (_seconds != 0) {
      _timer?.cancel();
      initTimer();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _seconds--;
        if (widget.countdownChange != null) {
          widget.countdownChange(_seconds);
        }
        if (_seconds == -1) {
          _timer?.cancel();
          _timer = null;
          countdownEnd();
        } else {
          initTimer();
        }
      });
    }
  }

  /// 父级参数变动
  @override
  void didUpdateWidget(VIPCountDownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _seconds = widget.seconds;
    updatePage();
  }

  void countdownEnd() {
    widget.countdownEnd?.call();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
    l.d("VIPCountDownWidget", "dispose");
  }

  initTimer() {
    var timer = constructTime(_seconds);
    var list = timer.split(',');
    _widgetList.clear();
    for (var element in list) {
      var text = WidgetSpan(
        child: Container(
          height: Dimens.pt18,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            element,
            style: TextStyle(
              color: widget.color ?? Color(0xffffe495),
              fontSize: widget.fontSize ?? AppFontSize.fontSize10,
              fontWeight: widget.fontWeight ?? FontWeight.normal,
            ),
          ),
        ),
      );
      _widgetList.add(text);
    }
    if (mounted) {
      setState(() {});
    }
  }

  String constructTime(int seconds) {
    int day = seconds ~/ (3600 * 24);
    int hour = seconds % (3600 * 24) ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    if (day > 0) {
      return formatTime(day) +
          ",:," +
          formatTime(hour) +
          ",:," +
          formatTime(minute) +
          ",:," +
          formatTime(second);
    }
    return formatTime(hour) +
        ",:," +
        formatTime(minute) +
        ",:," +
        formatTime(second);
  }

  ///数字格式化，将 0~9 的时间转换为 00~09
  String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(text: TextSpan(children: _widgetList));
  }
}
